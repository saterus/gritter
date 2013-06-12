class Registration
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :user

  attribute :username, String
  attribute :name, String
  attribute :password, String
  attribute :password_confirmation, String

  validates :username, presence: true, length: {in: 1..20}
  validates :name, presence: true, length: {in: 1..50}
  validates :password, confirmation: true, length: {minimum: 8}

  # Forms are never themselves persisted
  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private

  def persist!
    @user = User.new(username: username, name: name)
    @credential = @user.build_credential(password: password, password_confirmation: password_confirmation)
    @user.save!
  end
end
