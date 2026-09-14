cmake_minimum_required(VERSION 3.22)

project(FiveJarsBackend LANGUAGES C)

# Directory containing COBOL sources
set(SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src")

# Find all COBOL sources
file(GLOB_RECURSE COBOL_SOURCES CONFIGURE_DEPENDS
    "${SOURCE_DIR}/*.cbl"
)

# Find GnuCOBOL compiler and runtime
find_program(COBOL_COMPILER NAMES cobc REQUIRED)
find_library(COBOL_RUNTIME_LIBRARY NAMES cob REQUIRED)

message(STATUS "GnuCOBOL compiler: ${COBOL_COMPILER}")
message(STATUS "COBOL sources: ${COBOL_SOURCES}")
message(STATUS "GnuCOBOL runtime library: ${COBOL_RUNTIME_LIBRARY}")

if(NOT COBOL_SOURCES)
    message(FATAL_ERROR "No COBOL source files found in ${SOURCE_DIR}")
endif()

# Compile each COBOL source file
set(COBOL_OBJECTS)

foreach(COBOL_SOURCE IN LISTS COBOL_SOURCES)
    file(RELATIVE_PATH COBOL_REL_PATH "${SOURCE_DIR}" "${COBOL_SOURCE}")
    string(REPLACE "/" "_" COBOL_OBJECT_BASENAME "${COBOL_REL_PATH}")
    string(REGEX REPLACE "\\.cbl$" ".o" COBOL_OBJECT_BASENAME "${COBOL_OBJECT_BASENAME}")
    set(COBOL_OBJECT "${CMAKE_CURRENT_BINARY_DIR}/${COBOL_OBJECT_BASENAME}")

    add_custom_command(
        OUTPUT "${COBOL_OBJECT}"
        COMMAND "${COBOL_COMPILER}"
            -c
            -o "${COBOL_OBJECT}"
            "${COBOL_SOURCE}"
        DEPENDS "${COBOL_SOURCE}"
        COMMENT "Compiling COBOL object: ${COBOL_REL_PATH}"
        VERBATIM
    )

    list(APPEND COBOL_OBJECTS "${COBOL_OBJECT}")
endforeach()

# Final link is done by the C compiler/linker through CMake.
add_library(fivejars_cobol_kernel SHARED ${COBOL_OBJECTS})
set_target_properties(fivejars_cobol_kernel PROPERTIES
    LINKER_LANGUAGE C
    OUTPUT_NAME fivejars_cobol_kernel
)
target_link_libraries(fivejars_cobol_kernel PRIVATE ${COBOL_RUNTIME_LIBRARY})