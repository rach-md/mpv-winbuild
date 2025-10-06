set_property(DIRECTORY PROPERTY EP_STEP_TARGETS download)
list(APPEND ep
    xz
    uchardet
    zlib
    zstd
    libjpeg
    lcms2
    libiconv
    luajit
    fribidi
    brotli
    freetype2
    harfbuzz
    libunibreak
    libass
    subrandr
    xxhash
    dav1d
    libarchive
    highway
    libjxl
    spirv-headers
    spirv-tools
    spirv-cross
    glslang
    vulkan-header
    shaderc
    fast_float
    libplacebo
    ffmpeg
    mpv
)
foreach(package IN LISTS ep)
    if(NOT ${SINGLE_SOURCE_LOCATION} STREQUAL "")
        set(SOURCE_LOCATION "${SINGLE_SOURCE_LOCATION}/${package}")
    endif()
    include(${CMAKE_CURRENT_SOURCE_DIR}/${package}.cmake)
    set(SOURCE_LOCATION "")

    get_property(_git_repository TARGET ${package} PROPERTY _EP_GIT_REPOSITORY)
    if(_git_repository)
        list(APPEND repo ${package})
    endif()
endforeach()
list(LENGTH ep ep_length)
message(STATUS "Parsing ${ep_length} packages")

# Exclude packages which dont depend on mpv when update
list(TRANSFORM repo APPEND "-force-update" OUTPUT_VARIABLE update)
list(TRANSFORM ep APPEND "-download" OUTPUT_VARIABLE download)
list(TRANSFORM ep APPEND "-fullclean" OUTPUT_VARIABLE fullclean)

add_custom_target(update
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target ${update}
    COMMENT "Updating git repo"
)

add_custom_target(download
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target ${download}
)

add_custom_target(package-fullclean
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target ${fullclean}
    COMMENT "Remove all stamp files, reset git HEAD"
)
