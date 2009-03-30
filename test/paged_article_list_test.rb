require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

require 'mephisto_controller'

class PagedArticleListTest < Test::Unit::TestCase
  def test_should_add_methods_to_mephisto_controller
    assert_equal true, MephistoController.method_defined?(:dispatch_list_with_paging)
  end
end
