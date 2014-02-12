require 'spec_helper'

describe GameSale do
  let(:game) {FactoryGirl.create(:game)}
  before {@game_sale = game.game_sales.build(store: "steam", saleamt: 2.95)}
  subject {@game_sale}

  it { should respond_to(:saleamt)}
  it { should respond_to(:store)}
end
