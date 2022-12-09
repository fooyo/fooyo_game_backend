module Base::Helpers::HttpCodesHelper
  status_codes = [
    # 成功状态码
    { success: 200, msg: '成功' },

    # 参数错误：101-199
    { parameters_invalid: 101, msg: '参数无效' },
    { param_is_blank: 102, msg: '参数为空' },
    { param_type_bind_error: 103, msg: '参数类型错误' },
    { param_not_complete: 104, msg: '参数缺失' },

    # 用户错误：201-299
    { user_not_logged_in: 201, msg: '用户未登录' },
    { user_login_error: 202, msg: '账号不存在或密码错误' },
    { user_account_forbidden: 203, msg: '账号已被禁用' },
    { user_not_exist: 204, msg: '用户不存在' },
    { user_has_existed: 205, msg: '用户已存在' },
    { token_decode_error: 206, msg: 'token格式异常' },
    { token_not_found: 207, msg: 'token丢失' },

    # 业务错误：301-399
    { specified_questioned_user_not_exist: 301, msg: '某业务出现问题' },

    # 数据错误：401-499
    { resource_invalid: 402, msg: '数据有误' },
    { data_already_existed: 403, msg: '数据已存在' },
    { resource_not_found: 405, msg: '数据未找到' },

    # 系统错误：501-599
    { system_inner_error: 501, msg: '系统内部错误' },
    { name_error: 502, msg: '方法名错误' },
    { argument_error: 503, msg: '函数传参错误' },

    # 接口错误：601-699
    { interface_inner_invoke_error: 601, msg: '内部系统接口调用异常' },
    { interface_outter_invoke_error: 602, msg: '外部系统接口调用异常' },
    { interface_forbid_visit: 603, msg: '该接口禁止访问' },
    { interface_address_invalid: 604, msg: '接口地址无效' },
    { interface_request_timeout: 605, msg: '接口请求超时' },
    { interface_exceed_load: 606, msg: '接口负载过高' },

    # 权限错误：701-799
    { permission_no_access: 701, msg: '无访问权限' }
  ]

  status_codes.each do |h|
    define_method "_#{h.first[0]}".to_sym do
      { status: h.first[1], message: h.values.last }
    end
  end

  define_method(:err) do |code, message = nil|
    status_codes.each do |h|
      if h.first[1] === code
        error!({status: code, message: message || h.values.last }, 200)
      end
    end
  end
end
