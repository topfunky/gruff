require File.dirname(__FILE__) + "/gruff_test_case"

class TestLabelsForNullData < GruffTestCase

  def setup
    @dataset = [nil, 1, 2, 1, nil]

    @labels = {
        0 => '1',
        1 => '2',
        2 => '3',
        3 => '4',
        4 => '5'
    }
  end

  def test_labels
    g = Gruff::Line.new
    g.title = 'Labels For Null Data'
    g.labels = @labels
    g.data('data', @dataset)
    g.minimum_value = 0
    
    g.write("test/output/TestLabelsForNullData.png")
  end

end
