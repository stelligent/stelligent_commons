# Turn on matrix based authentication

jenkins_script 'setup authentication' do
  command <<-EOH.gsub(/^ {4}/, '')
    import hudson.model.Hudson;
    import hudson.security.GlobalMatrixAuthorizationStrategy;
    import hudson.security.HudsonPrivateSecurityRealm;

    if(args.length != 3) {
      println("no user specified, creating default");
      user = "admin"
      password = "dev"
      role = Hudson.ADMINISTER
    } else {
      user = args[0];
      password = args[1];

      if (args[2] == "read") {
        role = Hudson.READ
      } else if (args[2] == "admin") {
        role = Hudson.ADMINISTER
      } else {
        println "${role} is an invalid role, defaulting to read-only."
        role = Hudson.READ
      }
    } 

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
  EOH
end

