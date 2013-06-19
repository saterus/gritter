class User < Neo4j::Rails::Model

  property :username, type: String, index: :exact
  property :name, type: String, index: :fulltext
  property :bio, type: String
  property :updated_at
  property :created_at

  has_one(:credential).from(Credential, :owner)
  has_n(:grits).from(Grit, :author)
  has_one(:latest_grit).to(Grit)

  has_n(:following).to(User)
  has_n(:followers).from(User, :following)

  validates :username, presence: true, length: {in: 1..20}
  validates :name, presence: true, length: {in: 1..50}

  def avatar_url(size=80)
    "https://secure.gravatar.com/avatar/#{avatar_hash}?f=y&d=wavatar&s=#{size}"
  end

  private

  def avatar_hash
    Digest::MD5.hexdigest(username)
  end

end
