################################################################################
#
# qrtr_ext
#
# Qualcomm IPC Router (QRTR) userspace: libqrtr plus the qrtr-ns name service,
# qrtr-cfg and qrtr-lookup.
#
# qrtr-ns is the QMI service registry / name service. The DSP subsystems
# register their protection-domain "servreg" service over QMI/QRTR; without a
# running name service that registration never completes, so the DSP rootPD
# never starts servicing FastRPC (the GLINK fastrpc channel opens but the DSP
# posts no RX intents -> "intent request timed out"). There is no systemd in
# this buildroot image, so qrtr-ns is launched from an init script.
#
# Pinned to the same revision as meta-qcom qrtr_1.2.bb (tag v1.2).
#
################################################################################

QRTR_EXT_VERSION = b51ffaf22707b6000ecfb894c5b750f3bb7843b2
QRTR_EXT_SITE = https://github.com/linux-msm/qrtr.git
QRTR_EXT_SITE_METHOD = git
QRTR_EXT_LICENSE = BSD-3-Clause
QRTR_EXT_LICENSE_FILES = LICENSE
QRTR_EXT_DEPENDENCIES = host-pkgconf
QRTR_EXT_INSTALL_STAGING = YES

# The qrtr-ns binary is gated behind the 'qrtr-ns' feature which defaults to
# 'auto' -- and meson's feature.enabled() is false for 'auto', so qrtr-ns is
# NOT built unless the feature is explicitly enabled. Force it on (this is the
# whole reason we add the package). Disable the systemd unit: no systemd here,
# we launch qrtr-ns from an init script.
QRTR_EXT_CONF_OPTS = -Dqrtr-ns=enabled -Dsystemd-service=disabled

$(eval $(meson-package))
