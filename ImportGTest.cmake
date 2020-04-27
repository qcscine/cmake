#
# This file is licensed under the 3-clause BSD license.
# Copyright ETH Zurich, Laboratory for Physical Chemistry, Reiher Group.
# See LICENSE.txt for details.
#
macro(import_gtest)
  # If the target already exists, do nothing
  if(NOT TARGET gtest)
    # Try to find the package locally
    find_package(GTest 1.8.1 QUIET)
    if(TARGET gtest)
      message(STATUS "GTest 1.8.1 found locally at ${GTest_DIR}.")
    else()
      # Download it instead
      include(DownloadProject)
      download_project(
        PROJ                googletest
        GIT_REPOSITORY      https://gitlab.chab.ethz.ch/scine/googletest.git
        GIT_TAG             release-1.8.1
        QUIET
        UPDATE_DISCONNECTED 1
      )
      # Prevent GoogleTest from overriding our compiler/linker options when
      # building with Visual Studio
      set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
      add_subdirectory(${googletest_SOURCE_DIR} ${googletest_BINARY_DIR})

      # Final check if all went well
      if(TARGET gtest)
        message(STATUS "GTest was not found in your PATH, so it was downloaded.")
      else()
        string(CONCAT error_msg
          "GTest was not found in your PATH and could not be established through "
          "a download. Try specifying GTest_DIR or altering CMAKE_PREFIX_PATH to "
          "point to a candidate GTest installation base directory."
        )
        message(FATAL_ERROR ${error_msg})
      endif()
    endif()
  endif()
endmacro()
