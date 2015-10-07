# Base image for Docker with the Steam client.
#

FROM		ubuntu:15.10
MAINTAINER	W. Mark Kubacki <wmark@hurrikane.de>

RUN apt-get -qq update \
 && env DEBIAN_FRONTEND=noninteractive apt-get -y -qq install software-properties-common apt-transport-https \
        less patch nano psmisc runit \
 && add-apt-repository "deb https://s.blitznote.com/debs/ubuntu/amd64/ all/" \
 && printf 'Package: *\nPin: origin "s.blitznote.com"\nPin-Priority: 510\n' > /etc/apt/preferences.d/prefer-blitznote \
 && apt-get -qq update \
 && apt-get install -y --force-yes curl ca-certificates \
 && apt-get install -y lib32stdc++6 \
 && printf "\tif [[ \${EUID} == 0 ]] ; then\n\t\tPS1='\\[\\\\033[01;31m\\]\\h\\[\\\\033[01;96m\\] \\W \\$\\[\\\\033[00m\\] '\n\telse\n\t\tPS1='\\[\\\\033[01;32m\\]\\u@\\h\\[\\\\033[01;96m\\] \\w \\$\\[\\\\033[00m\\] '\n\tfi\n" >> /etc/bash.bashrc \
 && sed -i -e "/color_prompt.*then/,/fi/{N;d}" /root/.bashrc \
 && printf 'alias dir="ls -alh --color"\n' >> /etc/bash.bashrc \
 && apt-get -y remove software-properties-common apt-transport-https && apt-get -y autoremove \
 && ( yes 'Yes, do as I say!' | apt-get autoremove --purge libicu. systemd isc-dhcp-c. libcurl3-gnutls python. udev e2fs. .krb. .ldap. .devmapper. ) \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /opt/steam /var/lib/steam \
 && adduser --disabled-password --no-create-home --gecos 'Steam Client' --home /opt/steam steam \
 && curl --silent --show-error --fail --location --header "Accept: application/gzip, application/octet-stream" -o - \
        https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    | tar --no-same-owner -xzf - -C /opt/steam/ \
 && chown -R steam:steam /opt/steam /var/lib/steam \
 && chmod 0755 /opt/steam/linux32/steamcmd

USER steam
WORKDIR /var/lib/steam
VOLUME /opt/steam/Steam/logs

# this bootstraps the Steam client
RUN /opt/steam/steamcmd.sh +login anonymous validate +quit

# and this triggers an update
ONBUILD RUN /opt/steam/steamcmd.sh +login anonymous validate +quit

