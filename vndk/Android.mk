ifneq ($(TARGET_SUPPORTS_WEARABLES),true)
ifeq ($(BOARD_VNDK_VERSION),)
$(warning ************* BOARD VNDK is not enabled - compiling vndk-sp ***************************)
LOCAL_PATH := $(call my-dir)

include $(LOCAL_PATH)/vndk-sp-libs.mk

vndk_sp_dir := vndk-sp-$(PLATFORM_VNDK_VERSION)

define define-vndk-sp-lib
include $$(CLEAR_VARS)
LOCAL_MODULE := $1.vndk-sp-gen
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_PREBUILT_MODULE_FILE := $$(call intermediates-dir-for,SHARED_LIBRARIES,$1)/$1.so
LOCAL_STRIP_MODULE := false
LOCAL_MULTILIB := first
LOCAL_MODULE_TAGS := optional
LOCAL_INSTALLED_MODULE_STEM := $1.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_RELATIVE_PATH := $(vndk_sp_dir)
include $$(BUILD_PREBUILT)

ifneq ($$(TARGET_2ND_ARCH),)
ifneq ($$(TARGET_TRANSLATE_2ND_ARCH),true)
include $$(CLEAR_VARS)
LOCAL_MODULE := $1.vndk-sp-gen
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_PREBUILT_MODULE_FILE := $$(call intermediates-dir-for,SHARED_LIBRARIES,$1,,,$(TARGET_2ND_ARCH_VAR_PREFIX))/$1.so
LOCAL_STRIP_MODULE := false
LOCAL_MULTILIB := 32
LOCAL_MODULE_TAGS := optional
LOCAL_INSTALLED_MODULE_STEM := $1.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_RELATIVE_PATH := $(vndk_sp_dir)
include $$(BUILD_PREBUILT)
endif # TARGET_TRANSLATE_2ND_ARCH is not true
endif # TARGET_2ND_ARCH is not empty
endef

$(foreach lib,$(VNDK_SP_LIBRARIES),\
    $(eval $(call define-vndk-sp-lib,$(lib))))

include $(CLEAR_VARS)
LOCAL_MODULE := vndk-sp
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES := $(addsuffix .vndk-sp-gen,$(VNDK_SP_LIBRARIES))
include $(BUILD_PHONY_PACKAGE)

vndk_sp_dir :=
endif
endif