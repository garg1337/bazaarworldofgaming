require 'spec_helper'

describe GameSearchHelper do

	it "should have halo" do
		puts "number of games: " + Game.all.size.to_s
		games_list = GameSearchHelper.find_game("halo")
		games_list.each do |game|
			puts game[:search_title]
		end
		expect(games_list.first[:search_title]).to eq("halo combat evolved")
 	end

 	describe "Tests for function delChar" do

 		it "should be empty" do
	 		words_list = ["a", "b", "c", "d", "e"]
	 		GameSearchHelper.delChar(words_list)
 		end

 		it "should have only one element ef left" do
 			words_list = ["a", "b", "c", "d", "ef"]
	 		GameSearchHelper.delChar(words_list)
 		end

 		it "should have two elements left" do
 			words_list = ["aa", "b", "c", "d", "ef"]
	 		GameSearchHelper.delChar(words_list)
 		end

 	end
end
