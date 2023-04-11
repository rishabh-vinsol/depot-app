class Category < ApplicationRecord
  has_many :subcategories, class_name: "Category", foreign_key: :parent_id, dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true
  has_many :products, dependent: :restrict_with_error
  has_many :subcategories_products, through: :subcategories, source: :products

  validates :name, presence: true
  validates :name, uniqueness: true, allow_blank: true, unless: :parent_id
  validates :name, uniqueness: {scope: :parent_id}, allow_blank: true
  validate :sub_category_not_having_child_category, if: :parent_id

  private

  def sub_category_not_having_child_category
      errors.add(:base, :sub_category_cannot_have_child) if parent.parent_id.present?
  end
end
