require 'nokogiri'
require 'open-uri'
require 'timeout'

module GamesdbHelper

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

		if game_exists_in_db?(result[:title],result[:platform])
			return nil
		end

		boxart_url_end = game["Images"]["boxart"]
		result[:image_url] = "#{GAME_BASE_IMAGE_URL}#{boxart_url_end}"


		result[:genres] = get_game_genre(request_url)

		return result
	end

	def self.build_metacritic_url(title, platform)
		metacritic_title = (title.downcase)
		metacritic_title.gsub!("---", '-')
		metacritic_title.gsub!(' - ', '---')
		metacritic_title.gsub!(': ', '-')
		metacritic_title.gsub!(' ', '-')
		metacritic_title.gsub!('_', '-')
		metacritic_title.gsub!("'", '')

		console_metacritic = CONSOLE_TO_METACRITIC_MAP[platform]
		url = "#{METACRITIC_REQUEST_BASE_URL}#{console_metacritic}/#{metacritic_title}"

		if url.include? "viva-pi"
			puts("fixing this shit")
			url = "http://www.metacritic.com/game/xbox-360/viva-pinata-trouble-in-paradise"
		end

		if url.include?("[platinum-hits]") || url.include?("combo-pack")
			puts("fixing this shit")
			return nil
		end

		return url
	end

	def self.retrieve_metacrtic_score(url)
		begin
			request = Nokogiri::HTML(open(url))
			puts("requested page")
			score = request.css("div.metascore_w.xlarge")[0]
			if score != nil
				score = score.css('span')
				score = /.*<span itemprop="ratingValue">(.*)<\/span>.*/.match(score.to_s)
					if score != nil
						return score[1]
					end
			end
		rescue Exception => ex
			puts("score fubar'd")
			puts ex
		end
		return "0"
	end
end
