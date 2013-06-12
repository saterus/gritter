class Grit < Neo4j::Rails::Model

  property :body, type: String, index: :fulltext
  property :created_at

  has_one(:author).to(User)
  has_one(:previous).to(Grit)
  has_one(:next).from(Grit, :previous)

  validates :body, presence: true, length: {in: 1..140}

end
