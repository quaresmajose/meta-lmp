FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:versal = " \
	file://plat-versal-support-raw-bin.patch \
"

# Align provides with meta-arm
PROVIDES += "virtual/trusted-firmware-a"

# Enable opteed as the main SPD provider (required for optee)
EXTRA_OEMAKE:append:zynqmp = " SPD=opteed"
EXTRA_OEMAKE:append:versal = " SPD=opteed"
ATF_CONSOLE:kv260 = "cadence1"

# Remove TF_LDFLAGS workaround
# aarch64-lmp-linux-ld.bfd: unrecognized option '--no-warn-rwx-segments'
EXTRA_OEMAKE:remove = ' TF_LDFLAGS="--no-warn-rwx-segments --fatal-warnings -O1 --gc-sections"'
