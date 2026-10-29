# MiuiCamera for Xiaomi 11T (agate / amber)

Stock `MiuiCamera` and its libraries from the agate stock firmware, built into the ROM
as a privileged, platform signed app.

## Blobs

```sh
./setup-blobs.sh ~/agate_dump
```

Copies the app, the JNI libraries, the MiAlgo engine and the device features from the stock dump.

`libmialgoengine` and `libmialgoengine2` are linked against `libutils-v32-nocs`, a copy of the
Lineage `libutils-v32` with the CallStack hooks disabled. The stock engine destroys hundreds of
RefBase objects on every camera mode switch, with the stock `libutils` each of them prints a
backtrace and a mode switch takes several seconds.

The other MiAlgo libraries (`libmialgo_utils`, `_sd`, `_video_enhance`, `_ie_capture`) are used by
the camera HAL and come from the device blob repo (`vendor/xiaomi/agate`).

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
