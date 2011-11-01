require 'uri'
require 'digest/md5'
require 'data_mapper'
require 'sinatra'
require './models/url'

helpers do
  def nickname
    names = ["Sir", "Master", "Homeslice", "Diggity", "J-Cizzle", "Broski", "Killer", "Broham"]
    names[rand(names.length() -1)]
  end
  
  def protected!
    unless Digest::MD5.hexdigest(params[:password]) == "3a67100e1081ab0cc77be30655b5a1e8"
      throw :halt, [403, 'Forbidden']
    end
  end
  
end



get "/" do
  @title = "HOME!"
  erb :index
end

get "/entries" do
  if params[:count].nil?
    @entries = Url.all(:order => [:created_at.desc])
  else
    @entries = Url.all(:limit => Integer(params[:count]), :order => [:created_at.desc])
  end
  erb :entries
end

get "/entries.json" do
  if params[:count].nil?
    @entries = Url.all(:order => [:created_at.desc])
  else
    @entries = Url.all(:limit => Integer(params[:count]), :order => [:created_at.desc])
  end
  @entries.to_json
end

get "/stats" do
  if params[:count].nil?
    @entries = Url.all(:order => [:created_at.desc])
  else
    @entries = Url.all(:limit => Integer(params[:count]), :order => [:created_at.desc])
  end
  @extrajs = '<script src="/jquery.DataTables.js"></script>'
  erb :stats
end

get "/:hashname" do
  url = Url.first(:hashname => params[:hashname])
  if url.nil?
    raise Sinatra::NotFound
  else
    url.last_accessed = Time.now
    url.times_viewed = url.times_viewed + 1
    url.save
    if url.save!
      redirect url.redirect_to
    else
      "Didn't save for some reason."
    end
  end
end
get "/:hashname/stats" do
  @url = Url.first(:hashname => params[:hashname])
  if url.nil?
     raise Sinatra::NotFound
   else
     erb :stats_single
   end
end

post "/new" do
  protected!
  new_url = params[:url]
  
  def uri?(string)
    uri = URI.parse(string)
    %w( http https ).include?(uri.scheme)
  rescue URI::BadURIError
    false
  end
  
  unless uri? new_url
    new_url = "http://" + new_url
  end
  
  url = Url.first(:redirect_to => new_url)
  if url.nil?
    @u = Url.new
    @u.created_at = Time.now
    @u.updated_at = Time.now
    @u.redirect_to = new_url
    @u.times_viewed = 0
    @u.last_accessed = Time.now
    if params[:chooseurl].empty?
      @u.hashname = Digest::MD5.hexdigest(new_url)[0..4]
    else
      @u.hashname = params[:chooseurl]
    end
    if @u.save!
      erb :new
    else
      "Something went wrong! Params: " + params.to_s
    end
  else
    @url = url
    erb :urlexists
  end
end