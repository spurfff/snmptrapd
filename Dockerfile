FROM fedora

# Create some environment variables
ENV HOME="/root"
ENV MIBS="${HOME}/.snmp/mibs"
ENV SNMP_CONF_FILE="/etc/snmp/snmptrapd.conf"
ENV SNMP_LOG_DIR="/var/log/snmptrapd"
ENV SNMP_LOG_FILE="/var/log/snmptrapd/snmptrapd.log"
ENV SYSLOG_CONF_DIR="/etc/syslog-ng"
ENV SYSLOG_CONF_FILE="${SYSLOG_CONF_DIR}/syslog-ng.conf"
ENV TZ="/usr/share/zoneinfo/America/Los_Angeles"

# Update and install necessary files
RUN dnf makecache && dnf install -y \
	vim \
	syslog-ng \
	net-snmp \
	net-snmp-utils \
	procps \
	&& rm -rf /var/cache/dnf/*

# Backup the OG snmptrapd.conf file & copy over the custom file
RUN cp ${SNMP_CONF_FILE} ${SNMP_CONF_FILE}.bak
COPY snmptrapd.conf ${SNMP_CONF_FILE}

# Create the main directory for storing MIB files
RUN mkdir -p ${MIBS}

# Setup the log directory for the snmptrapd service;; in this build, we'll be using the syslog functionality
RUN mkdir -p ${SNMP_LOG_DIR} && touch ${SNMP_LOG_FILE}

# Setup syslog logging
RUN cp ${SYSLOG_CONF_FILE} ${SYSLOG_CONF_FILE}.bak
COPY syslog-ng.conf ${SYSLOG_CONF_FILE}

# Some basic MIB files for monitoring Windows 11 hosts
COPY HOST-RESOURCES-MIB.txt ${MIBS}
COPY HOST-RESOURCES-TYPES.txt ${MIBS}

# Set the timezone
RUN ln -sf ${TZ} /etc/localtime

WORKDIR ${HOME}

CMD ["sh", "-c", "snmptrapd -d -Lf /var/log/snmptrapd/snmptrapd.log -m +HOST-RESOURCES-MIB && tail -f /dev/null"]
