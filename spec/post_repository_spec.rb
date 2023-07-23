require 'post_repository'
require 'post'

RSpec.describe PostRepository do
  def reset_posts_table
    seed_sql = File.read('seeds/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_db_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_posts_table
  end

  it 'returns all posts' do
    repo = PostRepository.new
    posts = repo.all

    expect(posts.length).to eq(4)

    expect(posts.first.title).to eq('hello')
    expect(posts.first.content).to eq('goodbye after')
    expect(posts.first.date).to eq('2008-11-11')
    expect(posts.first.user_id).to eq(1)
  end

  it 'returns a single post' do
    repo = PostRepository.new
    posts = repo.find(2)

    expect(posts.title).to eq('goodbye')
    expect(posts.content).to eq('hello after')
    expect(posts.date).to eq('2010-12-09')
    expect(posts.user_id).to eq(1)
  end

  it 'creates a new record' do
    repo = PostRepository.new
    new_posts = Post.new
    new_posts.title = 'Days'
    new_posts.content = 'Monday, Tuesday etc'
    new_posts.date = '2013-05-06'
    new_posts.user_id = 3

    repo.create(new_posts)

    all_posts = repo.all

    expect(all_posts).to include(
      have_attributes(
        title: new_posts.title,
        content: new_posts.content,
        date: new_posts.date,
        user_id: new_posts.user_id)
    )
  end

  it 'deletes a post' do
    repo = PostRepository.new
    repo.delete(1)
    repo.delete(2)

    posts = repo.all
    expect(posts.length).to eq(2)
    expect(posts.first.id).to eq('3')
  end
end
