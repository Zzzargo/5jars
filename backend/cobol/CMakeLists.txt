cmake_minimum_required(VERSION 3.22)
project(FiveJarsBackend LANGUAGES C)

# Paths
set(SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)

# Find all COBOL sources
file(GLOB COBOL_SOURCES "${SOURCE_DIR}/*.cob")

# Find all C sources
file(GLOB C_WRAPPERS "${SOURCE_DIR}/*.c")

# Compile C wrappers as object library
add_library(c_wrappers OBJECT ${C_WRAPPERS})

# CMake doesn't f w COBOL sources so add them manually
foreach(cob_file ${COBOL_SOURCES})
    get_filename_component(cob_name ${cob_file} NAME_WE)

    add_custom_target(${cob_name} ALL
        # Compile COBOL with C wrapper objects
        COMMAND cobc -x ${cob_file} $<TARGET_OBJECTS:c_wrappers> -o ${CMAKE_CURRENT_BINARY_DIR}/${cob_name}
        # Rebuild if COBOL or C changes
        DEPENDS ${cob_file} $<TARGET_OBJECTS:c_wrappers>
        COMMENT "Building COBOL program ${cob_name}"
    )
endforeach()
