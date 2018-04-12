FROM systemd-base
RUN yum -y groupinstall "GNOME Desktop"
RUN yum -y install epel-release && yum -y install xrdp tigervnc-server && yum -y update
RUN systemctl enable xrdp.service
RUN useradd red && echo red | passwd red --stdin
RUN yum -y update
# Disable and mask plymouth-halt service because of shutdown hang.
# This is a stupid hack to stop the systemd-shutdown from running so that the container can shutdown.
RUN systemctl disable plymouth-halt && \
    systemctl mask plymouth-halt && \
    systemctl mask rtkit-daemon.service && \
    cp /bin/echo /usr/lib/systemd/systemd-shutdown
CMD ["/usr/sbin/init"]
