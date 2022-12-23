#[[
    Abstractions and Models are NOT at WAR!
                                            - Cobwoy's Talisman
    But Abstractions don't care and Models can't understand!!
                                            - Lul, Practicality
 ]]

project(UTNativeEssentials)
set(OLDUNREAL_VERSION "469c")
cmake_minimum_required(VERSION 3.13) # we need add_link_options
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_PROJECT_VERSION_MAJOR "0")
set(CMAKE_PROJECT_VERSION_MINOR "1")
set(CMAKE_PROJECT_VERSION_PATCH "0")
# uncomment this to see compiler/linker commands
# set(CMAKE_VERBOSE_MAKEFILE ON)

include(CheckCCompilerFlag)
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

# Directory Structure Assumption
# UTGOTY
#  - ChatDiamond
#      - UTNativeEssentials
#         - ChatDiamond
#             - Inc
#             - Src
#      - Classes
#  - System
#  - ChatDiamondBin

# Control where the static and shared libraries are built
# We would want a semi-packaging fashioned way where all bianries are together
# whilst accessible from IDE (local debugger for instance!).
set(REPOSITORYROOT "${CMAKE_CURRENT_SOURCE_DIR}/../")
# Global variable for Karma's Libraries
set(CHATDIAMONDLIBRARYFOLDER "CompanionLibraries")

# UT GOTY directory
set(UTGOTYROOT "${CMAKE_CURRENT_SOURCE_DIR}/../../")



################################################################################
# Figure out build type and target platform
################################################################################

# Sanity checks
if(WIN32 AND NOT WINDOWS)
  set(WINDOWS TRUE)
  set(PLATFORM_PREFIX "Win")
endif()
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  set(LINUX TRUE)
  set(PLATFORM_PREFIX "Linux")
endif()

# See what CPU we appear to be targeting... 
macro(check_cpu _CDEFS _NAME _VALUE)
  check_c_source_compiles(
    "
        #if ( ${_CDEFS} )
        int main(int argc, char **argv) { int yup = 1; return 0; }
        #else
        #error Not targeting this CPU architecture.
        #endif
        "
    ${_VALUE}
  )

  if(${_VALUE})
    if(OLDUNREAL_CHOSE_CPU)
      message(STATUS "We appear to see two different CPU architectures!")
      message(STATUS "We saw '${OLDUNREAL_CPU}' and '${_NAME}'.")
      message(FATAL_ERROR "Please fix this before continuing.")
    endif()
    set(OLDUNREAL_CHOSE_CPU TRUE)
    set(OLDUNREAL_CPU ${_NAME})
  endif()
endmacro(check_cpu)

check_cpu(
  "defined(__i386__) || defined(__i686__) || defined(_M_IX86) || defined(i386)"
  "x86" OLDUNREAL_X86
)

check_cpu("defined(__x86_64__) || defined(_M_X64)" "amd64" OLDUNREAL_AMD64)

check_cpu("defined(__arm__)" "arm" OLDUNREAL_ARM)

check_cpu("defined(__arm64__)" "arm64" OLDUNREAL_ARM64)

if (NOT OLDUNREAL_CHOSE_CPU)
  message(FATAL_ERROR "We don't support this architecture yet")
endif()

################################################################################
# Build options
################################################################################

#add_compile_definitions(WINDOW_API __declspec(dllexport))

################################################################################
# Set the output directory
################################################################################
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${REPOSITORYROOT}/ChatDiamondBin/${PLATFORM_PREFIX}/${OLDUNREAL_CPU}/${CMAKE_BUILD_TYPE}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${REPOSITORYROOT}/ChatDiamondBin/${PLATFORM_PREFIX}/${OLDUNREAL_CPU}/${CMAKE_BUILD_TYPE}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${REPOSITORYROOT}/ChatDiamondBin/${PLATFORM_PREFIX}/${OLDUNREAL_CPU}/${CMAKE_BUILD_TYPE}")


################################################################################
# Locate or Build all 3rd party headers and libs
################################################################################

#include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindUE1Dependencies.cmake)

################################################################################
# Set compiler and linker flags
################################################################################

#add_compile_definitions("$<$<CONFIG:Debug>:_DEBUG>")
#add_compile_definitions("$<$<CONFIG:Release>:_RELEASE>")
#add_compile_definitions("$<$<CONFIG:Release>:NDEBUG>")
#add_compile_definitions("$<$<CONFIG:Release>:RELEASE>")

#add_compile_definitions(UTGLR_UT_BUILD)
#add_compile_definitions(UTGLR_USES_ALPHABLEND=1)
#add_compile_definitions(ENGINE_ARCHITECTURE="${OLDUNREAL_CPU}")

# use multi-threaded version of C runtime lib and link it statically
add_compile_definitions(_CRT_SECURE_NO_WARNINGS=1)
add_compile_definitions(_CRT_NO_VA_START_VALIDATION)
add_compile_definitions(UNICODE=1)
add_compile_definitions(_UNICODE=1)
add_compile_definitions(WIN32=1)

if(OLDUNREAL_AMD64)
   add_compile_definitions(WIN64=1)
else()
    #
    # /Zc:wchar_t-
    # do not treat wchar_t as a built-in type. Doing so would break binary
    # compat with almost all native mods for earlier UT versions
    #
    # /arch:SSE2
    # assume we have at least a Pentium 4
    #
    # /LARGEADDRESSAWARE
    # we can handle more than 2Gb of RAM even in 32bit builds
    #
    # /Zp4
    # use 4-byte alignment for structs. This is necessary for binary compatibility
    #
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Zc:wchar_t- /arch:SSE2 /Zp4 -DWINDOWS_IGNORE_PACKING_MISMATCH")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /Zc:wchar_t- /arch:SSE2 /Zp4 -DWINDOWS_IGNORE_PACKING_MISMATCH")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /LARGEADDRESSAWARE")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /LARGEADDRESSAWARE")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} /LARGEADDRESSAWARE")
    set(CMAKE_STATIC_LINKER_FLAGS "${CMAKE_STATIC_LINKER_FLAGS} /LARGEADDRESSAWARE")
endif()

#
# /MP
# enable parallel builds
#
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /MP")

# the recursive garbage collector needs a lot of stack space
set(CMAKE_EXE_LINKER_FLAGS
    "${CMAKE_EXE_LINKER_FLAGS} /STACK:16000000,1000000 /LTCG"
)
set(LIBRARY_SUFFIX ".dll")	

if(CMAKE_COMPILER_IS_GNUCC OR (CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pipe -fsigned-char -fno-strict-aliasing -Wno-inline-new-delete")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pipe -fsigned-char -fno-strict-aliasing")
endif()

if(OLDUNREAL_USE_ASAN)
  add_compile_options("-fsanitize=address")
  link_libraries("-fsanitize=address")
endif()

################################################################################
# Including External and (or) non Epic libraries
################################################################################
add_subdirectory(External/AkelEdit)

################################################################################
# Epic Essentials
################################################################################
add_subdirectory(Core)
add_subdirectory(Engine)

add_subdirectory(Window)

################################################################################
# Link Directories
################################################################################
link_directories(ChatDiamond Core/Lib Engine/Lib Window/Lib)

################################################################################
# Target Definitions / Custom Modding Stuff
################################################################################
add_subdirectory(ChatDiamond)
target_include_directories(ChatDiamond
    PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/Core/Inc
    ${CMAKE_CURRENT_SOURCE_DIR}/Engine/Inc)


################################################################################
# Target Linking Rules
################################################################################
target_link_libraries(ChatDiamond PUBLIC Core Engine AkelEdit Window)

# end of CMakeLists.txt ...