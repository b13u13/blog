class User < ActiveRecord::Base
  before_save { self.email = email.downcase if email}
  before_create :create_remember_token
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :reverse_relationships, foreign_key: "followed_id",
           class_name:  "Relationship",
           dependent:   :destroy
  mount_uploader :avatar, AvatarUploader
  has_secure_password
  enum locale: %i(ru en)
  validates :avatar,  file_size: { less_than_or_equal_to: 5.megabyte }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,  presence: true,
                     format:     { with: VALID_EMAIL_REGEX },
                     uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  validates :nick_name,  presence: true,
            uniqueness: { case_sensitive: true }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end


  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end




end
