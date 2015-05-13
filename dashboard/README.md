dashing infrastructure
========

creates a blank dashing server, and all the related AWS resources. 

If you have the AWS CLI installed, you can use this command to create a dashing server:

    aws cloudformation create-stack   \
    --stack-name dashing-`date +%Y%m%d%H%M%S`\
    --template-body file://dashing.json \
    --parameters \
      ParameterKey=KeyName,ParameterValue=your-key-name

Where you replace your-key-name with the EC2 Keypair name you'd like to use.

gotchas
========

* the cloudformation template creates a Route 53 entry, so it will fail if another instance of the template 
