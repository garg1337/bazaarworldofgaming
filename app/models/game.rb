class Game < ActiveRecord::Base
  serialize :genres, Array
  attr_accessible :search_title, :coop, :description, :developer, :esrb_rating, :genres, :image_url, :metacritic_rating, :players, :publisher, :release_date, :title
  validates :title,  presence: true
  validates :search_title,  presence: true
  

  has_many :game_sales, dependent: :destroy
  has_many :game_sale_histories, dependent: :destroy
  has_many :alerts, dependent: :destroy





def get_lowest_sale
	min_sale = nil
	game_sales.each do |sale|
		saleamt = sale.saleamt.to_f
		if min_sale == nil or min_sale.saleamt.to_f > saleamt.to_f
			min_sale = sale
		end
	end

	return min_sale
end



def get_lowest_sale_per_vendor

 	results = []


 	steam_sales = game_sales.where(["store = ?", "Steam"])
 	min_steam_sale = nil

 	steam_sales.each do |sale|
 		saleamt = sale.saleamt.to_f


 		if min_steam_sale == nil or min_steam_sale.saleamt.to_f > saleamt.to_f
 			min_steam_sale = sale
 		end

end


 	amazon_sales = game_sales.where(["store = ?", "Amazon"])
 	min_amazon_sale = nil

 	amazon_sales.each do |sale|
 		saleamt = sale.saleamt.to_f


 		if min_amazon_sale == nil or min_amazon_sale.saleamt.to_f > saleamt.to_f
 			min_amazon_sale = sale
 		end
 		
 	end

 	gmg_sales = game_sales.where(["store = ?", "GMG"])
 	min_gmg_sale = nil

 	gmg_sales.each do |sale|
 		saleamt = sale.saleamt.to_f


 		if min_gmg_sale == nil or min_gmg_sale.saleamt.to_f > saleamt.to_f
 			min_gmg_sale = sale
 		end
 		
 	end


 	if min_steam_sale != nil
 		results.push(min_steam_sale)
 	end

 	if min_amazon_sale != nil
 		results.push(min_amazon_sale)
 	end

 	if min_gmg_sale != nil
 		results.push(min_gmg_sale)
 	end

 	return results


 end








end
