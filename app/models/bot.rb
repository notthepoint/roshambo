class Bot < ActiveRecord::Base
	belongs_to :user

	validates :code, :name, presence: true
end
