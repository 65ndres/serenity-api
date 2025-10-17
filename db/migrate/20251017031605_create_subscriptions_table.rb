class CreateSubscriptionsTable < ActiveRecord::Migration[7.2]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :plan, null: false, foreign_key: true
      t.integer :processor, null: false # 0 = apple, 1 = google, 2 = stripe
      t.string :processor_id, null: false # Apple transaction ID, Google purchase token, Stripe subscription ID
      t.integer :status, default: 0, null: false # 0 = active, etc.
      t.datetime :current_period_start
      t.datetime :current_period_end
      t.decimal :amount, precision: 10, scale: 2
      t.string :currency, default: 'usd'
      t.timestamps
    end
    add_index :subscriptions, :processor_id, unique: true
  end
end
