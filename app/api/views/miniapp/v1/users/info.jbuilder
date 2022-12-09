json.partial! '/common/response_header', info: { code: 200, message: '请求成功' }
json.data do
  json.merge! @user.attributes.except('created_at', 'updated_at', 'deleted_at')
end