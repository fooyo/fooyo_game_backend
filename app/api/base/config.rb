require 'grape-swagger'
module Base
  class Config < Grape::API
    include ::Base::Common::Logger

    content_type :json, 'application/json;charset=UTF-8'
    format :json
    formatter :json, Grape::Formatter::Jbuilder

    helpers do
      include ::Base::Helpers::AuthenticationHelper
      include ::Base::Helpers::HttpCodesHelper
      include ::Base::Helpers::OutputHelper
    end
  end
end
