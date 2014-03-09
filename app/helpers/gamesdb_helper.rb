require 'nokogiri'
require 'open-uri'
require 'timeout'

module GamesdbHelper
	GAME_REQUEST_BASE_URL = 'http://thegamesdb.net/api/GetGame.php?id=' 
	GAME_BASE_IMAGE_URL = "http://thegamesdb.net/banners/"
	METACRITIC_REQUEST_BASE_URL = 'http://www.metacritic.com/game/'
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


	def self.title_to_metacritic_title(title)
		metacritic_title = (title.downcase)
		metacritic_title.gsub!("---", '-')
		metacritic_title.gsub!(' - ', '---')
		metacritic_title.gsub!(': ', '-')
		metacritic_title.gsub!(' ', '-')
		metacritic_title.gsub!('_', '-')
		metacritic_title.gsub!("'", '')
		return metacritic_title
	end

  	def self.build_metacritic_url(title,platform="PC")
		metacritic_title = title_to_metacritic_title(title)

		console_metacritic = CONSOLE_TO_METACRITIC_MAP[platform]
		metacritic_url = "#{METACRITIC_REQUEST_BASE_URL}#{console_metacritic}/#{metacritic_title}"

		if metacritic_url.include? "viva-pi"
			puts("Known Issue")
			metacritic_url = "http://www.metacritic.com/game/xbox-360/viva-pinata-trouble-in-paradise"
		end


		if metacritic_url.include? "[platinum-hits]"
			puts("Known Issue(platinum-hits)")
			return nil
		end

		if metacritic_url.include? "combo-pack"
			puts("Known Issue(combo-pack)")
			return nil
		end

		if (metacritic_url == "http://www.metacritic.com/game/pc/mission-against-terror")
			return nil
		end

		return metacritic_url
	end
  
  	def self.retrieve_metacritic_score(url)
    	begin
			result = Nokogiri::HTML(open(url))
			score = result.css("div.metascore_w.xlarge")[0]
			if score != nil
				score = score.css('span')
				score = /.*<span itemprop="ratingValue">(.*)<\/span>.*/.match(score.to_s)
				if score != nil
					return score[1]
				end
			end
		rescue Exception => ex
			puts("score fubar'd")
		end

		return "n/a"
  end
end
