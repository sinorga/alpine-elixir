FROM sinorga/alpine-erlang:19.3.4-DBG

MAINTAINER Orga Shih <orga.shih@gmail.com>

# Important!  Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like `apt-get update` won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT=2017-08-10 \
    ELIXIR_VERSION=v1.4.5

WORKDIR /tmp/elixir-build

RUN \
    apk add --no-cache --update --virtual .elixir-build \
      make && \
    apk add --no-cache --update \
      git && \
    git clone https://github.com/elixir-lang/elixir && \
    cd elixir && \
    git checkout $ELIXIR_VERSION && \
    make && make install && \
    mix local.hex --force && \
    mix local.rebar --force && \
    cd $HOME && \
    rm -rf /tmp/elixir-build && \
    apk del .elixir-build

WORKDIR ${HOME}

CMD ["/bin/sh"]
