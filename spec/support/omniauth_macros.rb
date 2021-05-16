module OmniauthMacros
  def mock_auth_hash(provider:, email: nil)
    info = email.nil? ? {'email' => nil} : { 'email' => email }

    auth = OmniAuth::AuthHash.new({
                                    'provider' => provider.to_s,
                                    'uid' => '123545',
                                    'info' => info
                                  })

    OmniAuth.config.mock_auth[provider.to_sym] = auth
    auth
  end
end
