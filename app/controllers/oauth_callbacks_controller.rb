class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth_with('Github')
  end

  def vkontakte
    oauth_with('VK')
  end

  private

  def oauth_with(provider)
    @user = FindForOauthService.new(request.env['omniauth.auth']).call

    if @user&.persisted?
      sign_in_and_redirect(@user, event: :authentication)
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end

    @user
  end
end
