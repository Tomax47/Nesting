class User < ApplicationRecord

  has_many :posts
  has_many :comments
  has_many :likes

  validates :email, uniqueness: true, allow_nil: true
  validates :username, uniqueness: true, presence: true
  validates :password, length: {minimum: 6, allow_nil: true }


  def password
    @password
  end

  def password=(raw_password)

    @password = raw_password

    self.password_digest = BCrypt::Password.create(raw_password)
  end

  def is_password?(raw_password)
    BCrypt::Password.new(password_digest).is_password?(raw_password)
  end


end
