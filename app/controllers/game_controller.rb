
include GameSearchHelper 
class GameController < ApplicationController
  
  def search
  	#@results = Game.find_by_title(params[:stuff])
	@results = GameSearchHelper.find_game(params[:stuff])
	if params[:method] == '1'
		@results = GameSearchHelper.sort_games_by_metacritic_desc(@results)
	end
	if params[:method] == '2'
		@results = GameSearchHelper.sort_games_by_metacritic_asc(@results)
	end
	@results = GameSearchHelper.filter_games_by_metacritic(@results,params[:low].to_i,params[:high].to_i)
  end


  def show
  	@game = Game.find(params[:id])
  	@currentID = params[:id]

  end

  def add
  	@blah = Game.find(params[:gameid])
  	if current_user != nil
      if current_user.games.find_by_title(@blah.title) == nil
  		  current_user.games << @blah
        flash[:success] = "Game added successfully"
      end
  	end
  	redirect_to :back
  end
end