class Bot < ActiveRecord::Base
	belongs_to :user
	has_many :match_scores

	validates :code, :name, presence: true
end
