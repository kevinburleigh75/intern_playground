class AddChannelIdToDiscussions < ActiveRecord::Migration[6.0]
  def change
    add_column :discussions, :channel_id, :integer
  end
end
