namespace :order do
  desc 'Sends all of the users a consolidated email of all of his orders and items'
  task :send_orders_details => :environment do
    Order.all.each do |order|
      puts "Sending order details for user #{order.user.name} of order id #{order.id}"
      OrderMailer.with(order: order).received
    end
    puts "Mail regarding order details send to all the users"
  end
end
