cmake_minimum_required(VERSION 3.10)
project(get-ip-tool C)

set(CMAKE_C_STANDARD 11)

# Find curl library
find_package(CURL REQUIRED)

add_executable(get-ip-tool get-ip-tool.c)

# Link curl library
target_link_libraries(get-ip-tool CURL::libcurl)
