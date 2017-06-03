class CreateMatchScores < ActiveRecord::Migration[5.0]
  def change
    create_table :match_scores, id: :uuid do |t|
    	t.uuid :competition_id
    	t.uuid :player_1_id
    	t.uuid :player_2_id
    	t.integer :player_1_score, default: 0
    	t.integer :player_2_score, default: 0
    	t.integer :draws, default: 0
    	t.timestamps
    end
  end
end
