class UserMailer < ApplicationMailer
    default from: "support.admin@depotapp.com"
    def welcome_email(user_id)
        @user = User.find(user_id)
        mail(to: @user.email, subject: 'Welcome to Depot App')
    end
end
