class AddUniqueIndexToAttendances < ActiveRecord::Migration[8.0]
  def change
    add_index :attendances, [ :user_id, :event_id ], unique: true, name: 'index_attendances_on_user_and_event'
  end
end
