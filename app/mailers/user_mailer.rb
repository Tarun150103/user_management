# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    puts @user
    mail(to: "anumulakumar1999@gmail.com", subject: 'Welcome to User Management System')
  end
end
