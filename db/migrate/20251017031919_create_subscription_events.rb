class CreateSubscriptionEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :subscription_events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subscription, null: false, foreign_key: true
      t.integer :event_type, null: false
      t.string :processor_event_id, null: false
      t.text :data # Store raw event data
      t.timestamps
    end
    add_index :subscription_events, :processor_event_id, unique: true
  end
end