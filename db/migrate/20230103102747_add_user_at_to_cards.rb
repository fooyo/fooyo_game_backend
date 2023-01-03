class AddUserAtToCards < ActiveRecord::Migration[6.1]
  def change
    add_column :cards, :user_at, :datetime
    Card.where.not(user_id: nil).each do |card|
      record = card.tiger_lottery_record
      record = card.rabbit_lottery_record unless record
      card.update(user_at: card.updated_at)
    end
  end
end
