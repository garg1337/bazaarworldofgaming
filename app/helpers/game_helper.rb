module GameHelper

	def best_price(game)
		return game.game_sales.order(saleamt: :asc).first
	end
end
