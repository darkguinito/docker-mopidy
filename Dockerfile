FROM python:alpine3.12 as BASE



RUN apk add --update --no-cache gcc 
RUN apk add --update gstreamer 
RUN apk add --update py3-gst 
RUN apk add --update python3-dev 
RUN apk add --update cairo 
RUN apk add --update cairo-dev
RUN apk add --update musl-dev 
RUN apk add --update gobject-introspection 
RUN apk add --update gobject-introspection-dev
RUN apk add --update gstreamer-tools 


RUN pip install --no-cache-dir --no-use-pep517 PyGObject
RUN pip install --no-cache-dir \
    mopidy \
    Mopidy-Muse 

RUN mkdir -p /var/lib/mopidy/m3u/playlists
#USER mopidy

RUN apk add --update gst-plugins-good 
RUN apk add --update gst-plugins-ugly 
RUN apk add --update gst-plugins-bad 
ENV SNAPSERVER_HOST=${SNAPSERVER_HOST:-snapserver.local}
ENV SNAPSERVER_PORT=${SNAPSERVER_PORT:-4953}
COPY mopidy.conf     /etc/mopidy/mopidy.conf
CMD ["mopidy", "--config", "/etc/mopidy/mopidy.conf"]
EXPOSE 6680 6600
