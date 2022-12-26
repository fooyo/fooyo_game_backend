ActiveAdmin.register LotteryRecord do
  menu priority: 2
  config.batch_actions = false
  config.sort_order = 'id_asc'
  includes :tiger_card, :rabbit_card
   # config.paginate = true
  # config.per_page = 20
  actions :all, except: %i[new destroy edit show]
  index download_links: false do
    column :sn
    column :user_real_name
    column :user_mobile
    column :user_email
    column :created_at
    column :tiger_card_id do |resource|
      resource.tiger_card.code
    end
    column :rabbit_card_id do |resource|
      resource.rabbit_card.code
    end
    actions do |resource|
    end
  end

  filter :sn
  filter :user_real_name
  filter :user_mobile
  filter :user_email
end
