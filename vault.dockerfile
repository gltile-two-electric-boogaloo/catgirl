FROM alpine:3.16.0

RUN apk add --update --no-cache unzip

ADD "https://github.com/bloominlabs/vault-plugin-secrets-tailscale/releases/download/v0.1.4/vault-plugin-secrets-tailscale_0.1.4_Linux_x86_64.tar.gz" /root/plugins
ADD "https://releases.hashicorp.com/vault/1.11.0/vault_1.11.0_linux_amd64.zip" /root/vault.zip

WORKDIR /root
RUN unzip vault.zip \
    && rm vault.zip

ENTRYPOINT [ "./vault", "server", "-config", "/root/vault.hcl" ]