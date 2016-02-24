# SoftEther VPN server
FROM babim/debianbase

ENV VERSION v4.19-9599-beta-2015.10.19
WORKDIR /usr/local/vpnserver

RUN apt-get update &&\
        apt-get -y -q install gcc make wget && \
        apt-get clean && \
        rm -rf /var/cache/apt/* /var/lib/apt/lists/* && \
        wget http://www.softether-download.com/files/softether/${VERSION}-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-${VERSION}-linux-x64-64bit.tar.gz -O /tmp/softether-vpnserver.tar.gz &&\
        tar -xzvf /tmp/softether-vpnserver.tar.gz -C /usr/local/ &&\
        rm /tmp/softether-vpnserver.tar.gz &&\
        make i_read_and_agree_the_license_agreement &&\
        apt-get purge -y -q --auto-remove gcc make wget

RUN mkdir -p /var/log/vpnserver /vpn /etc-start/logvpn && ln -s /etc-start/logvpn /var/log/vpnserver
RUN cp /usr/local/vpnserver/vpn_server.config /etc-start && cp /etc-start/vpn_server.config /vpn && \ 
        rm -f /usr/local/vpnserver/vpn_server.config && ln -s /vpn/vpn_server.config /usr/local/vpnserver/vpn_server.config

ADD runner.sh /usr/local/vpnserver/runner.sh
RUN chmod 755 /usr/local/vpnserver/runner.sh

VOLUME /vpn
EXPOSE 443/tcp 992/tcp 1194/tcp 1194/udp 5555/tcp 500/udp 4500/udp

ENTRYPOINT ["/usr/local/vpnserver/runner.sh"]
