Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount GrapeSwaggerRails::Engine => '/swagger'
  if Rails.env != 'development'
    GrapeSwaggerRails::Engine.middleware.use Rack::Auth::Basic do |username, password|
      username == '123' && password == '123'
    end
  end
  mount Miniapp::MiniappRoot => '/'
end
