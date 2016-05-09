class UserMailer < ActionMailer::Base

  def registration_confirmation(user)
    @user = user
    mail(:to => user.email,
        :from => 'MeuCarro',
        :subject => "Confirmação de cadastro")
        render 'registration_confirmation'
  end
end
