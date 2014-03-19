require 'spec_helper'

describe "Games" do

  subject { page }
  
  describe "Game page" do

  	let(:game) { FactoryGirl.create(:game) }
  	let(:user) { FactoryGirl.create(:user) }

  	describe "button doesn't show up when not logged in" do
  		
  		before { visit ("/game/#{game.id}") }
  		it { should_not have_button('Add Game to Profile') }
  	end

  	describe "button shows up only when logged in" do
  		before do
  			visit signin_path
        	fill_in "Username",    with: user.username
        	fill_in "Password", with: user.password
        	click_button "Sign in"
        	visit ("/game/#{game.id}")
  		end
  		it { should_not have_link('Sign in', href: signin_path) }
  		it { should have_button('Add Game to Profile') }
  	end
    describe "sales related" do
      before {game.game_sales.destroy_all}
      describe "when there are no sales" do
        before { visit ("/game/#{game.id}")}
        it { should have_content("No sales data for this game.")}
      end
      describe "when there are sales" do
        before do
          @game = Game.create(title: "test", search_title: "test")
          @game_sale1 = @game.game_sales.create(url: "steampowered.com/pingas",occurrence: DateTime.now(), store: "Steam",origamt: 9.95, saleamt: 2.95)
        end
        after do
          @game.destroy
        end
        describe "only 1 sale" do
          before { visit ("/game/#{@game.id}")}
          it {should_not have_content("No sales data")}
          it {should have_content("#{@game.title} - $2.95")}
          it {should have_content("$2.95",count: 2)}
        end
        describe "2 sales" do 
          before do
            @game_sale2 = @game.game_sales.create(url: "amazon.com/pingas",occurrence: DateTime.now(), store: "Amazon",origamt: 9.95, saleamt: 1.95)
            puts @game_sale2.to_s
            visit ("/game/#{@game.id}")
          end
          it {should have_content("$1.95",count: 2)}
          it {should have_content("$2.95")}
          it {should have_content("#{@game.title} - $1.95")}
        end
      end
    end
  end
end
