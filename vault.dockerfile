FROM alpine:3.16.0

RUN apk add --update --no-cache vault libcap

ADD "https://github.com/bloominlabs/vault-plugin-secrets-tailscale/releases/download/v0.1.4/vault-plugin-secrets-tailscale_0.1.4_Linux_x86_64.tar.gz" /root/plugins
ADD vault.hcl /root/vault.hcl

RUN setcap -r /usr/sbin/vault
ENTRYPOINT [ "sh", "-c", "vault server -config /root/vault.hcl" ]