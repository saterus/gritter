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

  # START v=node:User_exact("username:greg")
  # MATCH v-[:`User#following`]->(friend)-[:`User#following`]->(foaf)
  # WHERE NOT(v-[:`User#following`]->foaf) AND v <> foaf
  # RETURN distinct(foaf.username) as recommended, count(friend) as score, collect(friend.username) as followed_by
  # ORDER BY score DESC
  def get_recommended_users
    Neo4j.query(self) { |u|
      u > User.following > node(:friend) > User.following > :foaf
      where_not{ u > User.following > :foaf }
      where{ u != :foaf }
      ret(
        node(:foaf).distinct.as(:recommended).limit(25),
        node(:friend).count.as(:score).desc,
        node(:friend)[:username].collect.as(:followed_by)
      )
    }.map{|row|
      recommended = row[:recommended]
      recommended[:followed_by] = row[:followed_by].to_a.sample(3).map{|un| User.find(username: un) }
      recommended[:total_followed_by] = row[:followed_by].count - recommended[:followed_by].count
      recommended
    }
  end

  def timeline
    grits = Neo4j.query(self){ |u|
      u > User.following > node(:followed) < Grit.author < node(:g).desc(:created_at).limit(25)
      ret(:g)
    }.map{|res| res[:g] }

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
