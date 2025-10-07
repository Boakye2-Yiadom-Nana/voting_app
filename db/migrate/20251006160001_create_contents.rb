class CreateContents < ActiveRecord::Migration[8.0]
  def change
    create_table :contents do |t|
      t.string :content
      t.integer :votes_count, default:0
      t.references :poll, null: false, foreign_key: true

      t.timestamps
    end
  end
end
