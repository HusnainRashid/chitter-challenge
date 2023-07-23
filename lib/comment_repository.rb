require_relative './comment'

class CommentRepository
  def all
    comments = []

    sql = 'SELECT id, content, date, user_id, post_id FROM comments;'
    result_set = DatabaseConnection.exec_params(sql, [])

    result_set.each do |record|
      # This section is added to its own method at the end. This is here for a reminder
      # comment = comment.new

      # comment.id = record['id']
      # comment.name = record['name']
      # comment.date = record['date']
      # comment.user_id = record['user_id']
      # comment.post_id = record['post_id']
      comments << record_to_comment_object(record)
    end

    return comments
  end

  def find(id)
    sql = 'SELECT id, content, date, user_id, post_id FROM comments WHERE id = $1;'
    sql_params = [id]

    result_set = DatabaseConnection.exec_params(sql, sql_params)
    record = result_set[0]

    return record_to_comment_object(record)
  end

  def create(comment)
    sql = 'INSERT INTO
            comments (content, date, user_id, post_id)
            VALUES ($1, $2, $3, $4)'

    sql_params = [comment.content, comment.date, comment.user_id, comment.post_id]
    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def delete(id)
    sql = 'DELETE FROM comments WHERE id = $1'
    sql_params = [id]
    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def record_to_comment_object(record)
    comment = Comment.new

    comment.id = record['id']
    comment.content = record['content']
    comment.date = record['date']
    comment.user_id = record['user_id'].to_i
    comment.post_id = record['post_id'].to_i

    return comment
  end
end
