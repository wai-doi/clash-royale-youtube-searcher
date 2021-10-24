class CreateDecks < ActiveRecord::Migration[6.1]
  def change
    create_table :decks do |t|
      t.string :sorted_card_names, null: false

      t.timestamps
    end

    add_index :decks, :sorted_card_names, unique: true
  end
end
