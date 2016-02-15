/* Original Source from Fuller, Matthew (2016-01-11). 
AWS Lambda: A Guide to Serverless Microservices.
*/
var async = require('async');
var AWS = require('aws-sdk');
var ec2 = new AWS.EC2();
var REQ_TAG_KEY = 'Name';

exports.handler = function(event, context) {
  ec2.describeInstances({}, function(diErr, diData) {
    if (diErr) return context.fail(diErr);
    if (!diData || !diData.Reservations || !diData.Reservations.length) {
      return context.succeed('No instances found');
    }
    var instsToTerm = [];
    async.each(diData.Reservations, function(rsvtn, nxtRsvtn) {
      async.each(rsvtn.Instances, function(inst, nxtInst) {
        var found = false;
        for (i in inst.Tags) {
          if (inst.Tags[i].Key === REQ_TAG_KEY) {
            console.log(" Tag Key is: " + inst.Tags[i].Key);
            console.log(" Tag Value is: " + inst.Tags[i].Value);
            found = true;
            if (inst.Tags[i].Value.trim() === "") {
              console.log(" The value is blank! TERMINATE!");
              found = false;
            }
            break;
          }
        }
        if (!found) instsToTerm.push(inst.InstanceId);
        nxtInst();
      }, function() {
        nxtRsvtn();
      });
    }, function() {
      if (!instsToTerm.length) {
        return context.succeed('No terminations');
      }
      ec2.terminateInstances({
        InstanceIds: instsToTerm
      }, function(terminateErr, terminateData) {
        if (terminateErr) return context.fail(terminateErr);
        context.succeed('Terminated the following ' + 'instances:\n' + instsToTerm.join('\n'));
      });
    });
  });
}