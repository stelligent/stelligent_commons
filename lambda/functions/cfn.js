
var AWS = require('aws-sdk');
console.log('Loading function');
exports.handler = function(event, context) {
  var uuid = new Date().getTime();
  var stackNamePrefix = 'PMDLambdaSQS';
  var myStackName = stackNamePrefix += uuid;
  console.log('value1 =', event.key1);
  console.log('myStackName =', myStackName);
  var cloudformation = new AWS.CloudFormation();
  var params = {
    StackName: myStackName,
    TemplateURL: 'https://s3.amazonaws.com/stelligent-training-public/template.json',
    DisableRollback: true,
    TimeoutInMinutes: 10
  };
  cloudformation.createStack(params, function(err, data) {
    if (err) console.log(err, err.stack); // an error occurred
    else console.log(data); // successful response
    context.succeed("Finished");
  });
};