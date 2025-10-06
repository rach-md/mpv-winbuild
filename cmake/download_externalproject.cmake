set(version "v3.31.6")

if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/cmake/Modules/ExternalProject.cmake")
    execute_process(
        COMMAND curl -sL -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/Kitware/Cmake/contents/Modules/ExternalProject?ref=${version}
        COMMAND jq -r .[].download_url
        COMMAND tr -d '\r'
        COMMAND xargs -n 1 curl -sLO --create-dirs --output-dir cmake/Modules/ExternalProject
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
    execute_process(
        COMMAND curl -sLO --output-dir Modules https://raw.githubusercontent.com/Kitware/CMake/refs/tags/${version}/Modules/ExternalProject.cmake
        COMMAND patch -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/packages/cmake-0001-ExternalProject-changes.patch
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/cmake
    )
endif()

include(${CMAKE_CURRENT_BINARY_DIR}/cmake/Modules/ExternalProject.cmake)
