module GameHelper

	def best_price(game)
		best = nil
		if(game != nil)
    		game.game_sales.each do |sale|
        		if best == nil || (sale.saleamt < best.saleamt)
           			best=sale
        		end
        	end
        end
        return best
	end
end
