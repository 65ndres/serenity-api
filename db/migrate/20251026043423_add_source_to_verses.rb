class AddSourceToVerses < ActiveRecord::Migration[7.2]
  def change
    add_column :verses, :source, :integer
  end
end
