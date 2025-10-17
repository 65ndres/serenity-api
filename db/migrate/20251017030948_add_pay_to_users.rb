class AddPayToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :stripe_customer_id, :string
    add_column :users, :processor, :string # e.g., 'apple', 'google', 'stripe'
  end
end
