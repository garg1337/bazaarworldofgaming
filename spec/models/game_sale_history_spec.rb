require 'spec_helper'

describe GameSaleHistory do
  let(:game) {FactoryGirl.create(:game)}
  before {@game_sale_history = game.game_sale_histories.new(occurred: DateTime.new(2011,2,3,4,5,6), store: "steam", price: 1.95)}
  subject {@game_sale_history}
  it {should respond_to :store}
  it {should respond_to :price}
  it {should be_valid}

  it "should not be associated with more than one game" do
    game2 = FactoryGirl.create(:game)
    @game_sale_history.game = game2
    expect(game2.game_sales.include?(@game_sale_history)).to be_false
  end

  describe "missing date of occurrence" do
    before {@game_sale_history.occurred=nil}
    it {should_not be_valid}
  end

  describe "missing store name" do
    before {@game_sale_history.store = " "}
    it {should_not be_valid}
  end

  describe "missing sale price" do
    before {@game_sale_history.price = nil}
    it {should_not be_valid}
  end
end
