#
# This file is licensed under the 3-clause BSD license.
# Copyright ETH Zurich, Laboratory for Physical Chemistry, Reiher Group.
# See LICENSE.txt for details.
#
include(DoxygenDocumentation)
include(Utils)

function(scine_setup_component)
# Set a default build type
  set(default_build_type "RelWithDebInfo")
  if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    message(STATUS "Setting build type to default '${default_build_type}'")
    set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE
      STRING "Choose the type of the build."
      FORCE
    )
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY
      STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo"
    )
  endif()

# Give default value to parameter LANGUAGES
  if(NOT SCINE_SETUP_LANGUAGES)
    set(SCINE_SETUP_LANGUAGES CXX)
  endif()

  if(NOT SCINE_SETUP_VERSION)
    set(SCINE_SETUP_VERSION 2.0.0)
  endif()

# Default SCINE values
  set(SCINE_CMAKE_PACKAGE_ROOT "lib/cmake/Scine")
  set(SCINE_CMAKE_PACKAGE_ROOT "lib/cmake/Scine" PARENT_SCOPE)

# Compilation options
  set(CMAKE_CXX_STANDARD 14 PARENT_SCOPE)
  option(SCINE_EXTRA_WARNINGS "Compile with an increased amount of compiler generated warnigs." ON)
  option(SCINE_WARNINGS_TO_ERRORS "Compile with warnings as errors." OFF)
  if (SCINE_EXTRA_WARNINGS)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wno-comment")
  endif()
  if (SCINE_WARNINGS_TO_ERRORS)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")
  endif()
  set(CMAKE_EXPORT_COMPILE_COMMANDS ON PARENT_SCOPE)

# Meta-build options
  option(SCINE_BUILD_TESTS "Build all test executables." ON)
  option(SCINE_BUILD_DOCS "Build the documentation." ON)
  option(SCINE_BUILD_PYTHON_BINDINGS "Build all available Python bindings" OFF)
  option(SCINE_BUILD_GUI_MODULES "Build all available GUI modules" OFF)
  set(SCINE_MARCH "native" CACHE STRING "Build all components with the -march=native compiler flag.")

  if(NOT "${SCINE_MARCH_WARNING_PRINTED}" AND NOT "${SCINE_MARCH}" STREQUAL "")
    message(WARNING "You are compiling Scine components with an architecture-specific ISA: -march=${SCINE_MARCH}. Linking together libraries with mismatched architecture build flags can cause problems, in particular with Eigen. Watch out!")
    set(SCINE_MARCH_WARNING_PRINTED ON)
  endif()

# Tests imports
  if(SCINE_BUILD_TESTS)
    include(ImportGTest)
    import_gtest()
  endif()

# CMake Master component file
  install(
    FILES "${PROJECT_SOURCE_DIR}/cmake/ScineConfig.cmake"
    DESTINATION ${SCINE_CMAKE_PACKAGE_ROOT}
  )

# Do not search the installation path in subsequent builds
  set(CMAKE_FIND_NO_INSTALL_PREFIX ON CACHE BOOL "" FORCE)

# Enable documentation target
  scine_component_documentation()

# Utility functions
endfunction()
