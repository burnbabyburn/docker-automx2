FROM python:3.11.1-alpine
LABEL maintainer="andif888"

# upgrade pip
RUN pip install --upgrade pip

# get curl for healthchecks
RUN apk add bash curl build-base gcc

# permissions and nonroot user for tightened security
RUN adduser -D nonroot
RUN mkdir -p /srv/web/automua && chown -R nonroot:nonroot /srv/web/automua
WORKDIR /srv/web/automua
USER nonroot

# copy all the files to the container
COPY --chown=nonroot:nonroot ./scripts/. /srv/web/automua/.

# venv
ENV VIRTUAL_ENV=/srv/web/automua/venv

# python setup
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install automua

# define the port number the container should expose
EXPOSE 4243

ENTRYPOINT [ "/srv/web/automua/entrypoint.sh" ]
