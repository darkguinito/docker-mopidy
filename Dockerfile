FROM python:alpine3.12 as base

ENV MOPIDY_TPL_CONF_FILEPATH=/etc/mopidy/.mopidy.conf

RUN apk add --update --no-cache \
      gcc \
      gstreamer \
      py3-gst \
      python3-dev \
      cairo \
      cairo-dev \
      musl-dev \
      gobject-introspection \
      gobject-introspection-dev \
      gstreamer-tools \
      gettext

RUN pip install --no-cache-dir --no-use-pep517 PyGObject
RUN pip install --no-cache-dir \
    mopidy \
    Mopidy-Muse

RUN mkdir -p /var/lib/mopidy/m3u/playlists
RUN apk add --update \
    gst-plugins-good \
    gst-plugins-ugly \
    gst-plugins-bad

COPY entrypoint.sh   /entrypoint.sh
COPY mopidy.conf     $MOPIDY_TPL_CONF_FILEPATH

# USER
RUN addgroup -g 101 -S mopidy && adduser -u 100 -S mopidy -G mopidy
RUN mkdir /var/cache/mopidy
RUN chown -R mopidy:mopidy /etc/mopidy /var/cache/mopidy /var/lib/mopidy

ENV SNAPSERVER_HOST=localhost
ENV SNAPSERVER_PORT=4953
ENV VOLUME_PERCENTAGE=50
ENV DEFAULT_ROOT_PATH=muse
ENV MEDIA_DIRS=/

EXPOSE 6680 6600
ENTRYPOINT ["/entrypoint.sh"]
CMD ["mopidy", "--config", "/etc/mopidy/mopidy.conf"]

#------------------------
# Mopidy with user
#------------------------
FROM base as mopidy_with_user

USER mopidy
#------------------------
# Mopidy with Muse
#------------------------
FROM base as mopidy_n_muse

RUN pip install --no-cache-dir \
    Mopidy-Muse

COPY muse.ext /tmp/muse.ext
RUN cat /tmp/muse.ext >> $MOPIDY_TPL_CONF_FILEPATH

ENV MOPIDY_HOST=localhost
ENV MOPIDY_PORT=1780
ENV MOPIDY_SSL=false

ENV SNAPSCAST_HOST=localhost
ENV SNAPCAST_PORT=1780
ENV SNAPCAST_SSL=false

USER mopidy
