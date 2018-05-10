# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  age             :string           not null
#

class User < ApplicationRecord
  validates :username, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}
  validates :password_digest, presence: true
  validates :age, presence: true

  before_validation :ensure_session_token

  def self.find_by_credentials(user_name, password)
    user = User.find_by(username: user_name)
    return nil unless user
    user.is_password?(password) ? user : nil
  end


  attr_reader :password

  has_many :cats,
  class_name: 'Cat',
  foreign_key: :user_id,
  primary_key: :id

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end

  def reset_session_token
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end
