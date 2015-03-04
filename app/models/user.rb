class User < ActiveRecord::Base
  before_save { self.email = email.downcase if email}
  attr_accessor  :activation_token, :reset_token
  before_create :create_remember_token, :create_activation_digest
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

  validates :nick_name, length: { maximum: 24 }, presence: true,
            uniqueness: { case_sensitive: true }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.new_token
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


  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver!
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest".to_sym)
    return false if digest.nil?
    User.encrypt(token).eql?(digest)
  end


  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.encrypt(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver!
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end



  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.encrypt(activation_token)
    end


end
