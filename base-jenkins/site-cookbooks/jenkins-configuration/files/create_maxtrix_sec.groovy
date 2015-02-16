import hudson.model.Hudson;
import hudson.security.GlobalMatrixAuthorizationStrategy;
import hudson.security.HudsonPrivateSecurityRealm;

role = null

user = "admin"
password = "dev"
role = Hudson.ADMINISTER

def constructMatrixAuthorizationStrategy(user, role) {
  authzStrategy = new GlobalMatrixAuthorizationStrategy();
  authzStrategy.add(role, user);
  return authzStrategy;
}

def configurePrivateSecurityRealm(user, password) {
  doNotAllowSignup = false;
  hudsonPrivateSecurityRealm = new HudsonPrivateSecurityRealm(doNotAllowSignup);

  hudsonPrivateSecurityRealm.createAccount(user, password)

  Hudson.instance.setSecurityRealm(hudsonPrivateSecurityRealm);
  println "Successfully set security realm to Hudson Private Realm without ability to signup";
}

authzStrategy = Hudson.instance.getAuthorizationStrategy();
if(!authzStrategy.getClass().equals(GlobalMatrixAuthorizationStrategy.class)) {
  matrixAuthzStrategy = constructMatrixAuthorizationStrategy(user, role);
  Hudson.instance.setAuthorizationStrategy(matrixAuthzStrategy);
  
  configurePrivateSecurityRealm(user, password);

  Hudson.instance.save();
}
else {
  //test deeper?
}