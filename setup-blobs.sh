#!/bin/bash
# Stok dump'tan blob'lari repoya kopyalar. Kullanim: ./setup-blobs.sh [dump_yolu]
set -e
D=${1:-$HOME/agate_dump}
cd "$(dirname "$0")"
PE=$(command -v patchelf || ls "$HOME"/infinity/prebuilts/build-tools/linux-x86/bin/patchelf 2>/dev/null | head -1)
[ -n "$PE" ] || { echo "patchelf yok: sudo apt install patchelf"; exit 1; }
mkdir -p proprietary/product/priv-app/MiuiCamera proprietary/product/etc/device_features proprietary/system/lib64 proprietary/vendor/lib64
cp "$D/product/priv-app/MiuiCamera/MiuiCamera.apk" proprietary/product/priv-app/MiuiCamera/
cp "$D/product/etc/device_features/agate.xml" "$D/product/etc/device_features/amber.xml" proprietary/product/etc/device_features/
for l in libcamera_algoup_jni.xiaomi libcamera_ispinterface_jni.xiaomi libcamera_mianode_jni.xiaomi libmtkisp_metadata_sys; do
  cp "$D/system/lib64/$l.so" proprietary/system/lib64/
done
for l in libmialgo_ie_capture libmialgo_sd libmialgo_utils libmialgo_video_enhance libmialgoengine libmialgoengine2; do
  cp "$D/vendor/lib64/$l.so" proprietary/vendor/lib64/
done
# libutils-v32 without the CallStack hooks (own SONAME so bionic does not reuse the stock one)
U=$(ls "$HOME"/infinity/hardware/lineage/compat/vndk/v32/arm64/libutils-v32.so "$HOME"/Masaüstü/rom/hardware/lineage/compat/vndk/v32/arm64/libutils-v32.so 2>/dev/null | head -1)
[ -n "$U" ] || { echo "libutils-v32.so (hardware/lineage/compat/vndk/v32/arm64) bulunamadi"; exit 1; }
python3 - "$U" proprietary/vendor/lib64/libutils-v32-nocs.so <<'PY'
import sys
d=bytearray(open(sys.argv[1],'rb').read()); n=0
for name in (b"_ZN7android9CallStack18getCurrentInternalEi", b"_ZN7android9CallStack16logStackInternalEPKcPKS0_19android_LogPriority"):
    i=0
    while True:
        i=d.find(name,i)
        if i<0: break
        d[i+12]=ord('X'); n+=1; i+=len(name)
if n<2: sys.exit("CallStack sembolleri bulunamadi: %d" % n)
open(sys.argv[2],'wb').write(d)
PY
"$PE" --set-soname libutils-v32-nocs.so proprietary/vendor/lib64/libutils-v32-nocs.so
for l in libmialgoengine libmialgoengine2; do
  "$PE" --replace-needed libutils.so libutils-v32-nocs.so proprietary/vendor/lib64/$l.so
done
echo "tamam. git lfs kuruluysa: git lfs install && git add -A"
