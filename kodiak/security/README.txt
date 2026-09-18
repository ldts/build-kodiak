Security assets for the tfa target.

BL2 (tz.mbn)
────────────
OEM BL2 signing is DISABLED by default.  The device's XBL security stage
(xbl_sec) is not yet able to verify OEM-only signed binaries, so a BL2 signed
with our OEM key fails to boot.  Until then the tfa target simply copies the
pre-signed BL2 at kodiak/input/tz.mbn (a QTI-signed / production-signed image)
to kodiak/output/tz.mbn, erroring only if that pre-signed image is absent.

We are working to release the XBL verification image (updated xbl_sec) that can
verify OEM-only signed binaries as soon as possible.  Once it is available, OEM
signing can be re-enabled — no changes to this profile are needed:

    make SIGN_BL2=1 tfa    # build BL2 and OEM-sign it into tz.mbn via sectools

When enabled, the tfa target builds BL2 from TF-A and signs it into
kodiak/output/tz.mbn with Qualcomm's open-source sectools, using an OEM TEST key
and the kodiak_tzt_security_profile.xml profile in this directory (image id
TZ-TEE).  sectools is downloaded on demand from the public Qualcomm Software
Center — no account required (see SECTOOL_ZIP in kodiak.mk).  If signing then
fails (e.g. sectools cannot be downloaded), it WARNs and falls back to the
pre-signed kodiak/input/tz.mbn.

    make sign-bl2      # sign the already-built BL2 explicitly (OEM TEST key)
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
