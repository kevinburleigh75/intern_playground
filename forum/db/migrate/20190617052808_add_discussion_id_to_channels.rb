class AddDiscussionIdToChannels < ActiveRecord::Migration[6.0]
  def change
    add_column :channels, :discussion_id, :integer
  end
end
