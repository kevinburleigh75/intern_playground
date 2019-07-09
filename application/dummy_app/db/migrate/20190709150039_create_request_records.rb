class CreateRequestRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :request_records do |t|
      t.uuid       :uuid,       null: false
      t.string     :endpoint,   null: false
      t.datetime   :start_time, null: false
      t.float      :elapsed,    null: false
      t.integer    :status,     null: false

      t.timestamps
    end
  end
end
