class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :user_interactions, dependent: :destroy
  has_many :liked_verses, -> { where(user_interactions: { liked: true }) }, through: :user_interactions, source: :verse

  # Messaging associations
  has_many :user_conversations, dependent: :destroy
  has_many :conversations, through: :user_conversations
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id', dependent: :destroy
  has_many :admin_conversations, dependent: :destroy

  validates :username, presence: true, uniqueness: true, allow_nil: true

  # Search users by username
  scope :search_by_username, ->(query) { where('username ILIKE ?', "%#{query}%") }

  after_create :generate_username
  after_create :send_welcome_message
  
  def generate_username
    return unless email.present?
    return if username.present? # Skip if username is already set
    
    # Extract email username (part before @)
    email_username = email.split('@').first
    
    # List of random words to append
    random_words = %w[
      star moon sun ocean river mountain forest valley desert island
      cloud rainbow thunder lightning storm breeze wave tide shore
      eagle hawk dove sparrow robin owl falcon swan peacock
      rose lily tulip daisy sunflower orchid jasmine lavender
      peace hope faith love joy grace wisdom courage strength
      warrior guardian protector seeker wanderer explorer dreamer
      light shadow dawn dusk twilight sunrise sunset horizon
    ]
    
    # Generate username with email and random word, ensuring uniqueness
    while true
      random_word = random_words.sample
      self.username = "#{email_username}_#{random_word}"
      
      # Check if username is valid (unique)
      errors.clear
      if self.valid?
        break
      end
      
      # If not unique, try with a random number appended
      errors.clear
      self.username = "#{email_username}_#{random_word}_#{rand(1000..9999)}"
      break if self.valid?
    end
    
    save
  end

  def send_welcome_message
    # Create welcome admin conversation
    welcome_message = "Welcome to Promesas! We're so glad you're here. We hope you find peace, inspiration, and strength through God's word. If you have any questions or need support, feel free to reach out to us anytime. Blessings!"
    
    admin_conversations.create(
      body: welcome_message
    )
  end
end