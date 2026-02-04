cmake_minimum_required(VERSION 3.10)
project(get-ip-tool C)

set(CMAKE_C_STANDARD 11)

# Find curl library
find_package(CURL REQUIRED)

add_executable(get-ip-tool get-ip-tool.c)

# Link curl library
if(TARGET CURL::libcurl)
    # vcpkg or modern CMake curl
    target_link_libraries(get-ip-tool PRIVATE CURL::libcurl)
else()
    # System curl (older CMake)
    target_link_libraries(get-ip-tool PRIVATE ${CURL_LIBRARIES})
    target_include_directories(get-ip-tool PRIVATE ${CURL_INCLUDE_DIRS})
endif()
