# Bind-Docker
ICS Bind Container that runs an ICS Bind server which is bootstraped to root domain servers with the following:


* Zone Overrides (highjack a zone)
* Response Policy Zones

I've enjoy tinkering DNS and Docker. This Docker container useful to *see* all the DNS traffic coming from a machine; as well as, a explorering RPZ and domain highjacking.

# Domain highjacking
You can use this if you want to highjack or blackhole a domain. This basically will make the recurse server act as if it is authoritative for the domain in question. To highjack a domain we simply define a db.ovveride zone as follows:

```
$TTL 60
       IN      SOA     localhost. root.localhost. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL
;
@       IN      NS      localhost.
        IN      A       127.123.45.67
*       IN      A       127.123.45.67
                                            
```

We can resuse this zone to override/blackhole any domain. For example, we can pretend to be authoritative fo wanker.net by simply adding the four lines below to the named.conf:

```
zone "wanker.net" {
        type master;
        file "/etc/bind/db.override";
};
```

# Response Policy Zone
You can use an RPZ if you want to serve an alternate response for a specific this DNS record and could be used for a split horizon - think of hitting an external FQDN using an internal RFC-1918 address. The db.rpz configuration file that implements this is a follows:

```
$TTL 60
@            IN    SOA  localhost. root.localhost.  (
                          20171030     ; serial
                          30m           ; refresh
                          15          ; retry
                          1w           ; expiry
                          30m)         ; minimum
                   IN     NS    localhost.

localhost       A   127.0.0.1

www.some-website.com            A 127.123.45.67
www.other-website.com           CNAME fake-hostname.com.
foo.google.com                  CNAME www.google.com.                                                 
```

# Running

Assume that you have Docker configured you can build and run this as follows:

## Build

```
build -t bind9 .
```

## Running *nix or Windows:

```
docker run --rm -it -v ${PWD}/config:/etc/bind:ro --name=bind9 -p 53:53 -p 53:53/UDP bind9
```
