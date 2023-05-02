task :make_admin, [:email] do |t, args|
  require_relative "../../config/environment.rb"
  user = User.find_by(email: args[:email])
  if user.present?
    user.update_column(:role, :admin)
    puts "User #{args[:email]} set to admin"
  else
    puts "User with #{args[:email]} not found"
  end
end
