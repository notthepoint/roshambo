class Competition < ActiveRecord::Base
	has_many :match_scores
end