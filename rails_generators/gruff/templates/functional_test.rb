require File.dirname(__FILE__) + '<%= '/..' * controller_class_name.split("::").length %>/test_helper'
require '<%= parent_folder_for_require %><%= controller_file_name %>_controller'

# Re-raise errors caught by the controller.
class <%= controller_class_name %>Controller; def rescue_action(e) raise e end; end

class <%= controller_class_name %>ControllerTest < Test::Unit::TestCase

  #fixtures :data

  def setup
    @controller = <%= controller_class_name %>Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # TODO Replace this with your actual tests
  def test_show
    get :show
    assert_response :success
    assert_equal 'image/png', @response.headers['Content-Type']
  end
  
end
