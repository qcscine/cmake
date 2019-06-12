#
# This file is licensed under the 3-clause BSD license.
# Copyright ETH Zurich, Laboratory for Physical Chemistry, Reiher Group.
# See LICENSE.txt for details.
#
function(import_qwt)
  # If the target already exists, do nothing
  if(TARGET Qwt::Qwt)
    return()
  endif()

  # Try to find the package locally
  find_package(Qwt QUIET)
  if(TARGET Qwt::Qwt)
    message(STATUS "Qwt::Qwt found locally at ${Scine_DIR}")
    return()
  endif()

  # Download it instead
  include(DownloadProject)
  download_project(PROJ qwt
    GIT_REPOSITORY      git@gitlab.chab.ethz.ch:scine/qwt.git
    GIT_TAG             v6.1.3
    UPDATE_DISCONNECTED 1
    QUIET
  )
  add_subdirectory(${qwt_SOURCE_DIR} ${qwt_BINARY_DIR} EXCLUDE_FROM_ALL)

  # Final check if all went well
  if(TARGET Qwt::Qwt)
    message(STATUS
      "Qwt::Qwt was not found in your PATH, so it was downloaded."
    )
  else()
    string(CONCAT error_msg
      "Qwt::Qwt was not found in your PATH and could not be established "
      "through a download. Try specifying Qwt_DIR or altering "
      "CMAKE_PREFIX_PATH to point to a candidate Qwt installation base "
      "directory."
    )
    message(FATAL_ERROR ${error_msg})
  endif()

endfunction()
