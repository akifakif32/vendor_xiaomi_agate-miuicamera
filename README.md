# MiuiCamera for Xiaomi 11T (agate / amber)

Stock `MiuiCamera` and its libraries from the agate stock firmware, built into the ROM
as a privileged, platform signed app.

## Blobs

```sh
./setup-blobs.sh ~/agate_dump
```

Copies the app, the JNI libraries and the device features from the stock dump and builds
`libutils-v32-nocs`, a copy of the Lineage `libutils-v32` with the CallStack hooks disabled
(otherwise every camera mode switch takes several seconds because of the RefBase backtraces).

The MiAlgo libraries come from the device blob repo, `libmialgoengine` and `libmialgoengine2`
are linked against `libutils-v32-nocs` by `blob_fixups` in `device/xiaomi/agate/extract-files.py`.
Git LFS is recommended for the APK and the libraries.

## Device tree

`device/xiaomi/agate/device.mk`:

```make
$(call inherit-product, vendor/xiaomi/agate-miuicamera/agate-miuicamera.mk)
```

`device/xiaomi/agate/BoardConfig.mk`:

```make
include vendor/xiaomi/agate-miuicamera/BoardConfigVendor.mk
```

The camera HAL blobs in the device blob repo must use `libui-v34` instead of `libui`,
see `blob_fixups` in `device/xiaomi/agate/extract-files.py`.
