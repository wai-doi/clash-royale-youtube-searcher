class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches do |t|
      t.references :stats_royale_video, null: false, foreign_key: true
      t.references :deck, null: false, foreign_key: true

      t.timestamps
    end
  end
end
