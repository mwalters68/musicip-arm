FROM ubuntu:20.04 as box86
USER root
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /root

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get -y install build-essential python3 cmake git 
RUN git clone https://github.com/ptitSeb/box86 && \
  mkdir box86/build && \
  cd box86/build && \
  cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo && \
  make -j$(nproc)

FROM ubuntu:20.04

# Copy and extract MusicIP archive
ADD MusicMixer_x86_1.8.tgz /opt
COPY --from=box86 /root/box86/build/box86 /opt/MusicIP

# Replace default index page with Spicefly's index page (spicefly.com)
COPY index.html /opt/MusicIP/MusicMagicMixer/server/index.html

# Edit mmm.ini file.
# - Disable TIVO
# - Indicate that the DB will be located in the /config volume. This is
#   required for persistence, otherwise music has to be scanned again
#   when restarting
RUN sed -i -e 's/tivo=1/tivo=0/' -e 's_cache=.*_cache=/config/default.m3lib_' /opt/MusicIP/MusicMagicMixer/mmm.ini

VOLUME /music /config
EXPOSE 10002

COPY entrypoint.sh /entrypoint.sh 
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
