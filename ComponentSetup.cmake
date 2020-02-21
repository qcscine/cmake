#
# This file is licensed under the 3-clause BSD license.
# Copyright ETH Zurich, Laboratory for Physical Chemistry, Reiher Group.
# See LICENSE.txt for details.
#
include(DoxygenDocumentation)
include(Utils)

function(scine_setup_component)
# Give default value to parameter LANGUAGES
  if(NOT SCINE_SETUP_LANGUAGES)
    set(SCINE_SETUP_LANGUAGES CXX)
  endif()

  if(NOT SCINE_SETUP_VERSION)
    set(SCINE_SETUP_VERSION 1.0.1)
  endif()

# Default SCINE values
  set(SCINE_CMAKE_PACKAGE_ROOT "lib/cmake/Scine")
  set(SCINE_CMAKE_PACKAGE_ROOT "lib/cmake/Scine" PARENT_SCOPE)

# Compilation options
  set(CMAKE_CXX_STANDARD 14 PARENT_SCOPE)
  option(SCINE_EXTRA_WARNIGNS "Compile with an increased amount of compiler generated warnigs." ON)
  option(SCINE_WARNINGS_TO_ERRORS "Compile with warnings as errors." OFF)
  if (SCINE_EXTRA_WARNIGNS)
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
  option(SCINE_USE_MKL "Use the optimized MKL library for linear algebra operations of Eigen" OFF)

# Tests imports
  if(SCINE_BUILD_TESTS)
    include(ImportGTest)
    import_gtest()
  endif()

# Link MKL
if(SCINE_USE_INTEL_MKL)
  find_package(MKL)
  if(NOT MKL_FOUND)
    message(FATAL_ERROR "Intel MKL not found. Consider using -DSCINE_USE_INTEL_MKL=OFF")
  endif()
  target_compile_definitions(${PROJECT_NAME} PUBLIC -DEIGEN_USE_MKL_ALL)
  target_link_libraries(${PROJECT_NAME} PUBLIC mkl::mkl)
endif()
# CMake Master component file
  install(
    FILES "${PROJECT_SOURCE_DIR}/cmake/ScineConfig.cmake"
    DESTINATION ${SCINE_CMAKE_PACKAGE_ROOT}
  )

# Enable documentation target
  scine_component_documentation()

# Utility functions
endfunction()
