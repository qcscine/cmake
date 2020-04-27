#
# This file is licensed under the 3-clause BSD license.
# Copyright ETH Zurich, Laboratory for Physical Chemistry, Reiher Group.
# See LICENSE.txt for details.
#
macro(import_cereal)
  # If the target already exists, do nothing
  if (NOT TARGET cereal::cereal)
    # Download it instead
    include(DownloadProject)
    download_project(PROJ                cereal
                     GIT_REPOSITORY      https://gitlab.chab.ethz.ch/scine/cereal.git
                     GIT_TAG             v1.2.2
                     QUIET
                     UPDATE_DISCONNECTED 1
                     )
    set(JUST_INSTALL_CEREAL ON CACHE BOOL "") # Prevent cereal from building tests
    add_subdirectory(${cereal_SOURCE_DIR} ${cereal_BINARY_DIR})
    add_library(cereal::cereal ALIAS cereal)

    # Final check if all went well
    if(TARGET cereal::cereal)
      message(STATUS "Cereal was not found in your PATH, so it was downloaded.")
    else()
      string(CONCAT error_msg
        "Cereal was not found in your PATH and could not be established through "
        "a download. Try specifying cereal_DIR or altering CMAKE_PREFIX_PATH to "
        "point to a candidate cereal installation base directory."
      )
      message(FATAL_ERROR ${error_msg})
    endif()
  endif()
endmacro()
