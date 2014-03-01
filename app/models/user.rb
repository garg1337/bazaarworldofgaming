class User < ActiveRecord::Base  
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 50 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
	validates :username,	presence: true, length: { maximum: 50 }, uniqueness: true
	has_many :games, dependent: :destroy
end
