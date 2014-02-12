require 'spec_helper'

describe GameSale do
  let(:game) {FactoryGirl.create(:game)}
  before {@game_sale = game.game_sales.build(url: "steampowered.com/pingas",occurrence: DateTime.now(), store: "steam",origamt: 9.95, saleamt: 2.95)}
  subject {@game_sale}

  it { should respond_to(:saleamt)}
  it { should respond_to(:store)}
  it { should be_valid }
end
