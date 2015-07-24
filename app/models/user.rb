class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, uniqueness: true
  validates :name, :grade, presence: true
  before_save :ensure_authentication_token
  ## Database authenticatable
  field :email,              type: String, default: ""
  index({email: 1},{unique: true, name: "user_email_index"})
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  field :name, type: String
  field :grade, type: String
  field :score, type: Integer
  field :authentication_token, type: String
  index({authentication_token: 1},{unique: true, name: "user_authentication_token_index"})
  field :default_difficulty, type: String

  belongs_to :role
  has_many :learnings, :dependent => :destroy

  def role?(role)
    self.role.name == role.to_s
  end

  def score_ranking
    rank = 0
    user_array = User.all.desc(:score).to_a
    (0..user_array.size-1).each do |i|
      rank = i+1 if self.id == user_array[i].id
    end
    "#{rank}/#{User.all.count}"
  end

  def score_rating
    score.to_i/30
  end

  before_create do
    self.role ||= Role.find_by(name: 'student')
    self.default_difficulty = {"6"=>"one", "7"=>"two", "8"=>"three", "9"=>"three"}[self.grade]
  end

  before_validation do
    self.email = "#{self.name}@#{self.name}.com"
  end

  #token为空时自动生成新的token
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end
 
  private
 
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
