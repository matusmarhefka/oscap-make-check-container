FROM fedora:26

COPY distcheck.sh /root/distcheck.sh
RUN chmod +x /root/distcheck.sh; \
	dnf install -y dbus-devel GConf2-devel libacl-devel \
	libblkid-devel libcap-devel libcurl-devel libgcrypt-devel \
	libselinux-devel libxml2-devel libxslt-devel make openldap-devel \
	pcre-devel perl-XML-Parser perl-XML-XPath perl-devel python-devel \
	rpm-devel swig bzip2 bzip2-devel sendmail gcc git autoconf automake \
	libtool doxygen git rubygems gawk opendbx-devel python3-devel \
	wget lua which procps-ng initscripts chkconfig vim; \
	gem install asciidoctor; \
	dnf clean all

STOPSIGNAL SIGRTMIN+3

ENV container=docker
CMD [ "/sbin/init" ]
