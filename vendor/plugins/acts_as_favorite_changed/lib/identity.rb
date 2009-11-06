module ActsAsFavorite
  module Identity
  
    module UserExtensions
      module InstanceMethods

        def method_missing( method_sym, *args )
          # if method_sym.to_s =~ Regexp.new("^favorite_(\\w+)")
          if !method_sym.to_s.scan(Regexp.new("^favorite_(\\w+)")).blank?
            #favorite_class = ($1).singularize.classify.constantize
            favorite_class = ($1).singularize.capitalize.constantize
            favorite_class.find(:all, :include => :favorites,
                                :conditions => ['favorites.user_id = ? AND favorites.favorable_type = ?', 
                                                id, favorite_class.to_s ] )
          elsif method_sym.to_s =~ Regexp.new("^has_favorite_(\\w+)\\?")
            favorite_class = ($1).singularize.classify.constantize
            Favorite.count( :include => :user, :conditions => [ 'favorites.user_id = ? AND favorites.favorable_type = ?', 
                                                                id, favorite_class.to_s ] ) != 0
          else
            super
          end
        rescue
          super
        end
        
      end
    end
    
  end
end