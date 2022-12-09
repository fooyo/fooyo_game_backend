json.partial! '/common/response_header', info: { code: 200, message: '请求成功' }
json.page do
  json.partial! '/common/page', objects: @lottery_records
end
json.data @lottery_records do |obj|
  json.merge! obj.attributes.except('created_at', 'updated_at')
  json.created_day obj.created_at.strftime('%Y年%m月%d日')
end