class CreateLotteryRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :lottery_records do |t|
      t.references :user, null: false
      t.string :user_real_name
      t.string :user_mobile
      t.string :user_email
      t.integer :tiger_card_id
      t.integer :rabbit_card_id
      t.string :sn, index: true

      t.timestamps
    end
  end
end
