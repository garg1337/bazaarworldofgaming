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
      if game == nil
        puts "NO GAME FOUND"

        next
      end
      if !get_avaibility(row)
        next
      end
      prices = parse_price_chunk(row)
      sale_price = prices[0]
      original_price = prices[1]
      puts title
      puts original_price
      puts sale_price
      puts "game found!"
      original_price = '%.2f' %  original_price.delete( "$" ).to_f
      sale_price = '%.2f' %  sale_price.delete( "$" ).to_f
      product_url = parse_url(row)

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

  def self.extract_page_info(product_url)

    result = RestClient.get(product_url)
    result = Nokogiri::HTML(result)



    # File.open("db/test_files/" + product_url +".html", 'w') { |file| file.write(result.to_s) }


    parse_products_off_result_page(result)




    next_url_chunk = result.css(".pagnNext").to_s
    next_url_start = next_url_chunk.index('<a href="')
    next_url_end = next_url_chunk.index('" class')
    next_url = next_url_chunk[next_url_start+9...next_url_end]

    next_url_chunks = next_url.split("&amp;")

    next_url = "";

    next_url_chunks.each do |url_chunk|
      next_url = next_url + "&" + url_chunk
    end

    next_url = next_url[1...next_url.length]

    puts next_url
    puts "\n"
  end
end
