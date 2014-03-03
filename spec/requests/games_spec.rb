require 'spec_helper'

describe "Games" do
  describe "Search page" do

    it "should have the title 'Bazaarworldofgaming'" do
      visit root_path
      expect(page).to have_title("Bazaarworldofgaming")
    end

  end
end
