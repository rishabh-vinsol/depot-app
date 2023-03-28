class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(:email, options[:message] || "is not valid") unless
      value =~ /^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$/
  end
end

class User < ApplicationRecord
  after_destroy :ensure_an_admin_remains
  validates :name, presence: true, uniqueness: true
  validates :email, uniqueness: true, email: true
  has_secure_password

  class Error < StandardError
  end

  private

  def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new "Can't delete last user"
    end
  end
end
