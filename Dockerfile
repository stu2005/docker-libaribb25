# build libaribb25
FROM alpine:latest AS build
WORKDIR /src/

RUN set -x \
&&  apk add --no-cache --update-cache alpine-sdk git cmake pcsc-lite pcsc-lite-libs pcsc-lite-dev pkgconfig \
&&  git clone https://github.com/tsukumijima/libaribb25 . \
&&  cmake -B build \
&&  cd build \
&&  make -j$(nproc) \
&&  make install

WORKDIR /build/


# final image
FROM alpine:latest
WORKDIR /build/
COPY --from=build /usr/local/ /usr/local/
COPY init /
RUN chmod +x /init \
&&  apk add --no-cache --update-cache pcsc-lite pcsc-lite-libs ccid socat libgcc libstdc++
ENTRYPOINT ["/bin/ash"]
CMD ["/init"]
EXPOSE 40773
EXPOSE 40774
