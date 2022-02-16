class User < ApplicationRecord
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  has_many  :posts
  
  validates :name,  presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  
  has_secure_password
  validates :password, length: { minimum: 6 }

  # Возвращает случайный токен
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Возвращает хешированный токен
  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
    
    # Создаёт хешированный remember token экземпляру User
    def create_remember_token
      self.remember_digest = User.digest(User.new_token)
    end
end
