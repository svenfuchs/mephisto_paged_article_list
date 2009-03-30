module PagedArticleList  
  module LinkHelpers
    include ActionView::Helpers::TagHelper
  
    def prev_next_page_links(pager, path_info, *options)
      return '' if path_info.nil?
      options.unshift 'newer posts &raquo;', '&laquo; older posts' if options.size < 2
      text, sep = {:prev => options[0], :next => options[1]}, options[2]
      links = [:prev, :next].collect do |direction|
        eval("link_to_#{direction}_page(pager, path_info, text[direction])") 
      end.compact
      links.insert(1, sep) unless links.size < 2 || sep.nil?
      links.reverse.join ' '      
    end
  
    def link_to_prev_page(pager, path_info, text = 'newer posts &raquo;')
      return if pager.current_page == 1
      content_tag :a, text, :href => path_for(path_info, pager.current_page - 1), :class => 'prev'
    end

    def link_to_next_page(pager, path_info, text = '&laquo; older posts')
      return if pager.current_page == pager.page_count
      content_tag :a, text, :href => path_for(path_info, pager.current_page + 1), :class => 'next'
    end
  end
end