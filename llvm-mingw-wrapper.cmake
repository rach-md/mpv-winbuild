foreach(compiler clang++ g++ c++ clang gcc as)
    set(driver_mode "")
    set(clang_compiler "")
    set(linker "")

    if (compiler STREQUAL "g++" OR compiler STREQUAL "c++")
        set(driver_mode "--driver-mode=g++ -pthread")
        set(clang_compiler "clang++")
    elseif(compiler STREQUAL "clang++")
        set(driver_mode "--driver-mode=g++")
        set(clang_compiler "clang++")
        set(linker "-lc++abi")
    else()
        set(driver_mode "")
        set(clang_compiler "clang")
    endif()
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/llvm-compiler.in
                   ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-${compiler}
                   FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
                   @ONLY)
endforeach()

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/llvm-ld.in
               ${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-ld
               FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
               @ONLY)
