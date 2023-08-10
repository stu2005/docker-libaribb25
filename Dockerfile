# download bcas
FROM stu2005/build-essential AS build-essential 


# build libaribb25
FROM alpine:latest AS build
WORKDIR /src/
COPY --from=build-essential /build/ /

RUN set -x \
&&  mkdir /build/ \
&&  apk add --no-cache --update-cache alpine-sdk git cmake pcsc-lite pcsc-lite-libs pcsc-lite-dev pkgconfig \
&&  git clone https://github.com/tsukumijima/libaribb25 . \
&&  cmake -DWITH_PCSC_LIBRARY=pcsckai -DCMAKE_INSTALL_PREFIX="/build/usr/local" -B build \
&&  cd build \
&&  make -j$(nproc) \
&&  make install

WORKDIR /build/


# final image
FROM alpine:latest
WORKDIR /build/
COPY --from=build /build/ /build/
COPY --from=build-essential /build/ /
COPY init /
RUN chmod +x /init \
&&  apk add --no-cache --update-cache pcsc-lite pcsc-lite-libs ccid socat
ENTRYPOINT ["/bin/ash"]
CMD ["/init"]
