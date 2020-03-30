class RoomsController < ApplicationController
  before_action :authenticate_user!

    def index
      logger.debug("rooms#indexに入りました")

    end
    

    def show
      logger.debug("rooms#showに入りました")

    end
    
end
