ExternalProject_Add(spirv-cross
    GIT_REPOSITORY https://github.com/KhronosGroup/SPIRV-Cross.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_REMOTE_NAME origin
    GIT_TAG main
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -B <BINARY_DIR> -S <SOURCE_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=OFF
        -DSPIRV_CROSS_SHARED=ON
        -DSPIRV_CROSS_CLI=OFF
        -DSPIRV_CROSS_ENABLE_TESTS=OFF
        -DSPIRV_CROSS_ENABLE_MSL=OFF
        -DSPIRV_CROSS_ENABLE_CPP=OFF
        -DSPIRV_CROSS_ENABLE_REFLECT=OFF
        -DSPIRV_CROSS_ENABLE_UTIL=OFF
        -DCMAKE_CXX_FLAGS='${CMAKE_CXX_FLAGS}'
    BUILD_COMMAND ${EXEC} ninja
          COMMAND ${EXEC} llvm-lib /out:libspirv-cross-c.a libspirv-cross-{c,core,glsl,hlsl}.a
    INSTALL_COMMAND ${EXEC} ninja install
            COMMAND ${CMAKE_COMMAND} -E create_symlink ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/spirv-cross-c.pc
                                                       ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/spirv-cross-c-shared.pc
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(spirv-cross)
cleanup(spirv-cross install)
