class CreateBenchmarkers < ActiveRecord::Migration[6.0]
  def change
    create_table :benchmarkers do |t|
      t.uuid :uuid
      t.timestamp :request_time
      t.boolean :success
      t.integer :status
      t.float :elapsed
      t.string :error_msg
    end
  end
end
