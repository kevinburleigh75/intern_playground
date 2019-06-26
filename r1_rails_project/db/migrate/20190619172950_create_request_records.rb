class CreateRequestRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :request_records do |t|
      t.string  :uuid,              null: false
      t.string  :instance_id,       null: false
      t.string  :image_id,          null: false
      t.float   :elapsed,           null: false

      t.timestamps                  null: false
    end

  end
end
