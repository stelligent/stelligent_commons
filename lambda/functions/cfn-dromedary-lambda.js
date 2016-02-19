// You must pass in the following as parameters to this function BaseTemplateURL, TemplateURL, KeyName, Branch, GitHubToken and ProdHostedZone
var AWS = require('aws-sdk');
console.log('Loading function');
exports.handler = function(event, context) {
  var uuid = new Date().getTime();
  var stackNamePrefix = 'dromedary-';
  var myStackName = stackNamePrefix += uuid;
  console.log('myStackName =', myStackName);
  var cloudformation = new AWS.CloudFormation();
  var params = {
    StackName: myStackName,
    Capabilities: ['CAPABILITY_IAM'],
    TemplateURL: event.TemplateURL,
    DisableRollback: true,
    Parameters: [
      {
        ParameterKey: 'KeyName',
        ParameterValue: event.KeyName,
        UsePreviousValue: false
      },
      {
        ParameterKey: 'Branch',
        ParameterValue: event.Branch,
        UsePreviousValue: false
      },
      {
        ParameterKey: 'BaseTemplateURL',
        ParameterValue: event.BaseTemplateURL,
        UsePreviousValue: false
      },
      {
        ParameterKey: 'GitHubToken',
        ParameterValue: event.GitHubToken,
        UsePreviousValue: false
      },
      {
        ParameterKey: 'DDBTableName',
        ParameterValue: myStackName,
        UsePreviousValue: false
      },
      {
        ParameterKey: 'ProdHostedZone',
        ParameterValue: event.ProdHostedZone,
        UsePreviousValue: false
      }
    ],
    TimeoutInMinutes: 60
  };
  cloudformation.createStack(params, function(err, data) {
    if (err) console.log(err, err.stack); // an error occurred
    else console.log(data); // successful response
    context.succeed("Finished");
  });
};