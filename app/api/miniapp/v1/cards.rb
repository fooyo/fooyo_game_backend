module Miniapp::V1
  class Cards < Grape::API
    namespace :cards do

      desc "{ code: 200, message: '请求成功', data: { card_type: tiger或者rabbit或者ths } }<br>
            { code: 300, message: '二维码不存在' }<br>
            { code: 300, message: '二维码已使用' }<br>
            { code: 422, message: '其他错误' }<br>
            ",
      headers: { 'Token' => { required: true, description: 'Token认证', default: Base::Token } }
      params do
        requires :code, type: String
      end
      post '/scan_qrcode', desc: '扫描卡片二维码' do
        card = Card.find_by(code: params[:code])
        return { code: 300, message: '二维码不存在' } unless card
        return { code: 300, message: '二维码已使用' } if card.user_id

        if card.update(user_id: card.ths? ? nil : current_user.id, user_at: card.ths? ? nil : Time.current)
          { code: 200, message: '请求成功', data: { card_type: card.card_type } }
        else
          { code: 422, message: card.errors.full_messages.join('; ') }
        end
      end

      # desc '新建卡片', headers: { 'Token' => { required: true, description: 'Token认证', default: Base::Token } }
      # params do
      #   requires :card, type: Hash do
      #     requires :title, type: String
      #     optional :content, type: String, desc: '内容'
      #     optional :images, type: Array[String]
      #     optional :ying_di_ids, type: Array[Integer]
      #     optional :address, type: String, desc: '地址'
      #   end
      # end
      # post '/', desc: '新建卡片' do
      #   card = Card.new(declared(params, include_missing: false)[:card].merge(you_ke_id: current_you_ke.id))
      #   if card.save
      #     { code: 200, message: '请求成功' }
      #   else
      #     { code: 422, message: card.errors.full_messages.join('; ') }
      #   end
      # end

      # desc '卡片列表', headers: { 'Token' => { required: true, description: 'Token认证', default: Base::Token } }
      # params do
      #   optional :you_ke_id, type: Integer, desc: ''
      #   optional :lat, type: Float, desc: '纬度'
      #   optional :lng, type: Float, desc: '经度'
      #   optional :title, type: String, desc: ''
      #   optional :page_no, type: Integer, default: 1
      #   optional :page_size, type: Integer, default: 20
      # end
      # get '/', desc: '卡片列表', jbuilder: 'miniapp_you_ke/v1/cards/index.jbuilder' do
      #   @lat = params[:lat]
      #   @lng = params[:lng]
      #   @cards = Card.all
      #   @cards = @cards.where(you_ke_id: params[:you_ke_id]) if params[:you_ke_id].present?
      #   @cards = @cards.where('title like ?', "%#{params[:title]}%") if params[:title].present?
      #   @cards = @cards.order(id: :desc).page(params[:page_no]).per(params[:page_size])
      # end

      # desc '卡片详情', headers: { 'Token' => { required: true, description: 'Token认证', default: Base::Token } }
      # params do
      #   optional :lat, type: Float, desc: '纬度'
      #   optional :lng, type: Float, desc: '经度'
      # end
      # get '/:id', desc: '卡片详情', jbuilder: 'miniapp_you_ke/v1/cards/show.jbuilder' do
      #   @lat = params[:lat]
      #   @lng = params[:lng]
      #   @card = Card.find_by(id: params[:id])
      #   if @card
      #     @like = @card.likes.find_by(you_ke_id: current_you_ke.id)
      #     @shou_cang = @card.you_ke_card_relations.find_by(you_ke_id: current_you_ke.id)
      #     @follow = current_you_ke.follows.find_by(followed_you_ke_id: @card.you_ke_id)
      #   end
      # end

      # desc '修改卡片', headers: { 'Token' => { required: true, description: 'Token认证', default: Base::Token } }
      # params do
      #   optional :card, type: Hash do
      #     optional :title, type: String
      #     optional :content, type: String, desc: '内容'
      #     optional :images, type: Array[String]
      #     optional :ying_di_ids, type: Array[Integer]
      #     optional :address, type: String, desc: '地址'
      #   end
      # end
      # put '/:id', desc: '修改卡片' do
      #   card = current_you_ke.cards.find_by(id: params[:id])
      #   return { code: 422, message: '卡片不存在' } unless card

      #   if card.update(declared(params, include_missing: false)[:card].to_h)
      #     { code: 200, message: '请求成功' }
      #   else
      #     { code: 422, message: card.errors.full_messages.join(';') }
      #   end
      # end

      # desc '删除卡片', headers: { 'Token' => { required: true, description: 'Token认证', default: Base::Token } }
      # params do
      # end
      # delete '/:id', desc: '删除卡片' do
      #   card = current_you_ke.cards.find_by(id: params[:id])
      #   return { code: 422, message: '卡片不存在' } unless card

      #   if card.destroy
      #     { code: 200, message: '请求成功' }
      #   else
      #     { code: 422, message: card.errors.full_messages.join(';') }
      #   end
      # end

    end
  end
end
