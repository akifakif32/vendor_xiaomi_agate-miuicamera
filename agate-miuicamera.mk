#
# SPDX-License-Identifier: Apache-2.0
#

$(call inherit-product, vendor/xiaomi/agate-miuicamera/agate-miuicamera-vendor.mk)

PRODUCT_COPY_FILES += \
    vendor/xiaomi/agate-miuicamera/configs/privapp-permissions-miuicamera.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-miuicamera.xml \
    vendor/xiaomi/agate-miuicamera/configs/miuicamera-permissions.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/default-permissions/miuicamera-permissions.xml \
    vendor/xiaomi/agate-miuicamera/configs/miuicamera-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/miuicamera-hiddenapi-package-whitelist.xml

PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.lens.oem_camera_package=com.android.camera \
    ro.miui.notch=1 \
    ro.product.mod_device=agate_global

PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.camera.privapp.list=com.android.camera
