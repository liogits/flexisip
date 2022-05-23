###############################################################################
# Dockerfile used to make bc-dev-centos7:20220112_add_libasan
###############################################################################

FROM gitlab.linphone.org:4567/bc/public/linphone-sdk/bc-dev-centos7:20210421_python3_fix_pip

MAINTAINER François Grisez <francois.grisez@belledonne-communications.com>

# Install extra Flexisip dependencies
RUN sudo su -c 'yum -y install jansson-devel libnghttp2-devel net-snmp-devel protobuf-devel devtoolset-8-libasan-devel devtoolset-8-libubsan-devel && yum -y clean all'

ENTRYPOINT "flexisip-entrypoint.sh"

CMD "flexisip"