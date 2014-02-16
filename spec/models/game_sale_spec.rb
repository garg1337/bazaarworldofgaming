require 'spec_helper'

describe GameSale do
  let(:game) {FactoryGirl.create(:game)}
  before {@game_sale = game.game_sales.build(url: "steampowered.com/pingas",occurrence: DateTime.now(), store: "steam",origamt: 9.95, saleamt: 2.95)}
  subject {@game_sale}

  it { should respond_to(:saleamt)}
  it { should respond_to(:store)}
  it { should be_valid }


  it "should not be associated with more than one game" do
    game2 = FactoryGirl.create(:game)
    @game_sale.game = game2
    expect(game2.game_sales.include?(@game_sale)).to be_false
  end

  describe "missing url" do 
    before {@game_sale.url = " "}
    it { should_not be_valid }
  end

  describe "missing occurrence" do 
    before {@game_sale.occurrence = nil}
    it { should_not be_valid }
  end

  describe "missing store" do 
    before {@game_sale.store = " "}
    it { should_not be_valid }
  end

  describe "missing orig cost" do 
    before {@game_sale.origamt = nil}
    it { should_not be_valid }
  end

  describe "missing sale cost" do 
    before {@game_sale.saleamt = nil}
    it { should_not be_valid }
  end

end
