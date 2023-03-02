# Sonarqube 



## OpenId Connect to KeyCloak - INSTALATION
1. Install the plugin OpenID Connect (OIDC) Plugin for SonarQube from marketplace via "Administration > Marketplace". Or download the plugin jar from GitHub Releases and put it into the SONARQUBE_HOME/extensions/plugins/ directory
2. Makesure env config sonar.core.serverBaseUrl on docker-compose is set 
   ```
      SONAR_CORE_SERVERBASEURL: https://sonarqube.clientsolve.com
      ```
3. Restart the SonarQube server


## OpenId Connect to KeyCloak - CONFIGURATION on KEYCLOAK
Please refer to https://github.com/vaulttec/sonar-auth-oidc
<br/> Note : To Use OpenId Sonarqube needs to be SSL. 
<br/> 
set sonar.core.serverBaseUrl to https, example on docker-compose: 
```
environment: 
    SONAR_CORE_SERVERBASEURL: https://sonarqube.clientsolve.com
```

1. Create a client with access type 'public' or 'confidential' (in the latter case the corresponding client secret must be set in the plugin configuration) and white-list the redirect URI for the SonarQube server https://<sonarqube base>/oauth2/callback/oidc
2. ~~For synchronizing SonarQube groups create a mapper which adds group names to a custom userinfo claim in the ID token (the claim's name is used in the plugin configuration later on)~~
3. We will use CustomMapper from ClientRoles to Group on token 

## OpenId Connect to Keycloak - CONFIGURATION on Sonarqube
1. Go to SonarQube administration (General > Security > OpenID Connect)
2. set Enabled true and save 
3. set issuer URI and save 
4. set ClientID and save 
5. set ClientSecret and save 
6. try logut and re login 
<br/>
Note: sonar uses SSO so changing user is quite difficult once you logged in.



## To upgrade SonarQube using the Docker image:

1. Stop and remove the existing SonarQube container (a restart from the UI is not enough as the environment variables are only evaluated during the first run, not during a restart):
``` 
$ docker pull sonarqube:community
$ docker stop <container_id>
$ docker rm <container_id>

```
2. Run docker:
```
DOCKER_HOST="ssh://root@149.28.133.89" docker-compose -f Sonarqube.DockerCompose.yml up -d 
```
 
3. Go to https://sonarqube.clientsolve.com/setup and follow the setup instructions.

4. Reanalyze your projects to get fresh data.