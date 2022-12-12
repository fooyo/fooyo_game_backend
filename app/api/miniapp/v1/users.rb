module Miniapp::V1
  class Users < Grape::API
    namespace :users do
      desc "{ code: 200, message: '请求成功', url: xxx }<br>
            { code: 300, message: '请求失败' }<br>
            ",
      headers: { 'Token' => { required: true, description: 'Token认证', default: Base::Token } }
      params do
        requires :file, :type => File, :desc => "图片"
      end
      post '/oss_upload', desc: '图片上传' do
        url = AliyunOss.new.upload_from_api(params[:file][:tempfile])
        if url.present?
          { code: 200, message: '请求成功', url: url }
        else
          { code: 300, message: '请求失败' }
        end
      end

      desc "{ code: 200, message: '请求成功' }<br>
            { code: 300, message: '其他错误' }<br>
            ",
      headers: { 'Token' => { required: true, description: 'Token认证', default: Base::Token } }
      post '/apply_lottery', desc: '提交抽奖申请' do
        cards = current_user.cards.order(:id)
        unused_tiger_cards = cards.select { |c| c.tiger? && !c.is_used? }
        unused_rabbit_cards = cards.select { |c| c.rabbit? && !c.is_used? }
        unused_tiger_card_count = unused_tiger_cards.size
        unused_rabbit_card_count = unused_rabbit_cards.size
        draw_lottery_count = [unused_tiger_card_count, unused_rabbit_card_count].min

        begin
          ActiveRecord::Base.transaction do
            unused_tiger_cards[0..(draw_lottery_count - 1)].each_with_index do |tiger_card, index|
              tiger_card.update!(is_used: true)
              rabbit_card = unused_rabbit_cards[index]
              rabbit_card.update!(is_used: true)
              current_user.lottery_records.create!(tiger_card_id: tiger_card.id, rabbit_card_id: rabbit_card.id )
            end
          end
          { code: 200, message: '请求成功' }
        rescue ActiveRecord::RecordInvalid => e
          { code: 300, message: e.message.split(':').last }
        rescue Exception => e
           { code: 300, message: e.message }
        end
      end

      desc "{ code: 200, message: '请求成功', data: { is_new: 是否新用户, token: token, user: #{ hash = {}; User.column_names.map { |c| hash[c] = 'xx' }; hash } }  } <br>
            { code: 300, message: '其他错误' }<br>
            ".gsub('=>', ': ')
      route_setting :skip_auth, true
      params do
        requires :code, type: String
      end
      post '/wx_login', desc: '微信一键登录' do
        open_id, session_key, unionid = Weixin.get_open_id(params[:code])
        is_new = false
        user = User.find_by(open_id: open_id)
        if user
          user.update!(session_key: session_key, unionid: unionid, open_id: open_id)
        else
          user = User.create!(open_id: open_id, session_key: session_key, unionid: unionid)
          is_new = true
        end
        token = Jwt.encode({user_id: user.id})
        { code: 200, message: '请求成功', data: { is_new: is_new, token: token, user: user.attributes } }
      rescue => e
        { code: 300, message: e.message }
      end

      # desc '微信获取手机号'
      # route_setting :skip_auth, true
      # params do
      #   requires :code, type: String
      # end
      # get '/user_phone', desc: '微信获取手机号' do
      #   flag, msg = Weixin.get_phone(params[:code])
      #   if flag
      #     phone = msg
      #     { code: 200, message: '请求成功', phone: phone }
      #   else
      #     { code: 400, message: msg }
      #   end
      # end

      desc "{ code: 200, message: '修改成功', data: { user: #{ hash = {}; User.column_names.map { |c| hash[c] = 'xx' }; hash } }  } <br>
      { code: 300, message: '其他错误' }<br>
      ".gsub('=>', ': '),
      headers: { 'Token' => { required: true, description: 'Token认证', default: Base::Token } }
      params do
        optional :user, type: Hash do
          optional :nick_name, type: String
          optional :avatar, type: String
          optional :real_name, type: String
          optional :mobile, type: String
          optional :email, type: String
        end
      end
      put '/info', desc: '修改用户信息' do
        if current_user.update(declared(params, include_missing: false)[:user])
          { code: 200, message: '修改成功', data: { user: current_user.attributes } }
        else
          { code: 300, message: current_user.errors.full_messages.join('; ')}
        end
      end

      desc "{ code: 200, message: '修改成功', data: { unused_tiger_card_count: xx, unused_rabbit_card_count: xx  }",
      headers: { 'Token' => { required: true, description: 'Token认证', default: Base::Token } }
      get '/my_cards', desc: '我的卡片' do
        cards = current_user.cards
        unused_tiger_card_count = cards.select { |c| c.tiger? && !c.is_used? }.size
        unused_rabbit_card_count = cards.select { |c| c.rabbit? && !c.is_used? }.size
        { code: 200, message: '请求成功', data: { unused_tiger_card_count: unused_tiger_card_count, unused_rabbit_card_count: unused_rabbit_card_count } }
      end

      desc "{ code: 200, message: '修改成功', data: { draw_lottery_count: xx, is_need_contact_info: true或者false  }",
      headers: { 'Token' => { required: true, description: 'Token认证', default: Base::Token } }
      get '/my_lotteries', desc: '抽奖资格' do
        cards = current_user.cards
        unused_tiger_card_count = cards.select { |c| c.tiger? && !c.is_used? }.size
        unused_rabbit_card_count = cards.select { |c| c.rabbit? && !c.is_used? }.size
        draw_lottery_count = [unused_tiger_card_count, unused_rabbit_card_count].min
        { code: 200, message: '请求成功', data: { draw_lottery_count: draw_lottery_count, is_need_contact_info: current_user.real_name.blank? } }
      end

      desc "{ code: 200, message: '修改成功', data: [#{ hash = {}; LotteryRecord.column_names.map { |c| hash[c] = 'xx' }; hash }] }  <br>
      ".gsub('=>', ': '),
      headers: { 'Token' => { required: true, description: 'Token认证', default: Base::Token } }
      params do
        optional :page, type: Integer, desc: '第几页'
        optional :per, type: Integer, desc: '每页多少个， 默认10'
      end
      get '/lottery_records', desc: '抽奖历史', jbuilder: 'miniapp/v1/users/lottery_records.jbuilder' do
        @lottery_records = current_user.lottery_records
        @lottery_records = @lottery_records.page(params[:page]).per(params[:per])
      end

      desc "{ code: 200, message: '请求成功', data: #{ hash = {}; User.column_names.map { |c| hash[c] = 'xx' unless c.in?(['created_at', 'updated_at', 'deleted_at']) }; hash } } <br>
            ".gsub('=>', ': '),
      headers: { 'Token' => { required: true, description: 'Token认证', default: Base::Token } }
      get '/info', desc: '用户详情', jbuilder: 'miniapp/v1/users/info.jbuilder' do
        @user = current_user
      end
    end
  end
end
