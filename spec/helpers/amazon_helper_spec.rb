require 'spec_helper'

describe AmazonHelper do

	it "should be true" do
		AmazonHelper.parse_products_off_result_page("http://www.amazon.com/s/ref=a9_asi_1?rh=i%3Aaps%2Ck%3Atitanfall&keywords=titanfall&ie=UTF8&qid=1395250913")
	end

end

