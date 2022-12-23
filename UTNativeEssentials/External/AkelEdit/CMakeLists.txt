cmake_minimum_required(VERSION 3.0.0)
project(AkelEdit)

if("${CMAKE_GENERATOR_PLATFORM}" STREQUAL "")
  set(TARGET_ARCH ${CMAKE_HOST_SYSTEM_PROCESSOR})
else()
  set(TARGET_ARCH ${CMAKE_GENERATOR_PLATFORM})
endif()

set(BUILD_SHARED_LIBS ON)

if("${TARGET_ARCH}" STREQUAL "x86" OR "${TARGET_ARCH}" STREQUAL "Win32")
  set(BIT "32")
elseif("${TARGET_ARCH}" STREQUAL "x64" OR "${TARGET_ARCH}" STREQUAL "Win64" OR "${TARGET_ARCH}" STREQUAL "AMD64")
  set(BIT "64")
else()
  message(FATAL_ERROR "Unsupported target architecture: ${TARGET_ARCH}")
endif()

add_compile_definitions(RC_AKELEDITBIT=${BIT})

set(SOURCES
  "AkelEdit.c"
  "Resources/AkelEdit.rc"
)

set(HEADERS
  "AkelBuild.h"
  "AkelEdit.h"
  "RegExpFunc.h"
  "StackFunc.h"
  "StrFunc.h"
  "x64Func.h"
)

add_library(AkelEdit STATIC ${SOURCES})

set_target_properties(AkelEdit
  PROPERTIES
  PUBLIC_HEADER "${HEADERS}"
)

target_link_libraries(AkelEdit
  uuid
  imm32
  ole32
  gdi32
)

target_include_directories(AkelEdit
    PRIVATE
        # where the library itself will look for its internal headers
        ${CMAKE_CURRENT_SOURCE_DIR}
    PUBLIC
        # where top-level project will look for the library's public headers
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        # where external projects will look for the library's public headers
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

target_compile_definitions(AkelEdit PUBLIC AkelEdit)