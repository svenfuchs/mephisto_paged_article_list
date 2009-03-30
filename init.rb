ActionView::Base.send :include, PagedArticleList::LinkHelpers

require 'paged_article_list/mephisto_controller'

config.to_prepare do
  # MephistoController.send :include, PagedArticleList::MephistoController
  Liquid::Template.register_filter(PagedArticleList::LinkHelpers)
end

