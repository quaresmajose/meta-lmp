FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# do_install_basefilesissue[vardepsexclude] += "DISTRO_VERSION"

# disable do_install_basefilesissue as it only adds
# DISTRO_VERSION to /etc/issue and /etc/issue.net
# this invalidates the cache and will trigger a rebuild of
# -> initramfs -> kernel -> modules
BASEFILESISSUEINSTALL = ""
