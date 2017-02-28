require 'aws-sdk'
require "securerandom"

client = Aws::IAM::Client.new(region: 'us-east-1')
resource = Aws::IAM::Resource.new(client: client)

puts "Please enter the user's first name"
first_name = gets.chomp

puts "Please enter the user's last name"
last_name = gets.chomp
# Creating a random that complies with Stelligent AWS IAM password policy
random_password = "G" + SecureRandom.base64(3) + "d" + SecureRandom.base64(3) + "@" + SecureRandom.base64(3) + "6"
# This creates a new user and assigns the randomly generated password to him/her
user = resource.create_user(user_name: first_name + "." + last_name + ".labs")
user.create_login_profile(password: random_password, password_reset_required: true)
# This adds the new user to the Administrators group
client.add_user_to_group({
  group_name: "Administrators", # required
  user_name: user.user_name, # required
})

puts "Here is the user's new login info:"
puts user.user_name
puts random_password
