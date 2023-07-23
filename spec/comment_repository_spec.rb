require 'comment_repository'
require 'comment'

RSpec.describe CommentRepository do
  def reset_comments_table
    seed_sql = File.read('seeds/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_db_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_comments_table
  end

  it 'returns all the comments' do
    repo = CommentRepository.new
    comments = repo.all

    expect(comments.length).to eq(3)
    expect(comments.first.content).to eq('This was a very accurate comment')
    expect(comments.first.post_id).to eq(1)
  end

  it 'returns a single comment' do
    repo = CommentRepository.new

    comments = repo.find(2)

    expect(comments.content).to eq('This was completely innaccurate')
    expect(comments.date).to eq('2010-12-11')
    expect(comments.user_id).to eq(3)
    expect(comments.post_id).to eq(2)
  end

  it 'makes a new post' do
    repo = CommentRepository.new
    new_comment = Comment.new
    new_comment.content = 'The post has been finished'
    new_comment.date = '2016-04-10'
    new_comment.user_id = 3
    new_comment.post_id = 2

    repo.create(new_comment)

    all_comments = repo.all

    expect(all_comments).to include(
      have_attributes(
        content: new_comment.content,
        date: new_comment.date,
        user_id: new_comment.user_id,
        post_id: new_comment.post_id)
    )
  end

  it 'deletes a record' do
    repo = CommentRepository.new
    repo.delete(1)

    comments = repo.all
    expect(comments.length).to eq(2)
    expect(comments.first.id).to eq('2')
  end
end
