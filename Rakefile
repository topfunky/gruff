require 'rubygems'
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rake/clean'

CLEAN.concat %w(pkg test/output/*)

desc 'Run tests'
task :default => :test

task :gem => :build

Rake::TestTask.new

namespace :test do
  desc 'Run mini tests'
  task :mini => :clean do
    Dir['test/test_mini*'].each do |file|
      system "ruby #{file}"
    end
  end
end

desc 'Generate release docs for a given milestone'
task :release_docs do
  raise "\n    This task requires Ruby 1.9 or newer to parse JSON as YAML.\n\n" if RUBY_VERSION == '1.8.7'
  categories, grouped_issues, milestone, milestone_description, milestone_name = get_github_issues

  puts '=' * 80
  puts
  release_doc = <<EOF
Subject: [ANN] Gruff #{milestone_name} released!

The Gruff team is pleased to announce the release of Gruff #{milestone_name}.

New in version #{milestone_name}:

#{milestone_description}

#{(categories.keys & grouped_issues.keys).map do |cat|
    "#{cat}:\n
#{grouped_issues[cat].map { |i| wrap(%Q{* Issue ##{i['number']} #{i['title']}},2) }.join("\n")}
    "
  end.join("\n")}
You can find a complete list of issues here:

* https://github.com/topfunky/gruff/issues?state=closed&milestone=#{milestone}


Installation:

    gem install gruff

You can find an introductory tutorial at
https://github.com/topfunky/gruff

Enjoy!


--
The Gruff Team
EOF

  puts release_doc
  puts
  puts '=' * 80

  unless Gem::Version.new(Gruff::VERSION).prerelease?
    File.write('RELEASE.md', release_doc)
  end
end

desc 'Fetch download stats form rubygems.org'
task :stats do
  require 'time'
  require 'date'
  require 'rubygems'
  require 'uri'
  require 'net/http'
  require 'net/https'
  require 'openssl'
  require 'yaml'
  host = 'rubygems.org'
  base_uri = "https://#{host}/api/v1"
  https = Net::HTTP.new(host, 443)
  https.use_ssl = true
  https.verify_mode = OpenSSL::SSL::VERIFY_NONE

  counts_per_month = Hash.new { |h, k| h[k] = Hash.new { |mh, mk| mh[mk] = 0 } }
  total = 0

  %w{gruff}.each do |gem|
    versions_uri = URI("#{base_uri}/versions/#{gem}.yaml")
    req = Net::HTTP::Get.new(versions_uri.request_uri)
    res = https.start { |http| http.request(req) }
    versions = YAML.load(res.body).sort_by { |v| Gem::Version.new(v['number']) }
    puts "\n#{gem}:\n#{versions.map { |v| "#{Time.parse(v['built_at']).strftime('%Y-%m-%d')} #{'%10s' % v['number']} #{v['downloads_count']}" }.join("\n")}"

    versions.each do |v|
      downloads_uri = URI("#{base_uri}/versions/#{gem}-#{v['number']}/downloads/search.yaml?from=#{Time.parse(v['built_at']).strftime('%Y-%m-%d')}&to=#{Date.today}")
      req = Net::HTTP::Get.new(downloads_uri.request_uri)
      res = https.start { |http| http.request(req) }
      counts = YAML.load(res.body)
      counts.delete_if { |date_str, count| count == 0 }
      counts.each do |date_str, count|
        date = Date.parse(date_str)
        counts_per_month[date.year][date.month] += count
        total += count
      end
      print '.'; STDOUT.flush
    end
    puts
  end

  puts "\nDownloads statistics per month:"
  years = counts_per_month.keys
  puts "\n    #{years.map { |year| '%6s:' % year }.join(' ')}"
  (1..12).each do |month|
    print "#{'%2d' % month}:"
    years.each do |year|
      count = counts_per_month[year][month]
      print count > 0 ? '%8d' % count : ' ' * 8
    end
    puts
  end

  puts "\nTotal: #{total}\n\n"

  puts "\nRubyGems download statistics per month:"
  years = counts_per_month.keys
  puts '    ' + years.map { |year| '%-12s' % year }.join
  (0..20).each do |l|
    print (l % 10 == 0) ? '%4d' % ((20-l) * 100) : '    '
    years.each do |year|
      (1..12).each do |month|
        count = counts_per_month[year][month]
        if [year, month] == [Date.today.year, Date.today.month]
          count *= (Date.new(Date.today.year, Date.today.month, -1).day.to_f / Date.today.day).to_i
        end
        print count > ((20-l) * 100) ? '*' : ' '
      end
    end
    puts
  end
  puts '    ' + years.map { |year| '%-12s' % year }.join

  puts "\nTotal: #{total}\n\n"
end


def get_github_issues
  puts 'GitHub login:'
  begin
    require 'rubygems'
    require 'highline/import'
    user = ask('login   : ') { |q| q.echo = true }
    pass = ask('password: ') { |q| q.echo = '*' }
  rescue Exception
    print 'user name: '; user = STDIN.gets.chomp
    print ' password: '; pass = STDIN.gets.chomp
  end
  require 'uri'
  require 'net/http'
  require 'net/https'
  require 'openssl'
  require 'yaml'
  host = 'api.github.com'
  base_uri = "https://#{host}/repos/topfunky/gruff"
  https = Net::HTTP.new(host, 443)
  https.use_ssl = true
  https.verify_mode = OpenSSL::SSL::VERIFY_NONE

  milestone_uri = URI("#{base_uri}/milestones")
  req = Net::HTTP::Get.new(milestone_uri.request_uri)
  req.basic_auth(user, pass)
  res = https.start { |http| http.request(req) }
  milestones = YAML.load(res.body).sort_by { |i| Date.parse(i['due_on']) }
  puts milestones.map { |m| "#{'%2d' % m['number']} #{m['title']}" }.join("\n")

  if defined? ask
    milestone = ask('milestone: ', Integer) { |q| q.echo = true }
  else
    print 'milestone: '; milestone = STDIN.gets.chomp
  end

  uri = URI("#{base_uri}/issues?milestone=#{milestone}&state=closed&per_page=1000")
  req = Net::HTTP::Get.new(uri.request_uri)
  req.basic_auth(user, pass)
  res = https.start { |http| http.request(req) }
  issues = YAML.load(res.body).sort_by { |i| i['number'] }
  milestone_name = issues[0] ? issues[0]['milestone']['title'] : "No issues for milestone #{milestone}"
  milestone_description = issues[0] ? issues[0]['milestone']['description'] : "No issues for milestone #{milestone}"
  milestone_description = milestone_description.split("\r\n").map{|l|wrap l}.join("\r\n")
  categories = {
      'Features' => 'feature', 'Bugfixes' => 'bug', 'Support' => 'support',
      'Documentation' => 'documentation', 'Pull requests' => nil,
      'Internal' => 'internal', 'Rejected' => 'rejected', 'Other' => nil
  }
  grouped_issues = issues.group_by do |i|
    labels = i['labels'].map { |l| l['name'] }
    cat = nil
    categories.each do |k, v|
      if labels.include? v
        cat = k
        break
      end
    end
    cat ||= i['pull_request'] && i['pull_request']['html_url'] && 'Pull requests'
    cat ||= 'Other'
    cat
  end
  return categories, grouped_issues, milestone, milestone_description, milestone_name
end

def wrap(string, indent = 0)
  string.scan(/\S.{0,72}\S(?=\s|$)|\S+/).join("\n" + ' ' * indent)
end

