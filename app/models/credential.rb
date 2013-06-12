require 'bcrypt'

class Credential < Neo4j::Rails::Model

  attr_accessor :password

  property :password_salt, type: String
  property :password_hash, type: String
  property :updated_at
  property :created_at

  has_one(:owner).to(User)

  validates :password_salt, presence: true
  validates :password_hash, presence: true
  validates :password, presence: true, on: :save
  validates :password, confirmation: true, length: {minimum: 8}, if: :password?

  before_validation :encrypt_password

  def authenticated_with?(pw)
    return false if pw.blank?
    BCrypt::Engine.hash_secret(pw, self.password_salt) == self.password_hash
  end


  private

  def encrypt_password
    if password?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def password?
    self.password.present?
  end

end
