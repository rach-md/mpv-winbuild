if(CLANG_PACKAGES_LTO)
    set(cargo_lto_rustflags "RUSTFLAGS='-Clinker-plugin-lto -Cembed-bitcode -Clto=thin'")
    set(ffmpeg_lto "--enable-lto=thin")
endif()
