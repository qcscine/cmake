#
# This file is licensed under the 3-clause BSD license.
# Copyright ETH Zurich, Laboratory for Physical Chemistry, Reiher Group.
# See LICENSE.txt for details.
#
function(scine_import)
  set(options "")
  set(oneValueArgs COMPONENT GIT_REPOSITORY GIT_TAG)
  set(multiValueArgs "")
  cmake_parse_arguments(SCINE_IMPORT
    "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN}
  )

  # If the target already exists, do nothing
  if(TARGET Scine::${SCINE_IMPORT_COMPONENT})
    return()
  endif()

  # Try to find the package locally
  find_package(Scine COMPONENTS ${SCINE_IMPORT_COMPONENT} QUIET)
  if(TARGET Scine::${SCINE_IMPORT_COMPONENT})
    message(STATUS "Scine::${SCINE_IMPORT_COMPONENT} found at ${Scine_DIR}.")
    return()
  endif()

  # Download it instead
  include(DownloadProject)
  download_project(
    PROJ scine-${SCINE_IMPORT_COMPONENT}
    GIT_REPOSITORY ${SCINE_IMPORT_GIT_REPOSITORY}
    GIT_TAG ${SCINE_IMPORT_GIT_TAG}
    QUIET
  )
  # Note: Options defined in the project calling this function override default
  # option values specified in the imported project.
  add_subdirectory(
    ${scine-${SCINE_IMPORT_COMPONENT}_SOURCE_DIR}
    ${scine-${SCINE_IMPORT_COMPONENT}_BINARY_DIR}
  )

  # Final check if all went well
  if(TARGET Scine::${SCINE_IMPORT_COMPONENT})
    message(STATUS
      "Scine::${SCINE_IMPORT_COMPONENT} not found locally; downloaded instead."
    )
  else()
    string(CONCAT error_msg
      "Scine::${SCINE_IMPORT_COMPONENT} was not found in your PATH and could "
      "not be established through a download. Try specifying Scine_DIR or "
      "altering CMAKE_PREFIX_PATH to point to a candidate Scine installation "
      "base directory."
    )
    message(FATAL_ERROR ${error_msg})
  endif()
endfunction()
