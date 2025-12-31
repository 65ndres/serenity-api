class AddVerseToMessages < ActiveRecord::Migration[7.2]
  def change
    add_reference :messages, :verse, foreign_key: true
  end
end
