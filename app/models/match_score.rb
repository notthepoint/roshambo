class MatchScore < ActiveRecord::Base
	belongs_to :competition
	belongs_to :player_1, class_name: "Bot", foreign_key: :player_1_id
	belongs_to :player_2, class_name: "Bot", foreign_key: :player_2_id

	def winner
		# [player_1_score, player_2_score].max
		if player_1_score > player_2_score
			player_1
		elsif player_2_score > player_1_score
			player_2
		else
		end
	end
end