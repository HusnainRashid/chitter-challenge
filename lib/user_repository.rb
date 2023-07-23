require_relative './user'

class UserRepository
  def all
    users = []

    sql = 'SELECT * FROM users;'
    result_set = DatabaseConnection.exec_params(sql, [])

    result_set.each do |record|
      # This section is added to its own method at the end
      # user = User.new

      # user.id = record['id']
      # user.name = record['name']
      # user.username = record['username']
      # user.email_address = record['email_address']
      # user.password = record['password']
      users << record_to_user_object(record)
    end

    return users
  end

  def find(id)
    sql = 'SELECT * FROM users WHERE id = $1;'
    sql_params = [id]

    result_set = DatabaseConnection.exec_params(sql, sql_params)
    record = result_set[0]

    return record_to_user_object(record)
  end

  def create(user)
    sql = 'INSERT INTO
            users (name, username, email_address, password)
            VALUES ($1, $2, $3, $4)'

    sql_params = [user.name, user.username, user.email_address, user.password]
    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def delete(id)
    sql = 'DELETE FROM users WHERE id = $1'
    sql_params = [id]
    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def record_to_user_object(record)
    user = User.new

    user.id = record['id']
    user.name = record['name']
    user.username = record['username']
    user.email_address = record['email_address']
    user.password = record['password']

    return user
  end
end

