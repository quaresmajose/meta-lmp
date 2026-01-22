SUMMARY = "LAVA dispatcher host tools"

require lava.inc

SRC_URI[sha256sum] = "ddb86e60174e3acb86a612aea523c0a0d40f317badf90ef1e4c8bdf9e944489b"

inherit systemd

# lava-docker-worker.service is also available
SYSTEMD_SERVICE:${PN} = "lava-dispatcher-host.service"

FILES:${PN} += "${localstatedir}/volatile"
INSANE_SKIP:${PN} += "empty-dirs"

RDEPENDS:${PN} += " \
    lava-common \
    python3-jinja2 \
    python3-pyudev \
    python3-requests \
"

do_install:append(){
    cat <<'EOF'>>${D}${systemd_system_unitdir}/lava-dispatcher-host.service
ExecStartPre=/usr/bin/lava-dispatcher-host rules install
ExecStartPre=/usr/bin/udevadm control --reload-rules

[Install]
WantedBy=multi-user.target
EOF
}
