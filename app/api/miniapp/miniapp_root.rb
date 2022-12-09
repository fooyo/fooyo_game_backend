module Miniapp
  class MiniappRoot < Base::Config
    mount Miniapp::V1::Base
    add_swagger_documentation mount_path: 'swagger/miniapp',
                              doc_version: '1.0.0',
                              hide_documentation_path: true, # 是否隐藏记录的路径，默认：true
                              array_use_braces: true, # 设置必须为true，为了params定义为array类型的可以按照顺序正确提交每个参数
                              info: {
                                title: '小程序端',
                                description: '小程序端接口列表'
                              },
                              tags: [
                                { name: 'users', description: '用户' }
                              ]
  end
end
