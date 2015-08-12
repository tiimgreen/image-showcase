require 'sinatra'

get '/' do
  @auth = authorized?
  @images = Image.all
  haml :index
end

get '/images/:id' do
  @image = Image.find(params[:id])
  haml :show
end

post '/images' do
  protected!
  @image = Image.new(params[:image])
  @image.save
  redirect '/'
end

get '/auth' do
  protected!
  redirect '/'
end

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||= Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['admin', 'admin']
  end
end
