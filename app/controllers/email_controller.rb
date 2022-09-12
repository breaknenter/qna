class EmailController < ApplicationController
  def new
  end

  def create
    user = User.where(email: email_params).first

    if user
      sign_in_and_redirect user
    else
      password = Devise.friendly_token(10)
      user = User.new(
               email: email_params,
               password: password,
               password_confirmation: password
             )

      user.save ? user.send_confirmation_instructions : render(:new)
    end
  end

  private

  def email_params
    params.require(:email)
  end
end
