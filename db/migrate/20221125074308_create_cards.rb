class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.references :user
      t.integer :card_type
      t.string :card_type_text
      t.string :code, index: { unique: true }
      t.boolean :is_used, default: false

      t.timestamps
    end
  end
end
