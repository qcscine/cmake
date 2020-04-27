#
# This file is licensed under the 3-clause BSD license.
# Copyright ETH Zurich, Laboratory for Physical Chemistry, Reiher Group.
# See LICENSE.txt for details.
#
macro(import_utils_os)
  # If the target already exists, do nothing
  if(NOT TARGET Scine::UtilsOS)
    # Try to find the package locally
    find_package(Scine OPTIONAL_COMPONENTS UtilsOS QUIET)
    if(TARGET Scine::UtilsOS)
      message(STATUS "Scine::UtilsOS found locally at ${Scine_DIR}")
    else()
      # Download it instead
      include(DownloadProject)
      download_project(
        PROJ scine-utils-os
        GIT_REPOSITORY https://github.com/qcscine/utilities.git
        GIT_TAG        2.0.0
        QUIET
      )
      # Note: Options defined in the project calling this function override default
      # option values specified in the imported project.
      add_subdirectory(${scine-utils-os_SOURCE_DIR} ${scine-utils-os_BINARY_DIR})

      # Final check if all went well
      if(TARGET Scine::UtilsOS)
        message(STATUS
          "Scine::UtilsOS was not found in your PATH, so it was downloaded."
        )
      else()
        string(CONCAT error_msg
          "Scine::UtilsOS was not found in your PATH and could not be established "
          "through a download. Try specifying Scine_DIR or altering "
          "CMAKE_PREFIX_PATH to point to a candidate Scine installation base "
          "directory."
        )
        message(FATAL_ERROR ${error_msg})
      endif()
    endif()
  endif()
endmacro()
