FROM ubuntu: 24.04
RUN apt-get update -y \
&& apt-get dist-upgrade -y \
&& apt-get autoremove -y \
&& apt-get autoclean -y \
&& apt-get install -y \
curl \
git
RUN curl -SL https://go.dev/dl/go1.21.7.linux-arm64.tar.gz \
| tar xvz -C /usr/local
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH/src
RUN git clone https://github.com/Theresemskaar/sem3v24.git \
&& cd sem3v24 \
&& go build -o $GOPATH/bin simplest-webserver.go
ENV SERVICE_NAME="simplest-webserver"
RUN addgroup --gid 900 --system $simplest-webserver \
&& adduser --system --ingroup $simplest-webserver --shell /bin/false --uid 900 $simplest-webserver
EXPOSE 8080
USER $simplest-webserver
CMD ["simplest-webserver"]
