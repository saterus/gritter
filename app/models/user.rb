class User < Neo4j::Rails::Model

  property :username, type: String, index: :exact
  property :name, type: String, index: :fulltext
  property :updated_at
  property :created_at

  has_one(:credential).from(Credential, :owner)
  has_n(:grits).from(Grit, :author)
  has_one(:latest_grit).to(Grit)

  validates :username, presence: true, length: {in: 1..20}
  validates :name, presence: true, length: {in: 1..50}

end
