# dude
iotbuddy.dev app backend


## Run image from CI
```sh
docker load -i iotbuddy-dev-dude.tar
docker run -d --rm -p 8080:8080 iotbuddy-dev/dude
```