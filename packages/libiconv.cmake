ExternalProject_Add(libiconv
    URL https://www.mirrorservice.org/sites/ftp.gnu.org/gnu/libiconv/libiconv-1.18.tar.gz
    URL_HASH SHA256=3B08F5F4F9B4EB82F151A7040BFD6FE6C6FB922EFE4B1659C66EA933276965E8
    DOWNLOAD_DIR ${SOURCE_LOCATION}
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/configure
        --host=${TARGET_ARCH}
        --prefix=${MINGW_INSTALL_PREFIX}
        --disable-nls
        --disable-shared
        --enable-extra-encodings
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

cleanup(libiconv install)
