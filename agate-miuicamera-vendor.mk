#
# Automatically generated file. DO NOT MODIFY
#

PRODUCT_SOONG_NAMESPACES += \
    vendor/xiaomi/agate-miuicamera

PRODUCT_COPY_FILES += \
    vendor/xiaomi/agate-miuicamera/proprietary/product/etc/device_features/agate.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/device_features/agate.xml \
    vendor/xiaomi/agate-miuicamera/proprietary/product/etc/device_features/amber.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/device_features/amber.xml

PRODUCT_PACKAGES += \
    libmialgoengine \
    libmialgoengine2 \
    libutils-v32-nocs \
    libcamera_algoup_jni.xiaomi \
    libcamera_ispinterface_jni.xiaomi \
    libcamera_mianode_jni.xiaomi \
    libmtkisp_metadata_sys \
    MiuiCamera
