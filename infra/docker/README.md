### .env file sample

```console
URL=you.url.com
```

### .ovhapi file sample

```console
dns_ovh_endpoint = ovh-eu
dns_ovh_application_key  = 
dns_ovh_application_secret  = 
dns_ovh_consumer_key  = 
```

# How to run

Make sure to generate a certificate before running Jenkins

```console
./certbot.sh
````

Then, run the following command

```console
docker compose up -d
```

# Create crontab for SSL cert renew

Create the following cron as root user

```console
0 0 * * * <path/to/certbos.sh> >/dev/null 2>&1
```