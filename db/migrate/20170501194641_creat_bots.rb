class CreatBots < ActiveRecord::Migration[5.0]
  def change
    create_table :bots, id: :uuid do |t|
    	t.string "name"
    	t.text "code"
    	t.timestamps
    end
  end
end
