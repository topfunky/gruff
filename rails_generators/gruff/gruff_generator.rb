class GruffGenerator < Rails::Generator::NamedBase

  attr_reader   :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_singular_name,
                :controller_plural_name,
                :parent_folder_for_require
  alias_method  :controller_file_name,  :controller_singular_name
  alias_method  :controller_table_name, :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super

    # Take controller name from the next argument.
    @controller_name = runtime_args.shift

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_singular_name, @controller_plural_name = inflect_names(base_name)

    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end    
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions controller_class_path, "#{controller_class_name}Controller",
                                                "#{controller_class_name}ControllerTest"

      # Controller, helper, views, and test directories.
      m.directory File.join('app/controllers', controller_class_path)
      m.directory File.join('test/functional', controller_class_path)

      m.template 'controller.rb',
                  File.join('app/controllers',
                            controller_class_path,
                            "#{controller_file_name}_controller.rb")

      # For some reason this doesn't take effect if done in initialize()
      @parent_folder_for_require = @controller_class_path.join('/').gsub(%r%app/controllers/?%, '')
      @parent_folder_for_require += @parent_folder_for_require.blank? ? '' : '/'

      m.template 'functional_test.rb',
                  File.join('test/functional',
                            controller_class_path,
                            "#{controller_file_name}_controller_test.rb")

    end
  end

  protected
    # Override with your own usage banner.
    def banner
      "Usage: #{$0} gruff ControllerName"
    end
end
