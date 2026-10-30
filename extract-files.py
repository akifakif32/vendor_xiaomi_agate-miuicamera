#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

import shutil
import subprocess
from os import path

from extract_utils.fixups_blob import (
    BlobFixupCtx,
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)
from extract_utils.tools import android_root

LIBUTILS_V32 = path.join(
    android_root, 'hardware/lineage/compat/vndk/v32/arm64/libutils-v32.so'
)

# The stock MiAlgo engine destroys hundreds of RefBase objects on every camera mode switch,
# each of them prints a 60 frame backtrace and the mode switch takes 5 seconds. These two
# CallStack symbols are renamed (same length) so the backtraces are never produced.
CALLSTACK_SYMBOLS = (
    b'_ZN7android9CallStack18getCurrentInternalEi',
    b'_ZN7android9CallStack16logStackInternalEPKcPKS0_19android_LogPriority',
)


def libutils_nocs_impl(ctx: BlobFixupCtx, file, file_path: str, *args, **kwargs):
    with open(LIBUTILS_V32, 'rb') as f:
        data = bytearray(f.read())

    for name in CALLSTACK_SYMBOLS:
        index = data.find(name)
        assert index >= 0, f'{name!r} not found in {LIBUTILS_V32}'
        while index >= 0:
            data[index + 12] = ord('X')
            index = data.find(name, index + len(name))

    with open(file_path, 'wb') as f:
        f.write(data)

    # Own SONAME so bionic does not reuse the already loaded libutils-v32
    patchelf = path.join(
        android_root, 'prebuilts/extract-tools/linux-x86/bin/patchelf-0_18'
    )
    subprocess.run(
        [patchelf, '--set-soname', 'libutils-v32-nocs.so', file_path], check=True
    )


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
}

blob_fixups: blob_fixups_user_type = {
    # The listener is built against the A12 IProducerListener vtable, the new libgui calls
    # four slots that do not exist in it (needs*Notify) and crashes in Surface::connect.
    # Its only job is a log line in onBufferReleased, so connect with no listener:
    # stur x23, [x29, #-0x60] -> stur xzr, [x29, #-0x60] in setupOutputStream
    'system/lib64/libcamera_ispinterface_jni.xiaomi.so': blob_fixup()
        .replace_needed('vendor.mediatek.hardware.camera.isphal@1.0.so', 'vendor.mediatek.hardware.camera.isphal-sys@1.0.so')
        .sig_replace('B7 03 1A F8', 'BF 03 1A F8'),
    ('vendor/lib64/libmialgoengine.so', 'vendor/lib64/libmialgoengine2.so'): blob_fixup()
        .replace_needed('libutils.so', 'libutils-v32-nocs.so'),
    'vendor/lib64/libutils-v32-nocs.so': blob_fixup()
        .call(libutils_nocs_impl, need_tmp_dir=False),
}  # fmt: skip

module = ExtractUtilsModule(
    'agate-miuicamera',
    'xiaomi',
    device_rel_path='vendor/xiaomi/agate-miuicamera',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=[
        'vendor/xiaomi/agate',
        'vendor/xiaomi/mt6893-common',
    ],
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
