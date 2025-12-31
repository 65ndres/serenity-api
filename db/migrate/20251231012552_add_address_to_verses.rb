class AddAddressToVerses < ActiveRecord::Migration[7.2]
  def change
    add_column :verses, :address, :string
    add_index :verses, :address
  end
end
