class UserEmailsController < ApplicationController
  skip_authorization_check

  def new; end

  def create
    email = user_email[:email]

    @user = User.save_with_oauth(email: email, uid: session[:uid], provider: session[:provider])
    return render :new if @user.new_record?

    @user.send_confirmation_instructions
    redirect_to root_path, notice: "Verify your email #{email}!"
  end

  private

  def user_email
    params.permit(:email)
  end

end
