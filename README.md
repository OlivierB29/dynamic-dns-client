# dynamic-dns-client
dynamic dns client examples for IPv6

# duckdns
- Download scripts into ~/duckdns
- Edit duck.sh
- Modify crontab
```
# At minute 0 every 4 hours
0 */4 * * * ~/duckdns/duck.sh >/dev/null 2>&1
```

Each DNS service has an update policy.

- Sample log output
```
2023-08-12T00:00:01+02:00 https://www.duckdns.org/update?domains=mydomain.duckdns.org&token=00000000-0000-0000-0000-000000000000&ipv6=0000:0000:0000:0000:0000:0000:0000:0000 OK
2023-08-12T04:00:01+02:00 https://www.duckdns.org/update?domains=mydomain.duckdns.org&token=00000000-0000-0000-0000-000000000000&ipv6=0000:0000:0000:0000:0000:0000:0000:0000 OK
2023-08-12T08:00:01+02:00 https://www.duckdns.org/update?domains=mydomain.duckdns.org&token=00000000-0000-0000-0000-000000000000&ipv6=0000:0000:0000:0000:0000:0000:0000:0000 OK

```