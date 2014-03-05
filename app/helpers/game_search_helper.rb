require 'nokogiri'
require 'open-uri'
require 'timeout'
require 'restclient'


module GameSearchHelper
    
  def self.find_game(title)
    words_list = title.scan /[[:alnum:]]+/
    delChar(words_list)

    search_title = StringHelper.create_search_title(title)
    # puts "search_title = " + search_title
    exact_matches = Game.where("search_title LIKE ?", "%" + search_title + "%")
    
    series_matches = []
    series_name = handleColon(title)
    if series_name != nil
      series_search_title = StringHelper.create_search_title(series_name)
      series_matches = Game.where("search_title LIKE ?", "%" + series_search_title + "%")
    end

    partial_matches = getGameLisPartialMatch(words_list)

    return exact_matches | series_matches | partial_matches
  end


  def self.find_and_filter_games(title, user)
    games_list = GameSearchHelper.find_game(title)
    already_owned = user.games
    return games_list - already_owned
  end



  def self.filter_games_by_metacritic(games_list, lower_bound, upper_bound)
    filtered_results = Array.new
    games_list.each do |game|
      rating = game.metacritic_rating.to_i
      if (rating >= lower_bound and rating <= upper_bound)
        filtered_results.push(game)
      end
    end

    return filtered_results
  end


  def self.sort_games_by_metacritic_asc(games_list)
    return games_list.sort{|x,y| x.metacritic_rating.to_i <=> y.metacritic_rating.to_i}
  end

  def self.sort_games_by_metacritic_desc(games_list)
    return games_list.sort{|x,y| y.metacritic_rating.to_i <=> x.metacritic_rating.to_i}
  end






  def self.getGameLisPartialMatch(words_list)
    counts = Hash.new(0)
    words_list.each do |word|
      games_found = Game.where("search_title LIKE ?", "%" + word + "%")
      games_found.each do |game|
        counts[game] = counts[game] + 1
      end
    end

    sorted_list = counts.sort_by{|k,v| -v}
    games_list = []
    sorted_list.each do |entry|
      games_list << entry.first
    end

    return games_list
  end

  def self.handleColon(title)
    idx = title.index(':')
    if idx == nil 
      return nil
    else 
      return title[0..idx-1]
    end
  end  

  def self.delChar(words_list)
    words_list.delete_if { |c| c.length < 2}
  end

end