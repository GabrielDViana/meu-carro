class User < ActiveRecord::Base
  attr_accessible :complete_name, :email, :password, :token
  has_secure_password
  before_create { generate_token(:token) }
  before_create :confirmation_token

  validates   :password,
              :on => :create,
              length:{
                minimum: 6,
                maximum: 20
              },
              presence: true

  def to_param
    token
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  private
    def confirmation_token
      if self.confirm_token.blank?
        self.confirm_token = SecureRandom.urlsafe_base64.to_s
      end
    end
end
