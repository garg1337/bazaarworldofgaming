FactoryGirl.define do
  factory :game do
    title         "Pingas: the revenge of the pinga"
    search_title  "Pingas the revenge of the pinga"
    coop          "4+"
    description   "Arjun searches near and far for the pingas"
    developer     "Sonic and Friends"
    esrb_rating   "MA"
    genres        ["action"]
    metacritic_rating    "N/A"
  end

  factory :user do
    name "Bazaar"
    email "bazaar@world.gaming"
    username "bazaar"
    password "bazaar"
    password_confirmation "bazaar"   
  end
end
