class User < ActiveRecord::Base
	attr_accessible :name, :email, :username
	validates :name,		presence: true
	validates :email,		presence: true
	validates :username,	presence: true
	has_many :games, dependent: :destroy
end
