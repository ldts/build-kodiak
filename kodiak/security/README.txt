Security assets for the tfa target.

BL2 (tz.mbn)
────────────
By default the tfa target builds BL2 from TF-A and signs it into
kodiak/output/tz.mbn with Qualcomm's open-source sectools, using an OEM TEST key
and the kodiak_tzt_security_profile.xml profile in this directory (image id
TZ-TEE).  sectools is downloaded on demand from the public Qualcomm Software
Center — no account required (see SECTOOL_ZIP in kodiak.mk).

If signing fails (e.g. sectools cannot be downloaded), the tfa target prints a
WARNING and falls back to a pre-signed BL2 at kodiak/input/tz.mbn (a QTI-signed
or otherwise production-signed image), erroring only if that is also absent.

    make sign-bl2      # sign the already-built BL2 explicitly
    make sectools      # just fetch the signing tool

kodiak_tzt_security_profile.xml
───────────────────────────────
sectools signing profile for the KODIAK (SC7280/QCM6490) SoC.  Defines the
image list and OEM/QTI authenticators; the tfa target passes it via
--security-profile when signing the TZ-TEE (BL2) image.

QTISECLIB
─────────
libqtisec.a is not checked in here.  The verify-qtiseclib target (a prerequisite
of `make tfa`, so it runs before TF-A is built) downloads it on demand from the
coreboot qc_blobs repository and verifies it against an MD5 checksum defined in
kodiak.mk before it is used:

    https://github.com/coreboot/qc_blobs/raw/master/sc7280/qtiseclib/libqtisec.a

To pre-populate it manually instead:

    curl -L https://github.com/coreboot/qc_blobs/raw/master/sc7280/qtiseclib/libqtisec.a \
         -o kodiak/security/libqtisec.a
