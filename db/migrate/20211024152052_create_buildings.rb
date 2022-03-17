class CreateBuildings < ActiveRecord::Migration[6.1]
  def change
    create_table :buildings do |t|
      t.references :deck, null: false, foreign_key: true
      t.references :card, null: false, foreign_key: true

      t.timestamps
    end

    add_index :buildings, %i[deck_id card_id], unique: true
  end
end
