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

##### view heroku logs
```
heroku logs -n 1500
```

##### other
* prod mongo url hosted on mongolab
* server running on heroku
* pinging every 5 minutes from statuscake.com
* concert keywords can be changed in database concerts collection without needing server reset

##### required env vars
* MONGO_URL
* ANTS_USER
* ANTS_PASSWORD
* PUSHOVER_USER
* PUSHOVER_TOKEN

##### the best part... 
###### when all tests pass... you get a plane landing safely animation
```
  ------------------------------------------
  ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅✈
  ------------------------------------------
```

