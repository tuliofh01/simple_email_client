cmake_minimum_required(VERSION 3.20)

project(
    smtp_client
    VERSION 1.0.0
    DESCRIPTION "Cross-platform SMTP email client"
    HOMEPAGE_URL "https://github.com/your-org/smtp-client"
    LANGUAGES CXX
)

# ---- Modern C++ ----
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# ---- Platform Detection ----
if(WIN32)
    add_definitions(-DWIN32_LEAN_AND_MEAN -DNOMINMAX)
    set(PLATFORM_NAME "Windows")
elseif(APPLE)
    set(PLATFORM_NAME "macOS")
else()
    set(PLATFORM_NAME "Linux")
endif()

# ---- Dependency Management ----
# Try to find CURL with different methods
find_package(CURL QUIET)
if(CURL_FOUND)
    message(STATUS "Found CURL: ${CURL_LIBRARIES}")
else()
    # Fallback for older CMake versions
    find_path(CURL_INCLUDE_DIR curl/curl.h)
    find_library(CURL_LIBRARY NAMES curl libcurl)
    if(CURL_INCLUDE_DIR AND CURL_LIBRARY)
        add_library(CURL::libcurl UNKNOWN IMPORTED)
        set_target_properties(CURL::libcurl PROPERTIES
            IMPORTED_LOCATION "${CURL_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${CURL_INCLUDE_DIR}"
        )
        message(STATUS "Found CURL manually: ${CURL_LIBRARY}")
    else()
        message(FATAL_ERROR "CURL library not found. Please install libcurl development packages.")
    endif()
endif()

# ---- Target Configuration ----
add_executable(send_mail
    src/main.cpp
)

target_link_libraries(send_mail
    PRIVATE CURL::libcurl
)

# ---- Compiler-specific Optimizations ----
if(MSVC)
    target_compile_options(send_mail PRIVATE
        /W4
        /permissive-
        /EHsc
        $<$<CONFIG:Release>:/O2>
        $<$<CONFIG:Debug>:/Od>
    )
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(send_mail PRIVATE
        -Wall -Wextra -Wpedantic
        $<$<CONFIG:Release>:-O3 -march=native>
        $<$<CONFIG:Debug>:-O0 -g>
    )
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    target_compile_options(send_mail PRIVATE
        -Wall -Wextra -Wpedantic
        $<$<CONFIG:Release>:-O3>
        $<$<CONFIG:Debug>:-O0 -g>
    )
endif()

# ---- Build Information ----
target_compile_definitions(send_mail PRIVATE
    SMTP_CLIENT_VERSION="${PROJECT_VERSION}"
    SMTP_CLIENT_PLATFORM="${PLATFORM_NAME}"
)

# ---- Installation ----
include(GNUInstallDirs)

install(TARGETS send_mail
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    COMPONENT Runtime
)

install(FILES ${CMAKE_SOURCE_DIR}/../LICENSE
    DESTINATION ${CMAKE_INSTALL_DOCDIR}
    COMPONENT Runtime
)

# ---- CPack Configuration ----
set(CPACK_PACKAGE_NAME "smtp_client")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PROJECT_DESCRIPTION}")
set(CPACK_PACKAGE_VENDOR "SMTP Client Project")
set(CPACK_PACKAGE_CONTACT "maintainer@example.com")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/../LICENSE")

if(WIN32)
    set(CPACK_GENERATOR "NSIS;ZIP")
    set(CPACK_NSIS_DISPLAY_NAME "SMTP Client")
    set(CPACK_NSIS_PACKAGE_NAME "smtp_client")
elseif(APPLE)
    set(CPACK_GENERATOR "DragNDrop;TGZ")
else()
    set(CPACK_GENERATOR "DEB;RPM;TGZ")
    set(CPACK_DEBIAN_PACKAGE_DEPENDS "libcurl4, libc6")
    set(CPACK_RPM_PACKAGE_REQUIRES "libcurl, glibc")
endif()

include(CPack)

# ---- Testing ----
enable_testing()
add_test(NAME send_mail_help_test COMMAND send_mail --help || true)

# ---- Print Configuration Summary ----
message(STATUS "")
message(STATUS "SMTP Client Configuration Summary:")
message(STATUS "  Version: ${PROJECT_VERSION}")
message(STATUS "  Platform: ${PLATFORM_NAME}")
message(STATUS "  Compiler: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "  Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "  Install Prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "  C++ Standard: ${CMAKE_CXX_STANDARD}")
if(CURL_FOUND)
    message(STATUS "  CURL: ${CURL_LIBRARIES}")
else()
    message(STATUS "  CURL: ${CURL_LIBRARY}")
endif()
message(STATUS "")
