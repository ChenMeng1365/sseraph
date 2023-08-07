#coding:utf-8
require 'net/smtp'
 
module MailMessenger
  def receiver
    @receiver
  end
  
  def postman
    @postman
  end

  def load_config path
    # [ {id: str, usertype: str, server: str, port: str, username: str, password: str, domain: str, authtype: str}, ... ]
    post_list = JSON.parse(File.read(path))
    @postman = post_list.select{|person|person["usertype"]=="sender"}
    @receiver = post_list.select{|person|person["usertype"]=="receiver"}
    return @postman,@receiver
  end
  
  def make_mail sheet
    # :context not 'context'
    sheet.clone.merge({ context: %Q{From: #{sheet['sender_name']} <#{sheet['sender_box']}>
To: #{sheet['receiver_name']} <#{sheet['receiver_box']}>
Subject: #{sheet['title']}

#{sheet['context']}}   })
  end

  def send_mail message
    option =@postman[0]
    (warn "There are no postman available!"; return ) unless option
    Net::SMTP.start(
      option['server'], option['port'], option['username'], option['username'], option['password'], option['authtype'].to_sym
    ) do |smtp|
      smtp.send_message message[:context], message['sender_box'], message['receiver_box'] # use :context
    end
  end
  
  def receive_mail mailbox
    # todo
    # coding b64?html?
  end
end

=begin
  require 'json'
  mm = Object.new
  mm.extend MailMessenger
  postman,receiver = mm.load_config "./postman.json"
  sheet = {
    "sender_name"=>postman[0]['username'],
    "sender_box"=>"#{postman[0]['username']}@#{postman[0]['domain']}",
    "receiver_name"=>receiver[3]['username'],
    "receiver_box"=>"#{receiver[3]['username']}@#{receiver[3]['domain']}",
    "title"=>'互相测试',
    "context"=>"这条消息是：\n#{postman[0]['username']}@#{postman[0]['domain']} to #{receiver[3]['username']}@#{receiver[3]['domain']}"
  }
  message = mm.make_mail sheet
  mm.send_mail message
=end

__END__
[126]
POP3服务器 pop.126.com	 110
SMTP服务器 smtp.126.com	 25
IMAP服务器 imap.126.com	 143

[163]
imap.163.com  SSL:993 非SSL:143
smtp.163.com  SSL:465,994 非SSL:25
pop.163.com SSL:995 非SSL:110

[QQ]
POP3/SMTP协议
接收邮件服务器：pop.exmail.qq.com ，使用SSL，端口号995
发送邮件服务器：smtp.exmail.qq.com ，使用SSL，端口号465
海外用户可使用以下服务器
接收邮件服务器：hwpop.exmail.qq.com ，使用SSL，端口号995
发送邮件服务器：hwsmtp.exmail.qq.com ，使用SSL，端口号465
 
IMAP协议
接收邮件服务器：imap.exmail.qq.com  ，使用SSL，端口号993
发送邮件服务器：smtp.exmail.qq.com ，使用SSL，端口号465
海外用户可使用以下服务器
接收邮件服务器：hwimap.exmail.qq.com ，使用SSL，端口号993
发送邮件服务器：hwsmtp.exmail.qq.com ，使用SSL，端口号465