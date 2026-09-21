class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail subject: "Сброс пароля — Планировщик дня и привычек", to: user.email_address
  end
end
