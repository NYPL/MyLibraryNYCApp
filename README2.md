I installed the Figaro gem to hide Sendgrid credentials on Github. Running
```
bundle
```
then

```
figaro install
```
generates an application.yml file to place the Sendgrid username and password retrieved earlier with the heroku config command. (I created application.example.yml to show what needs to be placed locally in application.yml)

Since this app was created with an older version of rails, a secret token was generated in config/initializers/secret_token.rb.

Thus, I ran

```
rake secret
```
to generate a new token and updated application.yml with the new token as well.

After following these steps, I was able to get Sendgrid running in a dev environment, as well as use the dashboard on the Sendgrid site to con rm which emails went out. Please let me know if you need anything!

- Esther
