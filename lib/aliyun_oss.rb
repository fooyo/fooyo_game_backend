require 'aliyun/oss'

class AliyunOss
  def initialize
    @client ||= Aliyun::OSS::Client.new(
      endpoint: 'oss-cn-shenzhen.aliyuncs.com',
      access_key_id: Rails.application.credentials.dig(:aliyun, :access_key_id),
      access_key_secret: Rails.application.credentials.dig(:aliyun, :access_key_secret)
    )
    @bucket = 'fooyo-tiger'
  end

  def list_buckets
    @client.list_buckets
  end

  def list_objects(bucket = @bucket)
    bucket = @client.get_bucket(bucket)
    objects = bucket.list_objects
  end

  def upload_from_api(file)
    content_type = Marcel::MimeType.for(file)
    is_image = content_type =~ /image/
    content_type = content_type.in?(%w[image/jpeg image/jpg image/png]) ? 'image/jpg' : content_type
    headers = is_image ? { 'Content-Type': content_type, 'Content-Disposition': 'inline' } : { 'Content-Type': content_type }
    type = file.path.split('.').last
    dir = is_image ? "images" : "files"
    key = "#{dir}/#{SecureRandom.hex(12)}#{Time.current.usec}.#{type}"
    bucket = @client.get_bucket(@bucket)
    flag = bucket.put_object(key, file: file, headers: headers)
    flag ? "https://#{@bucket}.oss-cn-shenzhen.aliyuncs.com/#{key}" : nil
  end

end
