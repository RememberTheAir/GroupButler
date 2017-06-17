FROM openresty/openresty:alpine-fat

WORKDIR /srv/app

RUN mkdir logs

RUN apk add --no-cache bash && mv /bin/sh /bin/sh.bak && ln -s /bin/bash /bin/sh

ARG ROCKS="serpent i18n luatz"
RUN for ROCK in $ROCKS; do luarocks install $ROCK; done

RUN rm /bin/sh && mv /bin/sh.bak /bin/sh

ARG OPM="pintsized/lua-resty-http leafo/pgmoon"
RUN opm install $OPM

RUN apk add --no-cache tzdata

ENTRYPOINT nginx -g 'daemon off;' -p `pwd` -c conf/"$ENV".conf

COPY lua lua
COPY conf conf
COPY i18n i18n
