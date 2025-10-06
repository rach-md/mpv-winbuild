ExternalProject_Add(libarchive
    DEPENDS
        xz
        zlib
        zstd
        libiconv
    GIT_REPOSITORY https://github.com/libarchive/libarchive.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -B <BINARY_DIR> -S <SOURCE_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DCMAKE_INSTALL_LIBDIR=lib
        -DBUILD_SHARED_LIBS=OFF
        -DENABLE_ZLIB=ON
        -DENABLE_ZSTD=ON
        -DENABLE_OPENSSL=OFF
        -DENABLE_BZip2=OFF
        -DENABLE_ICONV=ON
        -DENABLE_LIBXML2=OFF
        -DENABLE_EXPAT=OFF
        -DENABLE_LZO=OFF
        -DENABLE_WIN32_XMLLITE=OFF
        -DENABLE_PCREPOSIX=OFF
        -DENABLE_PCRE2POSIX=OFF
        -DENABLE_LZ4=OFF
        -DENABLE_LIBB2=OFF
        -DENABLE_LZMA=ON
        -DENABLE_CPIO=OFF
        -DENABLE_CAT=OFF
        -DENABLE_TAR=OFF
        -DENABLE_ACL=OFF
        -DENABLE_WERROR=OFF
        -DBUILD_TESTING=OFF
        -DENABLE_TEST=OFF
        -DWINDOWS_VERSION=WIN10
        -DPOSIX_REGEX_LIB=OFF
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libarchive)
cleanup(libarchive install)
