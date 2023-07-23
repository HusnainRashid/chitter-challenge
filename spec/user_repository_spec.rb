require 'user_repository'
require 'user'

RSpec.describe UserRepository do
  def reset_users_table
    seed_sql = File.read('seeds/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_db_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_users_table
  end

  it 'returns all the users' do
    repo = UserRepository.new
    users = repo.all

    expect(users.length).to eq(3)

    expect(users.first.name).to eq('George Orwell')
    expect(users.first.username).to eq('gomakers')
    expect(users.first.email_address).to eq('gomakers@makers.com')
    expect(users.first.password).to eq('1984')
  end

  it 'returns a single user' do
    repo = UserRepository.new
    user = repo.find(2)

    expect(user.id).to eq('2')
    expect(user.name).to eq('Sam Morgan')
    expect(user.username).to eq('sjmog')
    expect(user.email_address).to eq('samm@makers.com')
    expect(user.password).to eq('magma')
  end

  it 'creates a new user' do
    repo = UserRepository.new
    new_user = User.new

    new_user.name = 'Tom Cat'
    new_user.username = 'tomcattus'
    new_user.email_address = 'tcattus@makers.com'
    new_user.password = 'jerrymouse1'

    repo.create(new_user)

    all_users = repo.all

    expect(all_users).to include(
      have_attributes(
        name: new_user.name,
        username: new_user.username,
        email_address: new_user.email_address,
        password: new_user.password)
    )
  end

  it 'deletes a user' do
    repo = UserRepository.new
    repo.delete(1)
    repo.delete(2)
    users = repo.all

    expect(users.length).to eq(1)
    expect(users.first.id).to eq('3')
  end
end
