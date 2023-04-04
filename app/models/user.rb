class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(:email, options[:message] || "is not valid") unless
      value =~ EMAIL_FORMAT
  end
end

class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :line_items, through: :orders
  before_update :check_admin_email
  before_destroy :check_admin_email
  after_create_commit :send_welcome_email
  after_destroy :ensure_an_admin_remains
  validates :name, presence: true, uniqueness: true
  validates :email, uniqueness: true, email: true
  has_secure_password

  class Error < StandardError
  end

  private

  def check_admin_email
    if email == ADMIN_EMAIL
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
