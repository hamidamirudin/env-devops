## how to install 
https://docs.gitlab.com/ee/install/docker.html


## how to integrate gitlab with google account 
https://docs.gitlab.com/ee/integration/google.html



## ga perlu edit gitlab.rb pakai di Gitlab.DockerCompose.yml environment

root  
Password:  
demouser|glpat-s6kkDDjSKKT2s1MKSos8
```
gitlab_rails['omniauth_providers'] = [
  {
    name: "google_oauth2",
    # label: "Provider name", # optional label for login button, defaults to "Google"
    app_id: "290931377763-ID.apps.googleusercontent.com",
    app_secret: "GOCSPX-SECRET",
    args: { access_type: "offline", approval_prompt: "" }
  }
]
```



# Troubleshoot Chiper Error 
gitlab-rake gitlab:doctor:secrets VERBOSE=1
readthis ['https://docs.gitlab.com/ee/raketasks/backup_restore.html#when-the-secrets-file-is-lost']