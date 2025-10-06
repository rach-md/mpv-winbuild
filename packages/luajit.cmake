if(CYGWIN OR MSYS)
    # It's much easier to just use the target CC on Cygwin than to worry about
    # pointer size mismatches
    set(LUAJIT_HOST_GCC ${TARGET_ARCH}-gcc)
else()
    set(LUAJIT_HOST_GCC gcc)
endif()

if(${TARGET_CPU} MATCHES "i686")
    set(LUAJIT_GCC_ARGS "-m32")
    set(NO_UNWIND "-DLUAJIT_NO_UNWIND")
else()
    set(LUAJIT_GCC_ARGS "-m64")
endif()

set(EXPORT
    "CROSS=${TARGET_ARCH}-
    TARGET_SYS=Windows
    BUILDMODE=static
    FILE_T=luajit.exe
    CFLAGS='-DUNICODE'
    XCFLAGS='${NO_UNWIND}'
    PREFIX=${MINGW_INSTALL_PREFIX} Q="
)

ExternalProject_Add(luajit
    GIT_REPOSITORY https://github.com/LuaJIT/LuaJIT.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_REMOTE_NAME origin
    GIT_TAG v2.1
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE} -C <SOURCE_DIR>/src
        "HOST_CC='${LUAJIT_HOST_GCC} ${LUAJIT_GCC_ARGS}'"
        ${EXPORT}
        amalg
    INSTALL_COMMAND ${MAKE}
        "HOST_CC='${LUAJIT_HOST_GCC} ${LUAJIT_GCC_ARGS}'"
        ${EXPORT}
        install
            COMMAND ${EXEC} sed -i '/Libs.private:/c/Libs.private: -lm' ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/luajit.pc
    BUILD_IN_SOURCE 1
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(luajit)
cleanup(luajit install)
