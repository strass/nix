https://smallstep.com/blog/build-a-tiny-ca-with-raspberry-pi-yubikey/

- Generate certificates with `STEPPATH=/mnt/ca step ca init --pki --name="strass home" --deployment-type standalone`
- Generate settings with:
```bash
 sudo --preserve-env step ca init --name="Tiny CA" \
    --dns="tinyca.internal,10.20.30.42" --address=":443" \
    --provisioner="you@example.com" \
    --deployment-type standalone \
    --remote-management
```