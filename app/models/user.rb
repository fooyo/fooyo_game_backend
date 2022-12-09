# == Schema Information
#
# Table name: users
#
#  id          :bigint           not null, primary key
#  nick_name   :string
#  avatar      :string
#  open_id     :string
#  unionid     :string
#  session_key :string
#  real_name   :string
#  mobile      :string
#  email       :string
#  deleted_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class User < ApplicationRecord
  has_many :cards
  has_many :lottery_records, dependent: :destroy

  after_update do
    if saved_change_to_real_name? || saved_change_to_real_mobile? || saved_change_to_email
      lottery_records.update_all(user_real_name: real_name, user_mobile: mobile, user_email: email)
    end
  end
end
