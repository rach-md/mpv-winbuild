ExternalProject_Add(zlib
    GIT_REPOSITORY https://github.com/madler/zlib.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG develop
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -B <BINARY_DIR> -S <SOURCE_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DZLIB_BUILD_SHARED=OFF
        -DZLIB_BUILD_TESTING=OFF
        -DZLIB_INSTALL_COMPAT_DLL=OFF
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
            COMMAND ${CMAKE_COMMAND} -E rename ${MINGW_INSTALL_PREFIX}/lib/libzs.a
                                               ${MINGW_INSTALL_PREFIX}/lib/libz.a
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(zlib)
cleanup(zlib install)
