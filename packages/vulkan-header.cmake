ExternalProject_Add(vulkan-header
    GIT_REPOSITORY https://github.com/KhronosGroup/Vulkan-Headers.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG main
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1
)
force_rebuild_git(vulkan-header)
cleanup(vulkan-header install)
