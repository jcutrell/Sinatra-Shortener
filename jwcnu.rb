require 'mongo_mapper'
require 'uri'
require 'digest/md5'
require './models/url'

helpers do
  def nickname
    names = ["Sir", "Master", "Homeslice", "Diggity", "J-Cizzle", "Broski", "Killer", "Broham"]
    names[rand(names.length() -1)]
  end
end

get "/" do
  @title = "HOME!"
  erb :index
end

get "/:url" do
  url = URL.find_by_url_key(params[:url])
  if url.nil?
    raise Sinatra::NotFound
  else
    url.last_accessed = Time.now
    url.times_viewed += 1
    url.save
    redirect url.full_url, 301
  end
end

post "/new" do
  new_url = params[:url]
  if params[:chooseUrl].empty?
    @url_key = Digest::MD5.hexdigest(new_url)[0..4]
  else
    @url_key = params[:chooseUrl]
  end
  erb :new
end