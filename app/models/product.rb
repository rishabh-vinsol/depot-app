class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || "is not a valid image format") unless value =~ IMAGE_FORMAT
  end
end

class Product < ApplicationRecord
  has_many :line_items
  has_many :orders, through: :line_items
  before_destroy :ensure_not_referenced_by_any_line_item
  validates :title, :description, :image_url, presence: true
  validates_length_of :words_in_description, minimum: 5, maximum: 10,
                                             too_short: I18n.t("product.description.too_short_message"),
                                             too_long: I18n.t("product.desctiption.too_long_message")
  validates :price, allow_blank: true, numericality: { greater_than: :discount_price }
  # validate :price_greater_than_discount_price
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, url: true
  validates :permalink, uniqueness: true, format: { with: PERMALINK_FORMAT }
  validates_length_of :words_in_permalink, minimum: 3, message: I18n.t("product.permalink.too_short_message")

  private

  def price_greater_than_discount_price
    if price && discount_price
      errors.add(:base, "Price must be greater than discount_price") unless price > discount_price
    end
  end

  def words_in_permalink
    permalink&.split("-")
  end

  def words_in_description
    description&.scan(/\w+/)
  end

  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, "Line Items present")
      throw :abort
    end
  end
end
