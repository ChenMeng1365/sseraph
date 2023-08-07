#coding:utf-8
require 'net/http'
# https://ruby-doc.org/stdlib-3.0.1/libdoc/net/http/rdoc/Net/HTTP.html

module Webot
  module_function
  
  def get options
    http = Net::HTTP.new(options[:url], (options[:port] || 80))
    http.use_ssl = options[:https] || false
    protocol = http.use_ssl? ? "https" : "http"
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl?
    path = options[:path] || '/'
    
    resp, data = http.get(path)
    cookie  = (options[:cookies] ? options[:cookies] : resp.response['set-cookie']).to_s.split(', ')[0].split('; ')[0]
    headers = {
      'Cookie' => cookie,
      'Referer' => (options[:referer] || "#{protocol}://#{options[:url]}"),
      'Content-Type' => 'application/x-www-form-urlencoded'
    }.merge!(options[:headers] || {})
    
    resp, data = http.get(path, headers)
    result = {'headers'=>{},'body'=>''}
    result['Code'] = resp.code
    result['Message'] = resp.message
    resp.each do|key,value|
      result['headers'][key] = value
    end
    result['body'] = resp.body
    return result
  end
  
  def post options
    path = options[:path] || '/'
    options[:protocol] = options[:protocol] ? options[:protocol] : (options[:https] ? 'https' : 'http')
    uri = URI("#{options[:protocol]}://#{options[:url]}:#{options[:port]}#{path}")
    req = Net::HTTP::Post.new(uri, options[:headers])

    cookie  = (options[:cookies] ? options[:cookies] : '').to_s.split(', ').to_s[0].split('; ')[0]
    headers = {
      'Cookie' => cookie,
      'Referer' => (options[:referer] || "#{options[:protocol]}://#{options[:url]}:#{options[:port]}#{path}"),
      'Content-Type' => 'application/x-www-form-urlencoded'
    }.merge!(options[:headers] || {})
    req.set_form_data(options[:data] || {})

    resp = Net::HTTP.start(options[:url], options[:port]) do |http|
      http.request(req)
    end
    
    result = {'headers'=>{},'body'=>''}
    case resp
    when Net::HTTPSuccess, Net::HTTPRedirection
      result['Code'] = resp.code
      result['Message'] = resp.message
      resp.each do|key,value|
        result['headers'][key] = value
      end
      result['body'] = resp.body
    else
      resp.value
    end
    return result
  end
end

__END__
result = Webot.get( url: 'www.baidu.com' )
result = Webot.post( url: '127.0.0.1', port:4567, path: '/1', data: {a: "1314"} )
pp result