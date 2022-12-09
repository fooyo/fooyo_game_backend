class Weixin
  MSG_CHECK_LABEL = { 100 => '正常', 10001 => '广告', 20001 => '时政', 20002 => '色情', 20003 => '辱骂', 20006 => '违法犯罪', 20008 => '欺诈', 20012 => '低俗', 20013 => '版权', 21000 => '其他' }
  class << self
    def get_access_token
      url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{Rails.application.credentials.dig(:weixin, :app_id)}&secret=#{Rails.application.credentials.dig(:weixin, :app_secret)}"
      result = JSON.parse Net::HTTP.get(URI(url))
      result['access_token']
    end

    def get_open_id(code)
      url = "https://api.weixin.qq.com/sns/jscode2session?js_code=#{code}&grant_type=authorization_code&appid=#{Rails.application.credentials.dig(:weixin, :app_id)}&secret=#{Rails.application.credentials.dig(:weixin, :app_secret)}"
      result = JSON.parse Net::HTTP.get(URI(url))
      if result['errcode']
        raise result['errmsg']
      else
        [result['openid'], result['session_key'], result['unionid']]
      end
    end

    def get_user_info(session_key, encrypted_data, iv)
      session_key = Base64.decode64(session_key)
      iv = Base64.decode64(iv)
      encrypted_data = Base64.decode64(encrypted_data)
      cipher = OpenSSL::Cipher.new('aes-128-cbc')
      cipher.decrypt
      cipher.key = session_key
      cipher.iv = iv
      decrypted = JSON.parse(cipher.update(encrypted_data) + cipher.final)
      Rails.logger.info "decrypted: #{decrypted}"
      app_id = Settings.base_weixin.app_id
      raise('Invalid Buffer') if decrypted['watermark']['appid'] != app_id

      decrypted
    rescue Exception => e
      Rails.logger.info "Weixin get_user_info: #{e.message}"
    end

    def get_phone(code)
      token = get_access_token
      url = URI("https://api.weixin.qq.com/wxa/business/getuserphonenumber?access_token=#{token}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      params = { code: code }.to_json
      header = {'content-type': 'application/json'}
      res = http.post(url, params, header)
      data = JSON.parse res.body
      if data['errcode'].zero?
        [true, data['phone_info']['phoneNumber']]
      else
        [false, data['errmsg']]
      end
    end

    def get_url_link(path, query, env_version)
      token = get_access_token
      url = URI("https://api.weixin.qq.com/wxa/generate_urllink?access_token=#{token}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      params = { path: path, query: query, env_version: env_version }.to_json
      header = { 'content-type': 'application/json' }
      res = http.post(url, params, header)
      data = JSON.parse res.body
      if data['errcode'].zero?
        [true, data['url_link'], (Time.now + 30.days - 1.minute).strftime('%Y-%m-%d %H:%M:%S')]
      else
        [false, data['errmsg']]
      end
    end

    def msg_check(scene = 1, openid, content)
      token = get_access_token
      url = URI("https://api.weixin.qq.com/wxa/msg_sec_check?access_token=#{token}")
      response = Net::HTTP.post url, { version: 2, openid: openid, scene: scene, content: content }.to_json, 'Content-Type' => 'application/json'
      result = JSON.parse(response.body)

      if result['errcode'].zero?
        Rails.logger.info "==== msg_sec_check label: #{result['result']['label']} openid: #{openid}===="
        result['result']['suggest'] == 'pass'
      else
        Rails.logger.info "==== msg_sec_check error: #{result} openid: #{openid}===="
        false
      end
    rescue Exception => e
      Rails.logger.info "==== msg_sec_check Exception: #{result} openid: #{openid}===="
      false
    end

    def media_check(scene = 1, openid, media_url)   # media_type 1:音频;2:图片
      token = get_access_token
      url = URI("https://api.weixin.qq.com/wxa/media_check_async?access_token=#{token}")
      response = Net::HTTP.post url, { version: 2, openid: openid, scene: scene, media_type: 2, media_url: media_url }.to_json, 'Content-Type' => 'application/json'
      result = JSON.parse(response.body)

      if result['errcode'].zero?
        true
      else
        Rails.logger.info "==== msg_media_check error: #{result} openid: #{openid}===="
        false
      end
    rescue Exception => e
      Rails.logger.info "==== msg_media_check Exception: #{result} openid: #{openid}===="
      false
    end

    def draw_text(img)
      img.combine_options do |c|
        # c.draw "image Over 0,0 10,10"
        c.thumbnail '300x500>'
        c.background 'blue'
      end
    end

    def get_miniapp_qrcode(scene)
      # 先检查是否有这张图片
      an_quan_dian = AnQuanDian.find_by!(id: scene)
      url = "https://api.weixin.qq.com/wxa/getwxacodeunlimit?access_token=#{get_access_token}"

      data = { page: 'pages/form/form', scene: scene }
      result = HTTParty.post(url, body: data.to_json)
      if result["errcode"].present?
        [false, result]
      else
        img_base64 = Base64.encode64(result.body)
        # TODO: 重构
        tempfile = Tempfile.new(["miniapp-qrcode-#{scene}", '.png'])
        tempfile.binmode
        tempfile.write(Base64.decode64(img_base64))
        tmp_path = tempfile.path # 临时文件的路径
        # FileUtils.mv tmp_path, "#{Rails.root}/public/assets/miniapp-qrcode-#{scene}.jpg"
        png_path = "#{Rails.root}/public/miniapp-qrcode-#{scene}.jpg"
        png_public_path = "/miniapp-qrcode-#{scene}.jpg"
        an_quan_dian_name = an_quan_dian.name
        jing_qu_name = an_quan_dian&.jing_qu&.name
        tmp_image = MiniMagick::Image.open(tmp_path)
        img_width, img_height = tmp_image[:width], tmp_image[:height]
        tempfile.close

        MiniMagick::Tool::Convert.new do |i|
          i.size '600x600'
          i.gravity 'North'
          i.draw "image Over 0,0 #{img_width},#{img_height} '#{tmp_path}'"
          i.gravity 'South'
          i.draw "text 2, 2 '#{an_quan_dian_name}\n\n#{jing_qu_name}'"
          i.stroke('#000000')
          i.strokewidth 1
          i.fill('#FFFFFF')
          i.pointsize '40'
          i.font "#{Rails.root}/app/assets/stylesheets/simfang.ttf"
          i.gravity 'center'
          i.extent('600x600')
          i.xc 'white'
          i << png_path
        end

        [true, png_public_path]
      end
    end
  end
end
