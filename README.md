a bunch of twitter stuff
========

this script takes tweets from a given search, modifies them and then tweets the modification

currently can reverse text or makes tweets go french using microsoft translation api

use these config lines to set up heroku, requires a postgres db


heroku config:add YOUR_CONSUMER_KEY= YOUR_CONSUMER_SECRET= YOUR_OAUTH_TOKEN= YOUR_OAUTH_TOKEN_SECRET= 

heroku config:add DB_HOST= DB_NAME= DB_USER= DB_PW=

heroku config:add TWITTERHANDLE=

heroku config:add MTCLIENTID= MTCLIENTSECRET=
