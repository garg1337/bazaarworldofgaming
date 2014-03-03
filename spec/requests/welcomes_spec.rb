require 'spec_helper'

describe "Welcomes" do
  describe "GET /welcomes" do
    it "should have the title 'Bazaarworldofgaming'" do
      visit root_path
      expect(page).to have_title('Bazaarworldofgaming')
    end

    it "should have the content 'Welcome'" do
    	visit root_path
    	expect(page).to have_content('Welcome')
	end
  end
end
