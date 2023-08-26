class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post


  #This validates the uniqueness of the user_id for that exact post_id, meaning, it will disallow the user who carries the id form liking the post more than a single time!
  validates :user_id, uniqueness: { scope: :post_id}

end
