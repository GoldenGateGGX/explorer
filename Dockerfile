FROM ubuntu:latest as builder

RUN apt-get update && \
  apt-get install --no-install-recommends -y build-essential curl git gnupg ca-certificates

RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash -

RUN apt-get install --no-install-recommends -y nodejs && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN npm install yarn -g

WORKDIR /ggx
COPY . .

RUN yarn && NODE_ENV=production yarn build:www


FROM scratch AS export
COPY --from=builder /ggx/packages/apps/build/. .
