require 'spec_helper'

describe SteamHelper do

	it "should update databases with sales info for 'FM2014'" do
		# Football Manager 2014 (not on sale march 19)
		url1 = "http://store.steampowered.com/app/231670/" 
		SteamHelper.extract_page_info(url1)

		game_title = "Football Manager 2014"
		result_lis = GameSearchHelper.find_game(game_title)
		result = result_lis[0]
		expect(result[:title]).to eq("Football Manager 2014")
		# expect(result[:release_date]).to eq("Wed, 30 Oct 2013")
		expect(result[:description]).to eq("\r\n\t\t\t\t\t\t\t\t- Play it whenever, wherever, however Play on Linux for the first time, plus the inclusion of ‘cloud-save’ technology which means that managers can now pursue a single career from any computer, anywhere in the world.\t\t\t\t\t\t\t")
		expect(result[:publisher]).to eq("SEGA")
		expect(result[:developer]).to eq("Sports Interactive")
		expect(result[:genres]).to eq([])
		expect(result[:search_title]).to eq("football manager 2014")
		expect(result[:metacritic_rating]).to eq("85")
	
		result_lis = GameSale.where("url LIKE ?", url1)
		expect(result_lis.size).to eq(1)

		result = result_lis[0]
		expect(result[:store]).to eq("Steam")
		expect(result[:origamt]).to eq(49.99)
		expect(result[:saleamt]).to eq(49.99)
	end

	it "should update databases with sales info for 'Prince of Persia'" do
		# Prince of Persia (on sale march 19)
		url2 = "http://store.steampowered.com/app/19980/"
		SteamHelper.extract_page_info(url2)

		game_title = "Prince of Persia"
		result_lis = GameSearchHelper.find_game(game_title)
		result = result_lis[0]
		expect(result[:title]).to eq("Prince of Persia (2008)")
		# expect(result[:release_date]).to eq("Wed, 30 Oct 2013")
		expect(result[:description]).to eq("Escape to experience the new fantasy world of ancient Persia. Masterful storytelling and sprawling environments deliver a brand new adventure that re-opens the Prince of Persia saga. Now you have the freedom to determine how the game evolves in this non-linear adventure. Players will decide how they unfold the storyline by choosing their path in the open-ended world.In this strange land, your rogue warrior must utilize all of his skills, along with a whole new combat system, to battle Ahriman’s corrupted lieutenants to heal the land from the dark Corruption and restore the light. Also, history;s greatest ally is revealed in the form of Elika, a dynamic AIcompanion who joins the Prince in his fight to save the world. Gifted with magical powers, she interacts with the player in combat, acrobatics and puzzle-solving, enabling the Prince to reach new heights of deadly high-flying artistry through special duo acrobatic moves or devastating fighting comboattacks.")
		expect(result[:publisher]).to eq("Ubisoft")
		expect(result[:developer]).to eq("Ubisoft Montreal")
		expect(result[:genres]).to eq(["Action", "Adventure"])
		expect(result[:search_title]).to eq("prince of persia 2008")
		# expect(result[:metacritic_rating]).to eq("82")
	
		result_lis = GameSale.where("url LIKE ?", url2)
		expect(result_lis.size).to eq(1)

		result = result_lis[0]
		expect(result[:store]).to eq("Steam")
		expect(result[:origamt]).to eq(9.99)
		expect(result[:saleamt]).to eq(2.49)
	end

end

