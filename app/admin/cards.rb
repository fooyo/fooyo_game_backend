ActiveAdmin.register Card do
  includes :user
  menu priority: 1
  config.batch_actions = false
  config.sort_order = 'customer_order_asc'
  # config.paginate = true
  # config.per_page = 20
  # actions :all, except: %i[new destroy]
  order_by(:customer_order) do |order_clause|
    ['user_id is null', 'is_used desc', 'id asc'].join(", ")
  end
   # config.paginate = true
  # config.per_page = 20
  actions :all, except: %i[new destroy edit show]

  index download_links: [:csv] do
    column :code
    column :card_type_text
    column '是否被抽取' do |card|
      card.user_id.present?
    end
    column '被抽取时间' do |card|
      card.user_at&.strftime('%Y-%m-%d %H:%M:%S')
    end
    column '抽取用户' do |card|
      simple_format "用户id: #{card.user_id}, 昵称: #{card.user&.nick_name},  头像: #{image_tag card.user&.avatar, size: '20x20' if card.user&.avatar },  open_id: #{card.user&.open_id}" if card.user
    end
    column :is_used
    column :user do |resource|
      simple_format "姓名: #{resource.user&.real_name},  电话: #{resource.user&.mobile},  email: #{resource.user&.email}" if resource.user
    end
    actions do |resource|
    end
  end

  csv do
    column :code
    column :card_type_text
    column '是否被抽取' do |card|
      card.user_id.present? ? '是' : '否'
    end
    column '被抽取时间' do |card|
      card.user_at&.strftime('%Y-%m-%d %H:%M:%S')
    end
    column '抽取用户id' do |card|
      card.user_id
    end
    column '抽取用户昵称' do |card|
      card.user&.nick_name
    end
    column :is_used do |card|
      card.is_used? ? '是' : '否'
    end
    column '提交抽奖用户姓名' do |resource|
      resource.user&.real_name
    end
    column '提交抽奖用户电话' do |resource|
      resource.user&.mobile
    end
    column '提交抽奖用户email' do |resource|
      resource.user&.email
    end
  end

  filter :card_type_text, as: :select
  filter :user_id_not_null, :as => :boolean, collection: -> { [['是', 1], ['否', 0]] }, label: '是否被抽取'
  filter :is_used, collection: -> { [['是', 1], ['否', 0]] }
  filter :code
end
