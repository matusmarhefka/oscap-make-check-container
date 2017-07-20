FROM fedora

COPY test.sh /root/test.sh
RUN chmod +x /root/test.sh; dnf group install -y "Fedora Server Edition"; \
	dnf install -y lua dbus-devel GConf2-devel libacl-devel \
	libblkid-devel libcap-devel libcurl-devel libgcrypt-devel \
	libselinux-devel libxml2-devel libxslt-devel make openldap-devel \
	pcre-devel perl-XML-Parser perl-XML-XPath perl-devel python-devel \
	rpm-devel swig bzip2 bzip2-devel gcc git autoconf automake libtool \
	doxygen git rubygems gawk fedpkg opendbx-devel python3-devel vim; \
	dnf clean all

STOPSIGNAL SIGRTMIN+3

ENV container=docker
CMD [ "/sbin/init" ]
