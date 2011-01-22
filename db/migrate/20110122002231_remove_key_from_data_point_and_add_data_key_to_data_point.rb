class RemoveKeyFromDataPointAndAddDataKeyToDataPoint < ActiveRecord::Migration
  def self.up
    add_column(:data_points, :data_key, :string)
    add_column(:data_points, :data_value, :integer)

    remove_column(:data_points, :key)
    remove_column(:data_points, :value)
  end

  def self.down
    remove_column(:data_points, :data_key)
    remove_column(:data_points, :data_value)

    add_column(:data_points, :key, :string)
    add_column(:data_points, :value, :integer)
  end
end
