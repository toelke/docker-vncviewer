FROM debian:bookworm-20250929 AS downloader

RUN apt update && apt install -y xtightvncviewer
RUN mkdir /libs; ldd /usr/bin/vncviewer | grep '=>' | awk '{ print $3; }' | xargs -I_ -n 1 cp _ /libs
RUN mkdir /libs; ldd /bin/bash | grep '=>' | awk '{ print $3; }' | xargs -I_ -n 1 cp _ /libs

FROM gcr.io/distroless/base-debian12
COPY --from=downloader /bin/bash /bin
COPY --from=downloader /usr/bin/vncviewer /usr/bin
COPY --from=downloader /libs/* /usr/lib/
ENTRYPOINT ["/usr/bin/vncviewer"]
