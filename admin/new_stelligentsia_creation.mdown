# New Stelligentsia User Creation Process

This README will explain how to invite a new member to the Stelligent GitHub organization and also how to to create that person's new IAM user in the Stelligent labs account. Instead of the traditional manual process of on-boarding a new member, I have created two ruby scripts that will:

1. Automatically create a new IAM user in the Stelligent labs account and add him to the Administrators group.
2. Invite the memeber to the Stelligent GitHub organization account.

In order to be able to run these scripts properly you must first download the following Ruby Gems inside your local terminal:

1. AWS Ruby SDK (https://aws.amazon.com/sdk-for-ruby/)

```
gem install aws-sdk
```

2. Download Ruby 2.4.0 (https://www.ruby-lang.org/en/downloads/)

3. Download Octokit Ruby gem

```
gem install octokit -v 4.3.0
```

After these ruby gems have been installd then you can begin to run the scripts. The first ruby script that you will use is the IAM user creation script. When you run **create_iam_user.rb** inside your local terminal, it will prompt you to:

1. Enter the user's first name
2. Enter the user's last name

After Entering this information the  script will automatically create the user name for them and generate a random password that will be used as his/her first login as he/she will be required to change their password afterwards. At the end of the script you will see an output of the new person's username and the random password. This information will then need to be emailed to the new memeber of Stelligent.

The next ruby script to run will be the one that automatically invites the new person's Github account to the Stelligent organization Github account. When you run the **invite_github_member.rb** script inside your local terminal it will prompt you to enter the following:

1. Your Github OAUTH token
2. The Github username of the new person who is being added to Stelligent

After entering in the above information, the new member will automatically be invited to the Stelligent Team as part of the Stelligent organization account.