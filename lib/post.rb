class Post
  attr_accessor :id, :title, :content, :comments, :date, :user_id

  def initialise
    @comments = []
  end
end
