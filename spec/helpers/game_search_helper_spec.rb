require 'spec_helper'

describe GameSearchHelper do

	it "should have two halo games" do
		# puts "number of games: " + Game.all.size.to_s
		games_list = GameSearchHelper.find_game("halo")
		
		puts
		games_list.each do |game|
			puts game[:search_title]
		end
		puts

		expect(games_list.first[:search_title]).to eq("halo combat evolved")
		expect(games_list.second[:search_title]).to eq("halo 2")
 	end

 	it "should have 8 command and conquer games" do
		# puts "number of games: " + Game.all.size.to_s
		games_list = GameSearchHelper.find_game("command & conquer")
		
		puts
		games_list.each do |game|
			puts game[:search_title]
		end
		puts

		expect(games_list.size).to eq(8)
 	end

 	it "should return the most relevant one first: " do
		# puts "number of games: " + Game.all.size.to_s
		games_list = GameSearchHelper.find_game("command conquer tiberian sun")
		expect(games_list.first[:search_title]).to eq("command conquer tiberian sun")
 	end

 	describe "Tests for function getGameLisPartialMatch" do

 		it "should have more relevant games on the top of the list" do
	 		words_list = ["command", "conquer", "red", "alert"]
	 		games_list = GameSearchHelper.getGameLisPartialMatch(words_list)
	 		
			puts
	 		games_list.each do |game|
				puts game[:search_title]
			end
			puts

			games_list.first[:search_title].should include("command conquer red alert")
			games_list.second[:search_title].should include("command conquer red alert")
 		end

 	end

 	describe "Tests for function handleColon" do

 		it "should return the substring before the first colon" do
	 		title = "civilization V: breve new world"
	 		result = GameSearchHelper.handleColon(title)
	 		expect(result).to eq("civilization V")
 		end

 		it "should return nil" do
	 		title = "halo 2"
	 		result = GameSearchHelper.handleColon(title)
	 		expect(result).to eq(nil)
 		end

 	end

 	describe "Tests for function delChar" do

 		it "should be empty" do
	 		words_list = ["a", "b", "c", "d", "e"]
	 		GameSearchHelper.delChar(words_list)
	 		expect(words_list.size).to eq(0)
 		end

 		it "should have only one element ef left" do
 			words_list = ["a", "b", "c", "d", "ef"]
	 		GameSearchHelper.delChar(words_list)
	 		expect(words_list.size).to eq(1)
 		end

 		it "should have two elements left" do
 			words_list = ["aa", "b", "c", "d", "ef"]
	 		GameSearchHelper.delChar(words_list)
	 		expect(words_list.size).to eq(2)
	 	end

 	end
end
