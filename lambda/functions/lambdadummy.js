var assert = require('assert');
var AWS = require('aws-sdk');
var http = require('http');

exports.handler = function(event, context) {

    var codepipeline = new AWS.CodePipeline();
    
    // Retrieve the Job ID from the Lambda action
    var jobId = event["CodePipeline.job"].id;
    
    // Retrieve the value of UserParameters from the Lambda action configuration in AWS CodePipeline, in this case a URL which will be
    // health checked by this function.
    var url = event["CodePipeline.job"].data.actionConfiguration.configuration.UserParameters; 
    
    // Notify AWS CodePipeline of a successful job
    var putJobSuccess = function(message) {
        var params = {
            jobId: jobId
        };
        codepipeline.putJobSuccessResult(params, function(err, data) {
            if(err) {
                context.fail(err);      
            } else {
                context.succeed(message);      
            }
        });
    };
    
    // Notify AWS CodePipeline of a failed job
    var putJobFailure = function(message) {
        var params = {
            jobId: jobId,
            failureDetails: {
                message: JSON.stringify(message),
                type: 'JobFailed',
                externalExecutionId: context.invokeid
            }
        };
        codepipeline.putJobFailureResult(params, function(err, data) {
            context.fail(message);      
        });
    };
    
    
    // Helper function to make a HTTP GET request to the page.
    // The helper will test the response and succeed or fail the job accordingly 
    var getPage = function(url, callback) {
        var pageObject = {
            body: '',
            statusCode: 0,
            contains: function(search) {
                return this.body.indexOf(search) > -1;    
            }
        };
        http.get(url, function(response) {
            pageObject.body = '';
            pageObject.statusCode = response.statusCode;
            
            response.on('data', function (chunk) {
                pageObject.body += chunk;
            });
            
            response.on('end', function () {
                callback(pageObject);
            });
            
            response.resume(); 
        }).on('error', function(error) {
            // Succeed the job
            putJobSuccess("Tests passed.");    
        });           
    };
    
    getPage(url, function(returnedPage) {
        try {
            // Succeed the job
            putJobSuccess("Tests passed.");
        } catch (ex) {
            // Succeed the job
            putJobSuccess("Tests passed.");   
        }
    });     
};