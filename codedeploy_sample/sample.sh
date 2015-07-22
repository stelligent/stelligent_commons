# set up code deploy / pipeline for cloudpatrol

# you'll need to check out the cloudpatrol repo

# create blank instance
aws cloudformation create-stack \
 --stack-name cloudpatrol-`date +%Y%m%d%H%M%S` \
 --template-body file://cloudpatrol.json \
 --capabilities CAPABILITY_IAM \
 --parameters \
    ParameterKey=KeyName,ParameterValue=your-ec2-keypair

# create cloud patrol app in code deploy
aws deploy create-application \
 --application-name CloudPatrol

# create a deployment group, you'll need to look up the ARN from the first CFN template
aws deploy create-deployment-group \
 --application-name CloudPatrol \
 --deployment-group-name CloudPatrol  \
 --deployment-config-name CodeDeployDefault.OneAtATime \
 --ec2-tag-filters Key=Name,Value=CloudPatrol,Type=KEY_AND_VALUE \
 --service-role-arn arn:aws:iam::1234567890:role/CodeDeployTrustRoleName

# build the zip and do an initial deployment
git pull --rebase && zip -qr ../cloudpatrol.zip * && aws s3 cp ../cloudpatrol.zip s3://thebuckettouploadto && aws deploy create-deployment --application-name CloudPatrol \
 --deployment-group-name CloudPatrol \
 --description test \
 --s3-location bundleType=zip,bucket=thebuckettouploadto,key=cloudpatrol.zip
