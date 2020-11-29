# Notes for myself

## setting

```sh
dc exec app sh
```

```sh
cd site_update_monitoring/
```

```sh
bundle
```

## set crontab

```sh
02 9,12,15,18,21 * * * cd bzoh/app/site_update_monitoring && ruby check_html.rb >> /home/pi/bzoh/app/site_update_monitoring/check.log
```

```sh
sudo /etc/init.d/cron restart
```


