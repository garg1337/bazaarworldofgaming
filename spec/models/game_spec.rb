require 'spec_helper'

describe Game do
  before {@game = Game.new(title: "pingas,")}
  subject {@game}
  it {should respond_to(:title)}
  it {should respond_to(:search_title)}

  describe "when title is not present" do
    before { @game.title = " "}
    it { should_not be_valid}
  end

  describe "when search_title is not present" do
    before {@game.search_title = " "}
    it { should_not be_valid}
  end

  describe "there should be games in the test library" do
    count = Game.count
    if count == 0
      puts "test db is empty run 'rake db:seed RAILS_ENV=test' with game parser in seeds.rb"
    end
    subject {count}
    it {should_not eq(0)}
  end

end
