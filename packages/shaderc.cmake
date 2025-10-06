get_property(src_glslang TARGET glslang PROPERTY _EP_SOURCE_DIR)
get_property(src_spirv-headers TARGET spirv-headers PROPERTY _EP_SOURCE_DIR)
get_property(src_spirv-tools TARGET spirv-tools PROPERTY _EP_SOURCE_DIR)
ExternalProject_Add(shaderc
    DEPENDS
        glslang
        spirv-headers
        spirv-tools
    GIT_REPOSITORY https://github.com/google/shaderc.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_REMOTE_NAME origin
    GIT_TAG main
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
              COMMAND ${CMAKE_COMMAND} -E create_symlink ${src_glslang} <SOURCE_DIR>/third_party/glslang
              COMMAND ${CMAKE_COMMAND} -E create_symlink ${src_spirv-headers} <SOURCE_DIR>/third_party/spirv-headers
              COMMAND ${CMAKE_COMMAND} -E create_symlink ${src_spirv-tools} <SOURCE_DIR>/third_party/spirv-tools
              COMMAND ${EXEC} LTO_JOB=1 CONF=1 cmake -B <BINARY_DIR> -S <SOURCE_DIR>
                  -G Ninja
                  -DCMAKE_BUILD_TYPE=Release
                  -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
                  -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
                  -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
                  -DBUILD_SHARED_LIBS=OFF
                  -DSHADERC_SKIP_TESTS=ON
                  -DSHADERC_SKIP_SPVC=ON
                  -DSHADERC_SKIP_INSTALL=ON
                  -DSHADERC_SKIP_EXAMPLES=ON
                  -DSPIRV_SKIP_EXECUTABLES=ON
                  -DSPIRV_SKIP_TESTS=ON
                  -DENABLE_SPIRV_TOOLS_INSTALL=ON
                  -DENABLE_GLSLANG_BINARIES=OFF
                  -DSPIRV_TOOLS_BUILD_STATIC=ON
                  -DSPIRV_TOOLS_LIBRARY_TYPE=STATIC
                  -DMINGW_COMPILER_PREFIX=${TARGET_ARCH}
                  -DCMAKE_CXX_FLAGS='${CMAKE_CXX_FLAGS}'
    BUILD_COMMAND ${EXEC} LTO_JOB=1 ninja
          COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/libshaderc/include/shaderc ${MINGW_INSTALL_PREFIX}/include/shaderc
          COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/libshaderc/libshaderc_combined.a ${MINGW_INSTALL_PREFIX}/lib/libshaderc_combined.a
          COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/shaderc_combined.pc ${MINGW_INSTALL_PREFIX}/lib/pkgconfig/shaderc.pc
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(shaderc)
cleanup(shaderc install)
