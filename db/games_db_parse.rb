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

def get_game_genre(url)
	request = Nokogiri::XML(open(url))

	genres_noko = request.xpath("//genre")
	genres = []

	for i in 0..genres_noko.length - 1
		genres[i] = /.*<genre>(.*)<\/genre>.*/.match(genres_noko[i].to_s)[1]
	end
	return genres
end

def game_exists_in_db?(title, platform)
	puts "Checking DB..."
	test = Game.where("title = ?", title).first
	if test != nil
		puts("Game already in")
		return true
	end
	return false
end

def fetch_game_info(gameid)
	result = {}
	game = @client.get_game(gameid)["Game"]



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

def build_metacritic_url(title, platform)
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

def retrieve_metacrtic_score(url)
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

 	platforms = @client.platforms.all


	platforms.each do |platform| unless !(VIABLE_CONSOLE_LIST.include?(platform.name))
		puts(platform.name)
		puts("in it")
		platform_games_wrapper = @client.get_platform_games(platform.id)
		platform_games = platform_games_wrapper["Game"]
		if (!(platform_games.nil?) && platform.id != "4914")
			platform_games.each do |platform_game|
				gameinfo = fetch_game_info(platform_game["id"])
				
				if gameinfo.nil?
					next
				end

				metacritic_url = build_metacritic_url(gameinfo[:title], gameinfo[:platform])

				if metacritic_url.nil?
					next
				end

				puts(metacritic_url)

				if (metacritic_url == "http://www.metacritic.com/game/pc/mission-against-terror")
					next
				end

				score = retrieve_metacrtic_score(metacritic_url)

				puts score

				gameinfo[:search_title] = StringHelper.create_search_title(gameinfo[:title])

				g = Game.create!(gameinfo)
			
				puts(g.title)

			end
		end
	end
end




