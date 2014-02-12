require 'spec_helper'

describe GameSaleHistory do
  before {@game_sale_history = GameSaleHistory.new()}
  subject {@game_sale_history}
  it {should respond_to :store}
  it {should respond_to :price}
end
