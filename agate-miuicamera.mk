#
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_SOONG_NAMESPACES += \
    vendor/xiaomi/agate-miuicamera

PRODUCT_COPY_FILES += \
    vendor/xiaomi/agate-miuicamera/configs/privapp-permissions-miuicamera.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-miuicamera.xml \
    vendor/xiaomi/agate-miuicamera/configs/miuicamera-permissions.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/default-permissions/miuicamera-permissions.xml \
    vendor/xiaomi/agate-miuicamera/configs/miuicamera-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/miuicamera-hiddenapi-package-whitelist.xml \
    vendor/xiaomi/agate-miuicamera/proprietary/product/etc/device_features/agate.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/device_features/agate.xml \
    vendor/xiaomi/agate-miuicamera/proprietary/product/etc/device_features/amber.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/device_features/amber.xml

PRODUCT_PACKAGES += \
    MiuiCamera \
    libcamera_algoup_jni.xiaomi \
    libcamera_ispinterface_jni.xiaomi \
    libcamera_mianode_jni.xiaomi \
    libmtkisp_metadata_sys \
    libmialgo_ie_capture \
    libmialgo_sd \
    libmialgo_utils \
    libmialgo_video_enhance \
    libmialgoengine \
    libmialgoengine2 \
    libutils-v32-nocs

PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.lens.oem_camera_package=com.android.camera \
    ro.miui.notch=1 \
    ro.product.mod_device=agate_global

PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.camera.privapp.list=com.android.camera
