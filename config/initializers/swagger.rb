GrapeSwaggerRails.options.app_name = '虎牌啤酒'
GrapeSwaggerRails.options.url = '/swagger/miniapp'
GrapeSwaggerRails.options.doc_expansion = 'list'
GrapeSwaggerRails.options.before_action do
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
end
