################################################################################
#
# tqftpserv_ext
#
# TFTP-over-QRTR file server. Qualcomm DSP firmware reads files from the apps
# root filesystem (FastRPC runtime, configs, dynamic skels) over QRTR using
# this server. The CDSP FastRPC rootPD needs it to load its runtime; without it
# the fastrpc GLINK channel opens but the DSP never posts RX intents
# ("intent request timed out").
#
# No systemd here, so it is launched from an init script (after qrtr-ns).
# Pinned to the same revision as meta-qcom tqftpserv_1.2.bb (tag v1.2).
#
################################################################################

TQFTPSERV_EXT_VERSION = b6bb92d40cfffe28621abcf7bfaa6d99beea46cb
TQFTPSERV_EXT_SITE = https://github.com/linux-msm/tqftpserv.git
TQFTPSERV_EXT_SITE_METHOD = git
TQFTPSERV_EXT_LICENSE = BSD-3-Clause
TQFTPSERV_EXT_LICENSE_FILES = LICENSE
TQFTPSERV_EXT_DEPENDENCIES = host-pkgconf qrtr_ext zstd

# Upstream meson.build leaves systemd_system_unit_dir undefined when both
# 'systemd-unit-prefix' is empty and systemd is not found, then references it
# ("Unknown variable systemd_system_unit_dir"). Pass a non-empty prefix so the
# variable is defined; the installed unit is unused (no systemd here).
TQFTPSERV_EXT_CONF_OPTS = -Dsystemd-unit-prefix=/usr/lib/systemd/system

$(eval $(meson-package))
