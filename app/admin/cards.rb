ActiveAdmin.register Card do
  includes :user
  menu priority: 1
  config.batch_actions = false
  config.sort_order = 'customer_order_asc'
  # config.paginate = true
  # config.per_page = 20
  # actions :all, except: %i[new destroy]
  order_by(:customer_order) do |order_clause|
    ['user_id is null', 'is_used desc'].join(", ")
  end
   # config.paginate = true
  # config.per_page = 20
  actions :all, except: %i[new destroy edit show]

  index download_links: false do
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

  filter :card_type_text, as: :select
  filter :is_used, collection: -> { [['是', 1], ['否', 0]] }
  filter :code
end
