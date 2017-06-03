class User < ActiveRecord::Base
	has_many :bots

	validates :email, :name, presence: true
end