#
# This file is licensed under the 3-clause BSD license.
# Copyright ETH Zurich, Laboratory for Physical Chemistry, Reiher Group.
# See LICENSE.txt for details.
#
function(import_utils_os)
  # If the target already exists, do nothing
  if(TARGET Scine::UtilsOS)
    return()
  endif()

  # Try to find the package locally
  find_package(Scine COMPONENTS UtilsOS QUIET)
  if(TARGET Scine::UtilsOS)
    message(STATUS "Scine::UtilsOS found locally at ${Scine_DIR}")
    return()
  endif()

  # Download it instead
  include(DownloadProject)
  download_project(
    PROJ scine-utils-os
    GIT_REPOSITORY https://github.com/qcscine/utilities.git
    GIT_TAG        1.0.1
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
endfunction()
