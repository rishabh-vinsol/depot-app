class Address < ApplicationRecord
  belongs_to :user

  validates :state, :city, :country, :pincode, presence: true
  validates :pincode, numericality: { greater_than: 0 }, allow_blank: true
  validates :pincode, length: { is: 6 }, allow_blank: true
end
