var twilio = require('twilio')('AC4baaee78d7dc45e54adc877abdf31474', '688120eb57f7e2355b88e42f183d0da1');

Parse.Cloud.define("sendVerificationCode", function(request, response) {
  twilio.sendSms({
    From: "+14242383580",
    To: request.params.number,
    Body: "Your verification code is " + request.params.verificationCode + "."
  }, {
    success: function(httpResponse) {
      console.log(httpResponse);
      response.success("SMS sent!");
    },
    error: function(httpResponse) {
      console.error(httpResponse);
      response.error("Oh NOOOOO!");
    }
  });
});
