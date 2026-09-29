# OP-TEE build.git

This repository is part of the [OP-TEE project](https://github.com/OP-TEE/build) — the upstream
build system for OP-TEE on open hardware platforms. It has been extended to support Qualcomm
platforms so that Qualcomm developers can work on TZ open firmware using the same tooling and
workflows used across the OP-TEE ecosystem. Contributions from this work are intended to be
upstreamed to the public [OP-TEE repositories](https://github.com/OP-TEE/).

Build system for OP-TEE on Qualcomm platforms.  Each platform has its own
top-level makefile and subdirectory.

## Supported platforms

| Platform | SoC | Board | Makefile |
|----------|-----|-------|----------|
| Kodiak | QCM6490 | Qualcomm RB3 Gen2 | `kodiak.mk` |

## Quick start

```sh
# Build everything
make -f kodiak.mk all

# Get Qualcomm firmware blobs for flashing (pick one):
make -f kodiak.mk fetch-blobs   # fast: direct download (minutes)
make -f kodiak.mk yocto         # full OE/Yocto BSP build (hours)

# Flash
make -f kodiak.mk flash-loader  # bootloader chain (first-time / after TF-A change)
make -f kodiak.mk flash-efi     # EFI partition only (kernel/initramfs iteration)
```

## Firmware blobs

Both `flash-loader` and `flash-efi` need Qualcomm-proprietary firmware
binaries (XBL, AOP, firehose programmer, GPT tables, rawprogram XMLs).
These are resolved in priority order:

1. `{platform}/input/` — manually placed files
2. Yocto deploy directory — if `make yocto` has been run
3. `{platform}/blobs/` — populated by `make fetch-blobs`

`make fetch-blobs` downloads the boot binaries and CDT directly from public
Qualcomm/CodeLinaro URLs and generates partition tables via
[qcom-ptool](https://github.com/qualcomm-linux/qcom-ptool).
No Qualcomm account is required; the download takes a few minutes.

See `{platform}/input/README.md` for the full file-by-file breakdown.

## Documentation

HTML slide decks for each platform are in `docs/`:

- `docs/kodiak.html` — Kodiak build, flash, and boot chain

## Further reading

- [OP-TEE documentation](https://optee.readthedocs.io)
- [Qualcomm Platform Docs](https://github.qualcomm.com/pages/ramirezo/build/)
