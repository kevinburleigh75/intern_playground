class CreateRequestRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :request_records do |t|
      t.string  :uuid
      t.string  :endpoint, null: false
      t.float   :elapsed, null: false

      t.timestamps
    end

  end
end
