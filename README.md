# MiuiCamera for Xiaomi 11T (agate / amber)

Stock `MiuiCamera` and its libraries from the agate stock firmware, built into the ROM
as a privileged, platform signed app. Generated like any other blob repo:

```sh
cd vendor/xiaomi/agate-miuicamera
./extract-files.py ~/agate_dump
```

`Android.bp`, `agate-miuicamera-vendor.mk` and `proprietary/` are generated, do not edit them.

## Notes

- The app and its JNI libraries are installed in `/system` (`system/priv-app`, `system/lib64`).
  They link against private platform libraries (`libgui`, `libbinder`) and an app in `/product`
  may only load the public ones. The permission files are in `/system/etc` for the same reason,
  privileged permissions are only granted from the partition of the app.
- `libmialgoengine` and `libmialgoengine2` are linked against `libutils-v32-nocs`, a copy of
  the Lineage `libutils-v32` with the CallStack hooks disabled (blob fixup in
  `extract-files.py`, needs `hardware/lineage` in the tree). The stock engine destroys hundreds
  of RefBase objects on every camera mode switch, with a normal `libutils` each of them prints
  a backtrace and a mode switch takes several seconds.
- `libcamera_ispinterface_jni` needs the `isphal@1.0` HIDL stub. The stock firmware ships a copy
  in `/system/lib64`, an app there cannot see the one in `/vendor`. It is installed as
  `isphal-sys@1.0` (soname and `NEEDED` of the JNI renamed in `extract-files.py`) so the module
  does not collide with the vendor one from `vendor/xiaomi/agate`. Without it taking a
  picture with HDR off (SuperNight / parallel burst path) crashes the app.
- The other MiAlgo libraries (`libmialgo_utils`, `_sd`, `_video_enhance`, `_ie_capture`) are used
  by the camera HAL and come from the device blob repo (`vendor/xiaomi/agate`).

## Device tree

`device/xiaomi/agate/device.mk`:

```make
$(call inherit-product, vendor/xiaomi/agate-miuicamera/agate-miuicamera.mk)
```

`device/xiaomi/agate/BoardConfig.mk`:

```make
include vendor/xiaomi/agate-miuicamera/BoardConfig.mk
```

The camera HAL blobs in the device blob repo must use `libui-v34` instead of `libui`,
see `blob_fixups` in `device/xiaomi/agate/extract-files.py`.
