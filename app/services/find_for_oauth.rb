class FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first

    return authorization.user if authorization&.user

    email = auth.info[:email]

    return unless email

    user = User.where(email: email).first
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      user.skip_confirmation!
      user.save
    end

    user.authorizations.create!(provider: auth.provider, uid: auth.uid)
    user
  end
end
