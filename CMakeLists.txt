cmake_minimum_required(VERSION 3.19.0)
project(mpv-cross C)
include(ProcessorCount)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/download_externalproject.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/custom_steps.cmake)

cmake_policy(SET CMP0097 NEW)
cmake_policy(SET CMP0114 NEW)
if(POLICY CMP0135)
  cmake_policy(SET CMP0135 NEW)
endif()

if(NOT CMAKE_GENERATOR STREQUAL "Ninja")
    message(WARNING "Generator “${CMAKE_GENERATOR}” is unsupported!\nTry Ninja if you encounter problems.")
endif()
# Supported arch: x86_64-w64-mingw32
set(TARGET_ARCH "x86_64-w64-mingw32" CACHE STRING "The target architecture for this toolchain.")
string(REGEX MATCH "^[^-]+" TARGET_CPU ${TARGET_ARCH})

execute_process(COMMAND ${CMAKE_C_COMPILER} -dumpmachine OUTPUT_VARIABLE HOST_ARCH)
string(REGEX MATCH "^[^-]+" HOST_CPU ${HOST_ARCH})

if(TARGET_CPU STREQUAL "x86_64")
    set(TARGET_CPU_FAMILY "x86_64")
    set(TARGET_BITS 64)
    set(GCC_ARCH "x86-64" CACHE STRING "Target architecture for x86_64")
    string(REGEX MATCH "-v3" x86_64_LEVEL ${GCC_ARCH})
endif()

processorcount(CPU_COUNT)
if(CPU_COUNT EQUAL 0)
    set(CPU_COUNT 1)
endif()

find_file(MALLOC "libmimalloc.so" "libmimalloc.so.2" "libjemalloc.so"
          PATHS "/usr/lib" "/usr/lib64" "/usr/lib/x86_64-linux-gnu" "/usr/local/lib")
if(MALLOC)
    option(LLD_LTO_ALL_THREADS "Allow LLD to use all threads for ThinLTO, non-Glibc malloc implementations can improve performance." ON)
endif()

set(MAKEJOBS ${CPU_COUNT})

if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set (CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "Default install path" FORCE )
endif()
set(MINGW_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX}/${TARGET_ARCH} CACHE STRING "Target toolchain path")
set(SINGLE_SOURCE_LOCATION "" CACHE STRING "Repository or tarball stored path")
set(RUST_LOCATION "${CMAKE_CURRENT_BINARY_DIR}/rust" CACHE STRING "Rust toolchain path")
option(ENABLE_CCACHE "Enable ccache" ON)
set(CCACHE_MAXSIZE "500M" CACHE STRING "Size of ccache")
set(CCACHE_DIR "${MINGW_INSTALL_PREFIX}/ccache" CACHE STRING "Directory to keep ccached data")
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/ccache_conf.in ${CCACHE_DIR}/ccache.conf @ONLY)
find_program(CCACHE_EXISTS ccache NO_CACHE)
if(NOT CCACHE_EXISTS)
    set(ENABLE_CCACHE OFF)
endif()
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/toolchain.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/toolchain.cmake @ONLY)
set(TOOLCHAIN_FILE ${CMAKE_CURRENT_BINARY_DIR}/toolchain.cmake)
set(CLANG_FLAGS "" CACHE STRING "These flags will be added to the end of the clang args")
set(LLD_FLAGS "" CACHE STRING "These flags will be added to the end of the lld args")

include(${CMAKE_CURRENT_SOURCE_DIR}/llvm-mingw-wrapper.cmake)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/meson_cross.txt.in ${CMAKE_CURRENT_BINARY_DIR}/meson_cross.txt @ONLY)
set(MESON_CROSS ${CMAKE_CURRENT_BINARY_DIR}/meson_cross.txt)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cargo_config.in ${RUST_LOCATION}/.cargo/config.toml @ONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/exec.in ${CMAKE_CURRENT_BINARY_DIR}/exec FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE @ONLY)
set(EXEC ${CMAKE_CURRENT_BINARY_DIR}/exec)
set(MAKE ${EXEC} make -j${MAKEJOBS})

if(TARGET_CPU STREQUAL "x86_64")
    execute_process(
        COMMAND ${EXEC} echo | ${CMAKE_C_COMPILER} -dM -E - -march=${GCC_ARCH}
        OUTPUT_VARIABLE CC_OUTPUT
    )
    if(CC_OUTPUT MATCHES "__AVX")
        set(GCC_ARCH_HAS_AVX ON)
    endif()
    if(CC_OUTPUT MATCHES "__AVX512F")
        set(GCC_ARCH_HAS_AVX512 ON)
    endif()
endif()

string(TIMESTAMP BUILDDATE "%Y%m%d" UTC)

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/publish.in)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/publish.in ${CMAKE_CURRENT_BINARY_DIR}/publish)
endif()

message(STATUS "MINGW_INSTALL_PREFIX dir: ${MINGW_INSTALL_PREFIX}")
message(STATUS "SINGLE_SOURCE_LOCATION dir: ${SINGLE_SOURCE_LOCATION}")
message(STATUS "RUST_LOCATION dir: ${RUST_LOCATION}")
message(STATUS "Compiler used: ${COMPILER_TOOLCHAIN}")
message(STATUS "Malloc: ${MALLOC}")
message(STATUS "Ccache: ${ENABLE_CCACHE}")
message(STATUS "Target toolchain to build: ${TARGET_ARCH}")

add_subdirectory(packages)
