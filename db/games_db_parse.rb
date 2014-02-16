# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)


require 'nokogiri'
require 'open-uri'
require 'timeout'


# Game.delete_all

GAME_REQUEST_BASE_URL = 'http://thegamesdb.net/api/GetGame.php?id=' 

METACRITIC_REQUEST_BASE_URL = 'http://www.metacritic.com/game/'

GAME_BASE_IMAGE_URL = "http://thegamesdb.net/banners/"



VIABLE_CONSOLE_LIST = ["PC"]

CONSOLE_TO_METACRITIC_MAP = Hash.new("fubar")

CONSOLE_TO_METACRITIC_MAP["PC"] = "pc"



	@client = Gamesdb::Client.new
 	platforms = @client.platforms.all


	platforms.each do |platform| unless !(VIABLE_CONSOLE_LIST.include?(platform.name))
		puts(platform.name)
		puts("in it")
		platform_games_wrapper = @client.get_platform_games(platform.id)
		platform_games = platform_games_wrapper["Game"]
		if (!(platform_games.nil?) && platform.id != "4914")
			platform_games.each do |platform_game|
				gameinfo = GamesdbHelper.fetch_game_info(platform_game["id"],@client)
				if gameinfo.nil?
					next
				end

				metacritic_url = GamesdbHelper.build_metacritic_url(gameinfo[:title], gameinfo[:platform])

				if metacritic_url.nil?
					next
				end

				puts(metacritic_url)

				if (metacritic_url == "http://www.metacritic.com/game/pc/mission-against-terror")
					next
				end

				score = GamesdbHelper.retrieve_metacrtic_score(metacritic_url)

				puts score

				gameinfo[:search_title] = StringHelper.create_search_title(gameinfo[:title])

				g = Game.create!(gameinfo)
			
				puts(g.title)

			end
		end
	end
end




