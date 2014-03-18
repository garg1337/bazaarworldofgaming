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
  end
end
