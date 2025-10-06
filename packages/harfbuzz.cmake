ExternalProject_Add(harfbuzz
    DEPENDS
        freetype2
    GIT_REPOSITORY https://github.com/harfbuzz/harfbuzz.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_REMOTE_NAME origin
    GIT_TAG main
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !test"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>
        --cross-file=${MESON_CROSS}
        -Dicu=disabled
        -Dglib=disabled
        -Dgobject=disabled
        -Dtests=disabled
        -Ddocs=disabled
        -Dutilities=disabled
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(harfbuzz)
force_meson_configure(harfbuzz)
cleanup(harfbuzz install)
