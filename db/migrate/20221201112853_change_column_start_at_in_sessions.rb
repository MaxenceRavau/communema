class ChangeColumnStartAtInSessions < ActiveRecord::Migration[7.0]
  def change
    remove_column :sessions, :start_at, :time
    add_column :sessions, :start_at, :datetime
  end
end
