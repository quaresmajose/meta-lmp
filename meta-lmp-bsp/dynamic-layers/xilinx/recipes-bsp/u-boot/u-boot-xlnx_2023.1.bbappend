FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

UBRANCH = "xilinx-v2023.01-rebase"
UBOOTURI = "git://github.com/quaresmajose/u-boot.git;protocol=https"

SRCREV = "${AUTOREV}"

include recipes-bsp/u-boot/u-boot-lmp-common.inc

# zynqmp: add pmu-firmware and fpga bitstream (loading FPGA from SPL) dependancies
do_compile[depends] += "${@bb.utils.contains('SOC_FAMILY', 'zynqmp', 'virtual/pmu-firmware:do_deploy virtual/bitstream:do_deploy', '', d)}"

SRC_URI:append = " \
    file://fw_env.config \
    ${@bb.utils.contains('MACHINE_FEATURES', 'ebbr', 'file://lmp-ebbr.cfg', 'file://lmp.cfg', d)} \
"

# LMP base requires a different u-boot configuration fragment
SRC_URI:append:lmp-base = " file://lmp-base.cfg "
SRC_URI:remove:lmp-base = "file://lmp.cfg"

SRC_URI:append:zynqmp = " \
    file://pm_cfg_obj.c \
"

# copy platform files to u-boot source dir
do_configure:prepend() {
    if [ -n "${PLATFORM_INIT_DIR}" ]; then
        for i in ${PLATFORM_INIT_FILES}; do
            cp ${PLATFORM_INIT_STAGE_DIR}/$i ${S}/
        done
    fi
}

# generate and configure u-boot to use pm_cfg_obj.bin
do_compile:prepend:zynqmp() {
    ${PYTHON} ${S}/tools/zynqmp_pm_cfg_obj_convert.py ${WORKDIR}/pm_cfg_obj.c ${S}/pm_cfg_obj.bin
    echo "CONFIG_ZYNQMP_SPL_PM_CFG_OBJ_FILE=\"${S}/pm_cfg_obj.bin\"" >> ${B}/.config
}

# support external dtb providers (previously available via meta-xilinx-tools)
python __anonymous () {
    #check if there are any dtb providers
    providerdtb = d.getVar("PREFERRED_PROVIDER_virtual/dtb")
    if providerdtb:
       d.appendVarFlag('do_configure', 'depends', ' virtual/dtb:do_populate_sysroot')
       if d.getVar("DTB_NAME") is not None:
            d.setVar('DTB_NAME', d.getVar('BASE_DTS')+ '.dtb')
}
BASE_DTS ?= "system-top"
DTB_PATH ?= "/boot/devicetree"
DTB_NAME ?= ""
EXTRA_OEMAKE += "${@'EXT_DTB=${RECIPE_SYSROOT}/${DTB_PATH}/${DTB_NAME}' if (d.getVar('DTB_NAME') != '') else '' }"

# Support additional u-boot classes such as u-boot-fitimage
UBOOT_CLASSES ?= ""
LOCALVERSION = "+xlnx"
inherit ${UBOOT_CLASSES} fio-u-boot-localversion

# setting DEPENDS create dependency loops so skip the check
LMPSTAGING_DEPLOYED_CHECK_SKIP += "${PN}:do_deploy"

python() {
    # we need to set the DEPENDS as well to produce valid SPDX documents
    fix_deployed_depends('do_install', d)
}
