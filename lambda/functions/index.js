exports.handler = function(event, context) {
  console.log(" Request ID: " + context.awsRequestId);
  console.log(" Log Group Name: " + context.logGroupName);
  console.log(" Log Stream Name: " + context.logStreamName);
  console.log(" Identity: " + context.identity);
  console.log(" Function Name: " + context.functionName);
  context.succeed(" Hello, " + event.username);
};