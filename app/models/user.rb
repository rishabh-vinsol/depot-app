class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(:email, options[:message] || "is not valid") unless
      value =~ EMAIL_FORMAT
  end
end

class User < ApplicationRecord
  enum language: { 
    en: 0, 
    es: 1 
  }
  enum role: {
    user: 0,
    admin: 1,
  }

  ### ASSOCIATIONS ###

  has_one :address, inverse_of: :user, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :line_items, through: :orders
  accepts_nested_attributes_for :address, allow_destroy: true

  ### VALIDATIONS ###

  validates :name, presence: true, uniqueness: true
  validates :email, uniqueness: true, email: true
  validates :language, inclusion: languages.keys

  ### CALLBACKS ###

  before_update :check_admin_email
  before_destroy :check_admin_email
  after_destroy :ensure_an_admin_remains
  after_create_commit :send_welcome_email

  has_secure_password

  class Error < StandardError
  end

  private

  def check_admin_email
    if email_was == ADMIN_EMAIL
      errors.add(:base, "Cannot update/delete user 'admin'")
      throw :abort
    end
  end

  def send_welcome_email
    UserMailer.welcome_email(self.id).deliver_later
  end

  def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new "Can't delete last user"
    end
  end
end
