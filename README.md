# ants scraper

##### install

```
npm install
```

##### run server

```
export MONGO_URL=[MONGO_URL HERE];gulp serve
```

##### run tests (while server is running)

```
mocha
```

##### push to heroku

```
git push heroku master  
```

##### test notification

```
GET http://ants-scraper.herokuapp.com/v1/send/test
```

##### view heroku logs

```
heroku logs -n 1500
```

##### other

* prod mongo url hosted on mongolab
* server running on heroku
* runs every 3 minutes
* concert keywords can be changed in database concerts collection without needing server reset

##### required env vars

* MONGO_URL
* ANTS_USER
* ANTS_PASSWORD
* PUSHOVER_USER (ends in R4gq)
* PUSHOVER_TOKEN (ends in vV3y)

##### the best part...

###### when all tests pass... you get a plane landing safely animation

```
  ------------------------------------------
  ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅✈
  ------------------------------------------
```
