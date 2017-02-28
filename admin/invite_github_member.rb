require "octokit"

puts "Please enter your OAUTH Token"
access_token = gets.chomp

# This is authenticating to GitHub using the Oauth token
client = Octokit::Client.new(:access_token => access_token)
user = client.user
user.login

puts "Please enter the GitHub username of the person that will be invited to Stelligent"
new_github_user = gets.chomp

# This is the Stelligent team Github team ID
stelligent_team_id = 314396 

client.add_team_member(stelligent_team_id, new_github_user)