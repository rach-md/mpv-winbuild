ExternalProject_Add(mpv
    DEPENDS
        ffmpeg
        lcms2
        libarchive
        libass
        libiconv
        libjpeg
        luajit
        uchardet
        shaderc
        libplacebo
        spirv-cross
        zlib
        subrandr
    GIT_REPOSITORY https://github.com/mpv-player/mpv.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>
        --cross-file=${MESON_CROSS}
        -Db_ndebug=true
        -Db_lto=true
        -Db_lto_mode=thin
        -Dlibmpv=false
        -Dpdf-build=enabled
        -Dlua=luajit
        -Dgl=disabled
        -Ddirect3d=disabled
        -Dc_args='-Wno-error=int-conversion'
    BUILD_COMMAND ${EXEC} LTO_JOB=1 PDB=1 ninja
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(mpv copy-binary
    DEPENDEES build
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.exe ${CMAKE_BINARY_DIR}/mpv/mpv.exe
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.com ${CMAKE_BINARY_DIR}/mpv/mpv.com
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/mpv.pdf ${CMAKE_BINARY_DIR}/mpv/doc/manual.pdf
    COMMENT "Copying mpv binaries and manual"
)

force_rebuild_git(mpv)
force_meson_configure(mpv)
cleanup(mpv copy-binary)
