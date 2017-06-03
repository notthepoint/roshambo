class AddUserIdToBots < ActiveRecord::Migration[5.0]
  def change
  	add_column :bots, :user_id, :uuid
  end
end
