#!ruby

require 'chunky_png'

class ImageCompare
  include ChunkyPNG::Color

  def self.compare(file_name, old_file_name)
    name = file_name.chomp('.png')
    org_file_name = "#{name}_0.png~"
    new_file_name = "#{name}_1.png~"

    return nil unless File.exists? old_file_name
    images = [
        ChunkyPNG::Image.from_file(old_file_name),
        ChunkyPNG::Image.from_file(file_name),
    ]

    sizes = images.map(&:width).uniq + images.map(&:height).uniq
    if sizes.size != 2
      logger.warn "Image size has changed for #{name}: #{sizes}"
      return nil
    end

    diff = []
    images.first.height.times do |y|
      images.first.row(y).each_with_index do |pixel, x|
        unless pixel == images.last[x, y]
          diff << [x, y]
        end
      end
    end

    if diff.empty?
      File.delete(org_file_name) if File.exists? org_file_name
      File.delete(new_file_name) if File.exists? new_file_name
      return false
    end

    x, y = diff.map { |xy| xy[0] }, diff.map { |xy| xy[1] }
    (1..2).each do |i|
      images.each do |image|
        image.rect(x.min - i, y.min - i, x.max + i, y.max + i, ChunkyPNG::Color.rgb(255, 0, 0))
      end
    end
    images.first.save(org_file_name)
    images.last.save(new_file_name)
    true
  end
end

if $0 == __FILE__
  unless ARGV.size == 2
    puts "Usage:  #$0 <image1> <image2>"
    exit 1
  end
  ImageCompare.compare(ARGV[0], ARGV[1])
end
