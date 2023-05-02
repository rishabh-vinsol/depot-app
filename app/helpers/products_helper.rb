module ProductsHelper
  def generate_image_url(image)
    image.present? ? rails_blob_path(image, disposition: "attachment") : "logo.svg"
  end
end
