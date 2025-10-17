class CreatePlans < ActiveRecord::Migration[7.2]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.string :stripe_price_id # For web
      t.string :apple_product_id # e.g., 'com.example.bible.premium_monthly'
      t.string :google_product_id # e.g., 'premium_monthly'
      t.decimal :amount, precision: 10, scale: 2
      t.string :currency, default: 'usd'
      t.string :interval, null: false # 'month', 'year'
      t.timestamps
    end
    add_index :plans, :stripe_price_id, unique: true
    add_index :plans, :apple_product_id, unique: true
    add_index :plans, :google_product_id, unique: true
  end
end
