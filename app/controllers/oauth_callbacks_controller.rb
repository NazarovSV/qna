class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    authentication('Github')
  end

  def vkontakte
    authentication('VK')
  end

  private

  def authentication(provider)
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)

    return log_in(user: @user, provider: provider) if @user
    return redirect_to root_path, notice: 'Something went wrong' if auth.info[:email]

    session_auth_info(provider: auth.provider, uid: auth.uid)
    redirect_to new_user_emails_path
  end


  def session_auth_info(provider:, uid:)
    session[:uid] = uid
    session[:provider] = provider
  end

  def log_in(user:, provider:)
    if user.confirmed?
      sign_in_and_redirect(user, event: :authentication)
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: "Confirm your email #{user.email}!"
    end
  end
end

