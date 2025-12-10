ExternalProject_Add(qjs
    GIT_REPOSITORY https://github.com/bellard/quickjs.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${EXEC} LTO=0 make -j4 CONFIG_CLANG=y CONFIG_WIN32=y
    INSTALL_COMMAND ""
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(qjs copy-binary
    DEPENDEES build
    COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/qjs.exe ${CMAKE_BINARY_DIR}/qjs/qjs.exe
    COMMAND ${CMAKE_COMMAND} -E copy ${MINGW_INSTALL_PREFIX}/bin/libwinpthread-1.dll ${CMAKE_BINARY_DIR}/qjs/libwinpthread-1.dll
    COMMENT "Copying qjs binaries"
    LOG 1
)

force_rebuild_git(qjs)
force_meson_configure(qjs)
cleanup(qjs copy-binary)
