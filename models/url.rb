#url model
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db")
class Url
  include DataMapper::Resource
  property :id, Serial  
  property :redirect_to, String, :required => true
  property :hashname, String, :required => true
  property :last_accessed, DateTime
  property :times_viewed, Integer
  property :created_at, DateTime
  property :updated_at, DateTime
end
DataMapper.finalize.auto_upgrade!