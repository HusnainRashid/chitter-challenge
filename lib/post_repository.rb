require_relative './post'

class PostRepository
  def all
    posts = []

    sql = 'SELECT id, title, content, date, user_id FROM posts;'
    result_set = DatabaseConnection.exec_params(sql, [])

    result_set.each do |record|
      posts << record_to_post_object(record)
    end

    return posts
  end

  def find(id)
    sql = 'SELECT id, title, content, date, user_id FROM posts WHERE id = $1;'
    sql_params = [id]

    result_set = DatabaseConnection.exec_params(sql, sql_params)
    record = result_set[0]

    return record_to_post_object(record)
  end

  def create(post)
    sql = 'INSERT INTO
            posts (title, content, date, user_id)
            VALUES ($1, $2, $3, $4)'

    sql_params = [post.title, post.content, post.date, post.user_id]
    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def delete(id)
    sql = 'DELETE FROM posts WHERE id = $1'
    sql_params = [id]
    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def record_to_post_object(record)
    post = Post.new

    post.id = record['id']
    post.title = record['title']
    post.content = record['content']
    post.comments = record['comments']
    post.date = record['date']
    post.user_id = record['user_id'].to_i

    return post
  end
end
