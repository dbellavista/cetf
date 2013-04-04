CeTF Framework
==============

A framework for the construction of Jeopardize CTF by Anesec (CeSeNA Security).

## FEATURES

1. Login using oauth (google, facebook, twitter).
2. Challenge insertion specifying the solution flag, description and a set of attachments.
3. Captcha on challenge creation.
4. New challenge e-mail notification.

## CONFIGURATION

1. Setup outh services and keys in file *config/oauth.yml*
2. Change the secret token in *config/initializers/secret_token.rb*
3. Set up smtp server in _config/environments/*.rb_
4. Set the recaptcha service key in *config/initializers/recaptcha.rb*
5. Create the folder *public/uploads*
