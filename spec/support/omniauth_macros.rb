module OmniauthMacros
  def mock_auth_hash(provider:, email: nil)
    info = email.nil? ? {} : { 'email' => email }

    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new({
                                                                          'provider' => provider.to_s,
                                                                          'uid' => '123545',
                                                                          'info' => info
                                                                        })
  end
end
