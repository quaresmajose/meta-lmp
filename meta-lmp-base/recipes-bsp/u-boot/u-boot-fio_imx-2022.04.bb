require u-boot-fio-common.inc

SRCREV = "605d0aa5c016915058c7b19051f76d592e103b32"
SRCBRANCH = "2022.04+lf-6.1.1-1.0.0-fio"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=5a7450c57ffe5ae63fd732446b988025"

DEFAULT_PREFERENCE = "-1"

# Environment config is not required for mfgtool
#SRC_URI:remove:lmp-mfgtool = "file://fw_env.config"
