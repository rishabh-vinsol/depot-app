class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || "is not a valid image format") unless value =~ IMAGE_FORMAT
  end
end

class Product < ApplicationRecord
  after_initialize :set_title_default
  before_save :set_discount_price_default
  after_create_commit :increment_product_count
  has_many :line_items, dependent: :restrict_with_error
  has_many :orders, through: :line_items
  has_many :carts, through: :line_items
  has_many_attached :images
  belongs_to :category, counter_cache: true
  # before_destroy :ensure_not_referenced_by_any_line_item
  validates :title, :description, :image_url, presence: true
  validates_length_of :words_in_description, minimum: 5, maximum: 10
  validates :price, allow_blank: true, numericality: { greater_than: :discount_price }
  # validate :price_greater_than_discount_price
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, url: true
  validates :permalink, uniqueness: true, format: { with: PERMALINK_FORMAT }
  validates_length_of :words_in_permalink, minimum: 3
  validates :images, length: {maximum: 3}

  scope :enabled_products, -> {
          where(enabled: true)
        }

  scope :present_in_line_items, -> {
          joins(:line_items).distinct
        }

  def self.titles_present_in_line_items
    joins(:line_items).select(:id, :title).distinct
  end

  private

  def set_discount_price_default
    self.discount_price ||= price
  end

  def set_title_default
    self.title ||= "abc"
  end

  def price_greater_than_discount_price
    if price && discount_price
      errors.add(:base, :price_less_than_discount) unless price > discount_price
    end
  end

  def words_in_permalink
    permalink&.split("-")
  end

  def words_in_description
    description&.scan(/\w+/)
  end

  def increment_product_count
    if category.parent.present?
      category.parent.increment!(:products_count, 1)
    end
  end

  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, "Line Items present")
      throw :abort
    end
  end
end
