LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SHARED_LIBRARIES := stlport_shared
LOCAL_CPPFLAGS += -frtti

LOCAL_MODULE    := yhCommon
LOCAL_SRC_FILES := 						\
Common/yhBuffer.cpp						\
Common/yhCommon.cpp						\
Common/yhError.cpp						\
Common/yhHeapMonitor.cpp				\
Common/yhLog.cpp						\
Common/yhMath.cpp						\
Common/yhMessage.cpp					\
Common/yhMessageManager.cpp				\
Common/yhObjectPool.cpp					\
Common/Network/Socket/yhAsyncSocket.cpp					\
Common/Network/Socket/yhAsyncUdpSocket.cpp				\
Common/Network/Http/yhHttpRequest.cpp					\
Common/Thread/yhLock.cpp								\
Common/Thread/yhOperation.cpp							\
Common/Thread/yhRunLoop.cpp								\
Common/Thread/yhThread.cpp								\
Common/Thread/yhThreadPool.cpp							\
Common/Thread/yhTimer.cpp								\
Common/Thread/yhTimerScheduler.cpp						\
Common/Utility/yhDeviceUtility.cpp						\
Common/Utility/yhFileUtility.cpp						\
Common/Utility/yhNetworkUtility.cpp						\
Common/Utility/yhTimeUtility.cpp						\

LOCAL_LDLIBS += -llog

LOCAL_C_INCLUDES :=	\
	$(LOCAL_PATH)							\
    $(LOCAL_PATH)/Common                 \
    $(LOCAL_PATH)/Common/Network/Socket                 \
 	$(LOCAL_PATH)/Common/Thread                \
 	$(LOCAL_PATH)/Common/Utility			\

include $(BUILD_SHARED_LIBRARY)
