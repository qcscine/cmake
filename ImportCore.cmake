#
# This file is licensed under the 3-clause BSD license.
# Copyright ETH Zurich, Laboratory for Physical Chemistry, Reiher Group.
# See LICENSE.txt for details.
#
macro(import_core)
  # If the target already exists, do nothing
  if(NOT TARGET Scine::Core)
    # Try to find the package locally
    find_package(Scine OPTIONAL_COMPONENTS Core QUIET)
    if(TARGET Scine::Core)
      message(STATUS "Scine::Core found locally at ${Scine_DIR}")
    else()
      # Download it instead
      include(DownloadProject)
      download_project(
        PROJ scine-core
        GIT_REPOSITORY      https://github.com/qcscine/core.git
        GIT_TAG             2.0.0
        QUIET
      )
      # Note: Options defined in the project calling this function override default
      # option values specified in the imported project.
      add_subdirectory(${scine-core_SOURCE_DIR} ${scine-core_BINARY_DIR})

      # Final check if all went well
      if(TARGET Scine::Core)
        message(STATUS
          "Scine::Core was not found in your PATH, so it was downloaded."
        )
      else()
        string(CONCAT error_msg
          "Scine::Core was not found in your PATH and could not be established "
          "through a download. Try specifying Scine_DIR or altering "
          "CMAKE_PREFIX_PATH to point to a candidate Scine installation base "
          "directory."
        )
        message(FATAL_ERROR ${error_msg})
      endif()
    endif()
  endif()
endmacro()
