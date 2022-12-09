module Miniapp::V1
  class Base < Grape::API
    prefix 'api/miniapp/v1'
    Token = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2Njk5NjYzNDB9.GGWHnyvXsYWZY3khof1LC8Ygh7M_qP01UB42Pq0STyU'

    before do
      authenticate! unless route.settings[:skip_auth]
    end

    mount Users
    mount Cards
  end
end
