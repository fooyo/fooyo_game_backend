# == Schema Information
#
# Table name: cards
#
#  id             :bigint           not null, primary key
#  user_id        :bigint
#  card_type      :integer
#  card_type_text :string
#  code           :string
#  is_used        :boolean          default("false")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_cards_on_code     (code) UNIQUE
#  index_cards_on_user_id  (user_id)
#
class Card < ApplicationRecord
  belongs_to :user, optional: true

  enum card_type: { tiger: 1, rabbit: 2, ths: 3 }
  CARD_TYPE_TEXT = { tiger: '虎', rabbit: '兔', ths: '谢谢参与' }.stringify_keys

  before_save do
    self.card_type_text = CARD_TYPE_TEXT[card_type] if card_type_changed?
  end

  before_create do
    code = 'TB' + [('a'..'z').to_a, (0..9).to_a].flatten.sample(6).join
    code = ('TB' + [('a'..'z').to_a, (0..9).to_a].flatten.sample(6).join) while Card.find_by(code: code)
    self.code = code
  end
end
