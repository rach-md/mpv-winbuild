get_property(src_vulkan-header TARGET vulkan-header PROPERTY _EP_SOURCE_DIR)
get_property(src_fast_float TARGET fast_float PROPERTY _EP_SOURCE_DIR)
ExternalProject_Add(libplacebo
    DEPENDS
        vulkan-header
        shaderc
        spirv-cross
        lcms2
        fast_float
        xxhash
    GIT_REPOSITORY https://github.com/haasn/libplacebo.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
              COMMAND ${CMAKE_COMMAND} -E rm -rf <SOURCE_DIR>/3rdparty/Vulkan-Headers
              COMMAND ${CMAKE_COMMAND} -E rm -rf <SOURCE_DIR>/3rdparty/fast_float
              COMMAND ${CMAKE_COMMAND} -E create_symlink ${src_vulkan-header} <SOURCE_DIR>/3rdparty/Vulkan-Headers
              COMMAND ${CMAKE_COMMAND} -E create_symlink ${src_fast_float} <SOURCE_DIR>/3rdparty/fast_float
              COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>
                  --cross-file=${MESON_CROSS}
                  -Ddemos=false
                  -Dopengl=disabled
                  -Dvulkan=disabled
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libplacebo)
force_meson_configure(libplacebo)
cleanup(libplacebo install)
