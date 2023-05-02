class OrderMailer < ApplicationMailer
  default from: "Sam Ruby <depot@example.com>"

  def received
    @order = Order.find_by(id: params[:order_id])

    @order.line_items.each do |line_item|
      product = line_item.product
      product_images = product.images.to_a

      attachments.inline["#{product.title}_1"] = product_images.shift.download
      product_images.each_with_index do |image, index|
        attachments["#{product.title}_#{index + 2}"] = image.download
      end
    end

    I18n.with_locale(User.languages[@order.user.language]) do
      mail to: email_address_with_name(@order.email, @order.name)
    end
  end

  def shipped
    @order = Order.find_by(id: params[:order_id])

    mail to: @order.email
  end
end
