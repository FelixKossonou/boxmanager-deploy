FROM alpine:latest

RUN apk add --no-cache unzip wget ca-certificates curl

WORKDIR /pb

RUN wget https://github.com/pocketbase/pocketbase/releases/download/v0.22.21/pocketbase_0.22.21_linux_amd64.zip \
    && unzip pocketbase_0.22.21_linux_amd64.zip \
    && rm pocketbase_0.22.21_linux_amd64.zip \
    && chmod +x pocketbase

COPY start.sh /pb/start.sh
RUN chmod +x /pb/start.sh

EXPOSE 8090
CMD ["/pb/start.sh"]
