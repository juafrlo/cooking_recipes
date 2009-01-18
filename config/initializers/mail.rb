require "smtp_tls"
 
ActionMailer::Base.delivery_method = :sendmail
ActionMailer::Base.smtp_settings = {
:address => "smtp.gmail.com",
:port => 587,
:authentication => :plain,
:user_name => "you@gmail.com",
:password => 'yourpassword'}