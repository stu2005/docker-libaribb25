# build libaribb25
FROM alpine:latest AS build
WORKDIR /src/
RUN set -x \
&&  apk add --no-cache --update-cache build-base git cmake ninja pcsc-lite-dev \
&&  git clone https://github.com/tsukumijima/libaribb25 . \
&&  cmake -G Ninja -B build \
&&  cd build \
&&  ninja -j$(nproc) \
&&  ninja install

# final image
FROM alpine:latest
COPY --from=build /usr/local/ /usr/local/
COPY init /
RUN chmod +x /init \
&&  apk add --no-cache --update-cache pcsc-lite pcsc-lite-libs ccid socat libgcc libstdc++
CMD ["/init"]
EXPOSE 40773
EXPOSE 40774
