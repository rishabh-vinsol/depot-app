class AddLastActivityToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_activity_time, :datetime, default: Time.current
  end
end
