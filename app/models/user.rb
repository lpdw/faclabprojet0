class User < ApplicationRecord
  before_save { self.email = email.downcase }
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :login, presence: true, uniqueness: true, length: {minimum: 5, maximum:30}
  validates :email, presence: true, format: {with: EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}
end
