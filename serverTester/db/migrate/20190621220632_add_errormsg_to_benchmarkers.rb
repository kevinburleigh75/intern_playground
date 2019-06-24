class AddErrormsgToBenchmarkers < ActiveRecord::Migration[6.0]
  def change
    add_column :benchmarkers, :error_msg, :string
  end
end
