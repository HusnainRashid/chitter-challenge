# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/post_repository'
require_relative 'lib/comment_repository'
require_relative 'lib/user_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/post_repository'
    also_reload 'lib/user_repository'
    also_reload 'lib/comment_repository'
  end

  get '/' do
    return erb(:index)
  end

  get '/posts' do
    repo = PostRepository.new
    @posts = repo.all

    return erb(:posts)
  end

  get '/users' do
    repo = UserRepository.new
    @users = repo.all

    return erb(:users)
  end

  get '/signup' do
    return erb(:signup)
  end

  post '/signup' do
    if invalid_request_signup?
      status 400
      return ''
    end

    repo = UserRepository.new
    new_user = User.new
    new_user.name = params[:name]
    new_user.username = params[:username]
    new_user.email_address = params[:email_address]
    new_user.password = params[:password]

    repo.create(new_user)

    return ''
  end

  def invalid_request_signup?
    return (params[:name] == nil || params[:username] == nil || params[:email_address] == nil || params[:password] == nil)
  end
end
