class AddSessionsTable < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data      
      t.integer :user_id
      t.string :session
      t.timestamps
    end

    add_index :sessions, :session_id, :unique => true
    add_index :sessions, :updated_at


  end

  def self.down
    drop_table :sessions
  end

end
