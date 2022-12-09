class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :nick_name
      t.string :avatar
      t.string :open_id
      t.string :unionid
      t.string :session_key
      t.string :real_name
      t.string :mobile
      t.string :email
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
