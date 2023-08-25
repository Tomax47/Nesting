class User < ApplicationRecord

  has_many :posts

  validates :email, uniqueness: true, allow_nil: true
  validates :username, uniqueness: true, presence: true
  validates :password, length: {minimum: 6, allow_nil: true }
end
