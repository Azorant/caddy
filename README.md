# azorant/caddy

Docker image that bundles the [Cloudflare](https://github.com/caddy-dns/cloudflare) and [Javex/caddy-fail2ban](https://github.com/Javex/caddy-fail2ban) modules

# Getting Started

1. Setup your Caddyfile to log requests and check banned ips

   > Note: You can use `format transform "{common_log}"` if you're not behind a proxy (eg. Cloudflare)

   ```caddyfile
   (f2b) {
           log {
                   output file /data/f2b/output.log
                   format transform `{request>headers>X-Forwarded-For>[0]:request>remote_ip} - {user_id} [{ts}] "{request>method} {request>uri} {request>proto}" {status} {size}` {
                           time_format "02/Jan/2006:15:04:05 -0700"
                   }
           }
           @banned {
                   fail2ban /data/f2b/banned-ips
           }
           handle @banned {
                   abort
           }
   }

   (cf) {
           tls your@email {
                   dns cloudflare {env.CF_API_TOKEN}
           }
   }

   my.domain {
           import f2b
           import cf
     ...
   }
   ```

2. Copy all the relevant [fail2ban files](f2b) and update if need (eg. log file path)

3. Create

   ```yaml
   version: '3'
   services:
     caddy:
       container_name: caddy
       image: ghcr.io/azorant/caddy
       environment:
         - CF_API_TOKEN=cloudflare token
       volumes:
         - path/to/Caddyfile:/etc/caddy/Caddyfile
         - path/to/data:/data
         - path/to/config:/config
       network_mode: 'host'
       restart: unless-stopped
   ```
