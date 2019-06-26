class CreateBenchmarkers < ActiveRecord::Migration[6.0]
  def change
    create_table :benchmarkers do |t|
      t.string :uuid
      t.timestamp :request_time
      t.string :endpoint
      t.boolean :success
      t.integer :status
      t.float :elapsed
    end
  end
end
