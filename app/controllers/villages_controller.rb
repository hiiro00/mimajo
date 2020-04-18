class VillagesController < ApplicationController
  before_action :authenticate_user!
  
    def board
      logger.debug("Villages#boardに入りました")

    end
    

    def show
      logger.debug("Villages#showに入りました")

    end

    def index
      logger.debug("Villages#indexに入りました")
      
      # お題　作成
      @theme = Theme.where( 'id >= ?', rand(Theme.first.id..Theme.last.id) ).first.content
      
    end

end
