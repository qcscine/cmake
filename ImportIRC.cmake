#
# This file is licensed under the 3-clause BSD license.
# Copyright ETH Zurich, Laboratory for Physical Chemistry, Reiher Group.
# See LICENSE.txt for details.
#
macro(import_irc)
  # If the target already exists, do nothing
  if (LIBIRC_INCLUDE_DIR AND LIBIRC_EIGEN_MATRIX_PLUGIN)
    add_definitions(-DHAVE_EIGEN3)
    add_definitions(-DEIGEN_MATRIX_PLUGIN="${LIBIRC_EIGEN_MATRIX_PLUGIN}")
  else()
    # Download it instead
    include(DownloadProject)
    download_project(PROJ irc
      GIT_REPOSITORY      https://github.com/rmeli/irc.git
      GIT_TAG             939f7f7ea278de7e7777e0c9302048c67c186887
      UPDATE_DISCONNECTED 1
      QUIET
    )

    # set(LIBIRC_INCLUDE_DIR ${irc_SOURCE_DIR}/include)
    set(LIBIRC_INCLUDE_DIR ${irc_SOURCE_DIR}/include CACHE STRING "" FORCE)
    set(LIBIRC_EIGEN_MATRIX_PLUGIN "${irc_SOURCE_DIR}/external/eigen/plugins/Matrix_initializer_list.h" CACHE STRING "" FORCE)
    add_definitions(-DHAVE_EIGEN3)
    add_definitions(-DEIGEN_MATRIX_PLUGIN="${LIBIRC_EIGEN_MATRIX_PLUGIN}")

    # Final check if all went well
    if(LIBIRC_INCLUDE_DIR AND LIBIRC_EIGEN_MATRIX_PLUGIN)
      message(STATUS "IRC was not found in your PATH, so it was downloaded.")
    else()
      string(CONCAT error_msg
        "IRC was not found in your PATH and could not be established through "
        "a download. Try specifying irc_DIR or altering CMAKE_PREFIX_PATH to "
        "point to a candidate irc installation base directory."
      )
      message(FATAL_ERROR ${error_msg})
    endif()
  endif()
endmacro()
