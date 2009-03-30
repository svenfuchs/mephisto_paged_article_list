module PagedArticleList    
  module MephistoController
    include_into 'MephistoController', :dispatch_list => :paging, 
                                       :dispatch_tags => :paging

    def self.included(base)
      base.class_eval do 
        before_filter :extract_page_param   
        # alias_method :dispatch_list, :dispatch_list_with_paging
        # alias_method :dispatch_tags, :dispatch_tags_with_paging
      end   
    end
    
    def extract_page_param
      return if (path = params['path']).blank?      
      unless (i = path.index 'page').nil?
        params['page'] = path[i + 1]
        params['path'] = path[0, i] || [] 
      end
    end  
    
    def dispatch_list_with_paging
      @articles = @section.articles.paginate(:include => :user,
        :conditions => ['contents.published_at <= ? AND contents.published_at IS NOT NULL', Time.now.utc],
        :order => 'published_at DESC', 
        :per_page => @section.articles_per_page, :page => params[:page])        

      render_liquid_template_for(@section.show_paged_articles? ? :page : :section, 
        'section'  => @section.to_liquid(true),
        'articles' => @articles,
        'path_info' => {:path => @section.path}) 
    end
    
    def dispatch_tags_with_paging
      article_ids = site.articles.find(:all, :select => ['contents.id'], 
        :joins => "LEFT OUTER JOIN taggings ON (taggings.taggable_id = contents.id AND taggings.taggable_type = 'Content') LEFT OUTER JOIN tags ON tags.id = taggings.tag_id", 
        :conditions => ['(contents.published_at <= ? AND contents.published_at IS NOT NULL) AND tags.name IN (?)', Time.now.utc, @dispatch_path]
        ).collect {|article| article.id}      
      
      @articles = site.articles.paginate(:include => [:tags, :user, :sections],
        :conditions => ['contents.id IN (?)', article_ids],
        :order => 'contents.published_at DESC', 
        :per_page => site.articles_per_page, :page => params[:page])
      
      render_liquid_template_for(:tag, 
        'articles' => @articles, 
        'path_info' => {:path => "tags/#{@dispatch_path}"}) 
    end
  end
end