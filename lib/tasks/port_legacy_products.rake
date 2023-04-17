namespace :port_legacy_products do
    task :set_category_default => :environment do
        first_category_id = Category.first.id
        Product.where(category_id: nil).update_all(category_id: first_category_id)
    end
end
