# install

```sh
./install.sh
```

# logs

```sh
tail led.log -f
tail peripheral.log -f
```

# prod

Makes it so that the peripheral will start on boot.

```sh
./one_time_setup.sh
```

# dev

## start

```ssh
./start_all.sh
```

## stop

```ssh
./kill_all.sh
```
