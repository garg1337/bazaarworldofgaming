class User < ActiveRecord::Base
	before_save { self.email = email.downcase }
	attr_accessible :name, :email, :username, :password, :password_confirmation
	validates :name, presence: true,
					  length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true,
					  format: { with: VALID_EMAIL_REGEX },
					  uniqueness: { case_sensitive: false }
	validates :username, presence: true,
						 length: { maximum: 50 }, uniqueness: true
	has_many :games, dependent: :destroy
	has_secure_password
	validates :password, length: { minimum: 6 }
end
