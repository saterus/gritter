class UserAuthenticator
  def self.authenticate(username, password)
    user = User.find(username: username)
    if user && user.credential.authenticated_with?(password)
      user
    else
      nil
    end
  end
end
