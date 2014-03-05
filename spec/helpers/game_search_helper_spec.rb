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
	 		GameSearchHelper.delChar(words_li:qst)
	 		expect(words_list.size).to eq(2)
	 	end

 	end

 	describe "filtering and sorting" do
 		let(:user) {FactoryGirl.create(:user)} 
 		describe "find and filter games" do
 			it "should filter out already owned games" do
 				games_list = GameSearchHelper.find_game("halo")
 				user.games << games_list[0]
 				puts user.games
 				filtered_list = GameSearchHelper.find_and_filter_games("halo", user)
 				expect(filtered_list.include?(games_list[0])).to be_false 
 			end
 			it "should filter games by metacritic" do
 				lowscore = Game.create(title: "test", search_title: "test", metacritic_rating: "40")
 				highscore = Game.create(title: "test2", search_title: "test2", metacritic_rating: "100")
 				all_games = Game.all
 				filtered_games = GameSearchHelper.filter_games_by_metacritic(all_games,60,90)
 				expect(all_games.include?(lowscore) && all_games.include?(highscore)).to be_true
 				expect(filtered_games.include?(lowscore)).to be_false
 				expect(filtered_games.include?(highscore)).to be_false
 			end
 		end
 		describe "sort by metacritic" do
 			before do 
 				@low = Game.new(title: "test", search_title: "test", metacritic_rating: "40")
 				@med = Game.new(title: "test2", search_title: "test2", metacritic_rating: "70")
 				@high = Game.new(title: "test3", search_title: "test3", metacritic_rating: "100")
 			end
 			it "should return a list in ascending" do
 				expect(GameSearchHelper.sort_games_by_metacritic_asc([@med,@high,@low])).to eq([@low,@med,@high])
 			end
 			it "should return a list in descending order" do
 				expect(GameSearchHelper.sort_games_by_metacritic_desc([@med,@high,@low])).to eq([@high,@med,@low])
 			end
 		end
 	end
end
