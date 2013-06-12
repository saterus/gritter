class User < Neo4j::Rails::Model

  property :username, type: String, index: :exact
  property :name, type: String, index: :fulltext

  has_one(:credential).from(Credential, :owner)

  validates :username, presence: true, length: {in: 1..20}
  validates :name, presence: true, length: {in: 1..50}

end
