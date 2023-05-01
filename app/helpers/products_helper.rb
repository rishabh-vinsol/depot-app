module ProductsHelper
  def generate_image_url(image)
    image.present? ? rails_blob_path(image, disposition: "attachment") : "logo.svg"
  end

  def generate_ratings
    (0..5).step(0.5).to_a
  end

 

  def current_user_product_rating(ratings, current_user)
    ratings.find_by(user_id: current_user.id).try(:points) || 0
  end
end
