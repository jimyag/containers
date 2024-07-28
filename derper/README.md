# derper

**required: set env `HOSTNAME` to your domain**

quick start example:

```bash
docker run -e HOSTNAME=derper.your-domain.com -p 80:80 -p 443:443 -p 3478:3478/udp ghcr.io/jimyag/derper:latest
```

verify clients example:

```bash
docker run -e HOSTNAME=derper.your-domain.com -e VERIFY_CLIENTS=true -p 80:80 -p 443:443 -p 3478:3478/udp -v /var/run/tailscale/tailscaled.sock:/var/run/tailscale/tailscaled.sock ghcr.io/jimyag/derper:latest
```

official setup documentation: <https://tailscale.com/kb/1118/custom-derp-servers/>
