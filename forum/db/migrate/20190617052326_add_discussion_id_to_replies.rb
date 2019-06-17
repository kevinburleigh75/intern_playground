class AddDiscussionIdToReplies < ActiveRecord::Migration[6.0]
  def change
    add_column :replies, :discussion_id, :integer
  end
end
