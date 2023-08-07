#coding:utf-8
$LOAD_PATH<<"."
require 'mailmessenger'
require 'json'
require 'uri'

begin
  mm = Object.new
  mm.extend MailMessenger
  path = "."
  postmen,receivers = mm.load_config "#{path}/postman.json"

  name = "CustomerName"
  domain = "MailDomainName"
  postman = postmen.find{|pm|pm['domain'].to_s==domain}
  receiver = receivers.find{|rc|rc['name'].to_s.include?(name)}

  lines = File.read("#{path}/mailauth.template").gsub("\r",'').split("\n")
  title = lines[0]
  body, tmpl  = lines[1..-1].join("\n").split("\n--- r\n")
  text,args = body,{}
  # tmpl.split("\n").each do|line|
  #   !line.include?("=") and next
  #   k,v = line.split("=")
  #   args[k.strip] = v.strip
  # end
  args = {
    'user' => "#{receiver['username']}@#{receiver['domain']}",
    'code' => 6.times.map{(('a'..'z').to_a+(0..9).to_a).shuffle.first}.join,
    'time' => Time.new.strftime("%Y%m%d%H%M%S"),
    'request-uri' => 'a.b.c.d'
  }
  args.each do|k,v|
    text = text.gsub("((#{k}))",v)
  end

  sheet = {
    "sender_name"=>postman['username'],
    "sender_box"=>"#{postman['username']}@#{postman['domain']}",
    "receiver_name"=>receiver['username'],
    "receiver_box"=>"#{receiver['username']}@#{receiver['domain']}",
    "title"=>title.encode('GBK'),
    "context"=>text.encode('GBK')
  }
  message = mm.make_mail sheet
  mm.send_mail message
  File.open('authcode.txt','a+'){|f|f.write args.to_json+"\n"}

end
__END__
