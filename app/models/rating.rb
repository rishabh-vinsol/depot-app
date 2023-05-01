class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :product
  validates :user_id, uniqueness: { scope: :product_id }
  validates :points, numericality: { in: 0..5 }
end
