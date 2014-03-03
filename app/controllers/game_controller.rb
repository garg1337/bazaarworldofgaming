
include GameSearchHelper 
class GameController < ApplicationController
  
  def search
  	#@results = Game.find_by_title(params[:stuff])
  	@results = GameSearchHelper.find_game(params[:stuff])
  end

  def show
  	@game = Game.find(params[:id])

  end


end
