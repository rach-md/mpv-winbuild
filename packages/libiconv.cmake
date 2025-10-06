ExternalProject_Add(libiconv
    URL https://www.mirrorservice.org/sites/ftp.gnu.org/gnu/libiconv/libiconv-1.19.tar.gz
    URL_HASH SHA256=88DD96A8C0464ECA144FC791AE60CD31CD8EE78321E67397E25FC095C4A19AA6
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
