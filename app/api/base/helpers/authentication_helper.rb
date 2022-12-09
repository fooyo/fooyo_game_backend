module Base::Helpers::AuthenticationHelper
  # token = Jwt.encode({ user_id: 1 }, 10.seconds.from_now)
  def authenticate!
    decoded_token = Jwt.decode(request.headers['Token'])
    if decoded_token
      @current_user = User.find_by(id: decoded_token.fetch('user_id'))
     error!({ code: 401, message: '用户认证失败' }, 401) if @current_user.nil?
    else
     error!({ code: 401, message: '用户认证失败' }, 401)
    end
  end

  def current_user
    @current_user
  end
end
