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

  def timeline
    grits = Neo4j.query(self){ |u|
      u > User.following > node(:followed) < Grit.author < node(:g).desc(:created_at).limit(25)
      ret(:g)
    }.to_a.map{|res| res[:g] }

    if grits.empty?
      grits = Grit.find(:all).take(50)
    end

    grits
  end

  def full_timeline
    theirs = timeline

    (theirs + self.grits).sort_by(&:created_at).reverse.take(25)
  end

  private

  def avatar_hash
    Digest::MD5.hexdigest(username)
  end

end
