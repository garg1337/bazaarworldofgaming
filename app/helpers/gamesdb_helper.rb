require 'nokogiri'
require 'open-uri'
require 'timeout'

module GamesdbHelper
	GAME_REQUEST_BASE_URL = 'http://thegamesdb.net/api/GetGame.php?id=' 
	METACRITIC_REQUEST_BASE_URL = 'http://www.metacritic.com/game/'
	GAME_BASE_IMAGE_URL = "http://thegamesdb.net/banners/"
	CONSOLE_TO_METACRITIC_MAP = Hash.new("fubar")
	CONSOLE_TO_METACRITIC_MAP["PC"] = "pc"

	def self.get_game_genre(url)
		request = Nokogiri::XML(open(url))

		genres_noko = request.xpath("//genre")
		genres = []

		for i in 0..genres_noko.length - 1
			genres[i] = /.*<genre>(.*)<\/genre>.*/.match(genres_noko[i].to_s)[1]
		end
		return genres
	end

	def self.game_exists_in_db?(title, platform)
		puts "Checking DB..."
		test = Game.where("title = ?", title).first
		if test != nil
			puts("Game already in")
			return true
		end
		return false
	end

	def self.fetch_game_info(gameid,client)
 		result = {}
		game = client.get_game(gameid)["Game"]



		request_url = "#{GAME_REQUEST_BASE_URL}#{gameid}"


		result[:title] = game["GameTitle"]
		result[:release_date] = game["ReleaseDate"]
		result[:description] = game["Overview"]
		result[:esrb_rating] = game["ESRB"]
		result[:players] = game["Players"]
		result[:coop] = game["Co-op"]
		result[:platform] = game["Platform"]
		result[:publisher] = game["Publisher"]
		result[:developer] = game["Developer"]

		boxart_url_end = game["Images"]["boxart"]
		result[:image_url] = "#{GAME_BASE_IMAGE_URL}#{boxart_url_end}"


		result[:genres] = get_game_genre(request_url)

		return result
	end
end
