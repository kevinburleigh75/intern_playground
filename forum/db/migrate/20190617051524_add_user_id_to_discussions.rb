class AddUserIdToDiscussions < ActiveRecord::Migration[6.0]
  def change
    add_column :discussions, :user_id, :integer
  end
end
