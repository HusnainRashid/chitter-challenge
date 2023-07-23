require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET /' do
    it 'returns 200 OK and the homepage' do
      response = get('/')

      expect(response.status).to eq(200)
    end
  end

  context 'GET /posts' do
    it 'returns 200 OK and gets the posts' do
      response = get('/posts')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/posts/3">evening</a>')
      expect(response.body).to include('<a href="/posts/4">nobody</a>')
    end
  end

  context 'GET /users' do
    it 'returns all the users' do
      response = get('/users')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/users/3">Husnain Rashid</a>')
    end
  end

  context 'GET /signup' do
    it 'returns the sign up page' do
      response = get('/signup')

      expect(response.status).to eq(200)
      expect(response.body).to include('<label>Username</label>')
      expect(response.body).to include('<input type="text" name="username">')
      expect(response.body).to include('<form action="/signup" method="POST">')
    end
  end

  context 'POST /signup' do
    it 'creates a new user' do
      response = post(
        "/signup",
        name: "Bruce Lee",
        username: "blee12",
        email_address: "blee12@makers.com",
        password: "enterthedragon"
      )

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get("/users")

      expect(response.body).to include("Bruce Lee")
    end

    it 'should validate the parameters set' do
      response = post(
        'signup',
        invalid_name: 'Stupid user',
        invalid_others: '3566'
      )

      expect(response.status).to eq(400)
    end
  end
end
