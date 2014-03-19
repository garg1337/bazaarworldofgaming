require 'nokogiri'
require 'open-uri'
require 'timeout'
require 'restclient'


module AmazonHelper


  def self.parse_title(row)
      title = row.css(".productTitle")
      title = title.to_s
      title_encode = title.encode("UTF-8", invalid: :replace, undef: :replace)
      if !(title_encode.valid_encoding?)
        puts "Title encoding error!"
        return nil
      end
      if (!title.include? "[")
        return nil
      end
      if(title.include? "MAC")
        puts "Not avaliable on PC!"
        return nil
      end
      title_start = title.index('<br clear="all">')
      title_end = title.index("[")
      title = title[title_start+16...title_end]
      puts title
      return title

  end

  def self.get_avaibility(row)
     if row.to_s.include? "Sign up to be notified when this item becomes available."
        return false
      end

      if row.to_s.include? "Currently unavailable"
        return false
      end
      return true
  end

  def self.parse_sale_price(price_chunk)
      sale_price_start = price_chunk.index("<span>")
      sale_price_end = price_chunk.index("</span>")
      return price_chunk[sale_price_start+6...sale_price_end]
         
  end

  def self.parse_price_chunk(row)
      price_chunk = row.css(".newPrice").to_s
      sale_price = parse_sale_price(price_chunk)
      original_price = sale_price
      if price_chunk.include? "<strike>"
        original_price = parse_original_price(price_chunk)
      end
      return [sale_price, original_price]

  end

  def self.parse_original_price(price_chunk)
        original_price_start = price_chunk.index("<strike>")
        original_price_end = price_chunk.index("</strike>")
        return price_chunk[original_price_start+8...original_price_end]
  end


  def self.parse_url(row)
      product_url = row.css(".productTitle").css("a")[0].to_s
      link_start = product_url.index('<a href="')
      link_end = product_url.index('">')
      return product_url[link_start+9...link_end]


  end

  def self.parse_rating(product_html)
    page_s = product_html.to_s
    rating_start = page_s.index("esrbPopOver")
    if rating_start != nil
      rating = page_s[rating_start...page_s.length]
      start_index = rating.index("<span")
      end_index = rating.index("</span>")
      rating = rating[start_index+31...end_index]
      return rating
    end

  end

  def self.parse_developer(product_html)
    page_s = product_html.to_s
    developer_start = page_s.index('ptBrand')
    if developer_start != nil
      developer = page_s[developer_start...page_s.length]
      start_index = developer.index('by')
      end_index = developer.index("</span>")
      developer = developer[start_index+3...end_index]
      return developer
    end

  end

  def self.parse_date(product_html)
    page_s = product_html.to_s
    date_start = page_s.index("Release Date")
    if date_start != nil
      date = page_s[date_start...page_s.length]
      start_index = date.index('</b>')
      end_index = date.index("</li>")
      date = date[start_index+5...end_index]
      return date
    end

  end

  def self.parse_box_art(product_html)
    page_s = product_html.to_s
    img_start = page_s.index('id="main-image"')
    if img_start != nil
      img = page_s[img_start...page_s.length]
      start_index = img.index('src=')
      end_index = img.index("alt")
      img = img[start_index+5...end_index-2]
      return img
    end

  end



  def self.parse_game_page(product_url)
      result = RestClient.get(product_url)
      return Nokogiri::HTML(result)
    
  end

  def self.parse_description(product_html)
      page_s = product_html.to_s
      start_index = page_s.index('<div class="productDescriptionWrapper">');
      if start_index != nil
        description = page_s[start_index...page_s.length]
        start_index = description.index(">")
        end_index = description.index("</div>")
        return description[start_index+1...end_index]
      end
  end

  def self.parse_products_off_result_page(result)
    rows = result.css(".result.product")
    rows.each do |row|
      title = parse_title(row)
      if title == nil
        puts "Title not found."
        next
      end
      #seeing if we find a match
      search_title = StringHelper.create_search_title(title)
      #game_description = parse_description(row)
      game = GameSearchHelper.find_right_game(search_title, "")
      product_url = parse_url(row)
      if game == nil
        #put new game into the database
	#parse description, espn rating, boxart, developer, metacritic
        game_page_result = parse_game_page(product_url)
        mcurl = GamesdbHelper.build_metacritic_url(title)
        metacritic_rating = GamesdbHelper.retrieve_metacritic_score(mcurl)
        release_date = parse_date(game_page_result)
        game_description = parse_description(game_page_result)
        box_art_url = parse_box_art(game_page_result)
        game = Game.create!(title: title, release_date: release_date, 
                            description: game_description,  publisher: nil, developer: nil, 
                            genres: nil, image_url: box_art_url, search_title: search_title, 
                            metacritic_rating: metacritic_rating)
        puts "Game Added To Database"

        next
      end
      if !get_avaibility(row)
        next
      end
      prices = parse_price_chunk(row)
      sale_price = prices[0]
      original_price = prices[1]
      #puts title
      #puts original_price
      #puts sale_price
      #puts "game found!"
      original_price = '%.2f' %  original_price.delete( "$" ).to_f
      sale_price = '%.2f' %  sale_price.delete( "$" ).to_f
      puts product_url
      game_sale = game.game_sales.create!(store: "Amazon", 
                                          url: product_url, 
                                          origamt: original_price, 
                                          saleamt: sale_price,
                                          occurrence: DateTime.now)
      game_sale_history = game.game_sale_histories.create!(store: "Amazon",
                                                           price: sale_price,
                                                           occurred: DateTime.now)

    end
  end

end
