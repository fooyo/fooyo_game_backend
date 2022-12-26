# == Schema Information
#
# Table name: lottery_records
#
#  id             :bigint           not null, primary key
#  user_id        :bigint           not null
#  user_real_name :string
#  user_mobile    :string
#  user_email     :string
#  tiger_card_id  :integer
#  rabbit_card_id :integer
#  sn             :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_lottery_records_on_sn       (sn)
#  index_lottery_records_on_user_id  (user_id)
#
class LotteryRecord < ApplicationRecord
  belongs_to :user
  belongs_to :tiger_card, class_name: :Card, optional: true
  belongs_to :rabbit_card, class_name: :Card, optional: true

  before_save do
    if user_id_changed?
      user = User.find_by(id: user_id)
      self.user_real_name = user.real_name
      self.user_mobile = user.mobile
      self.user_email = user.email
    end
  end

  before_create do
    sn = created_at.strftime('%Y%m%d') + [('A'..'Z').to_a, (0..9).to_a].flatten.sample(5).join
    sn = (created_at.strftime('%Y%m%d') + [('A'..'Z').to_a, (0..9).to_a].flatten.sample(5).join) while LotteryRecord.find_by(sn: sn)
    self.sn = sn
  end
end
