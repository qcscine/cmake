#
# This file is licensed under the 3-clause BSD license.
# Copyright ETH Zurich, Laboratory for Physical Chemistry, Reiher Group.
# See LICENSE.txt for details.
#

if(Scine_FIND_COMPONENTS)
  foreach(Component ${Scine_FIND_COMPONENTS})
    # if Scine::${Component} does not exist, try to import it
    if(NOT TARGET Scine::${Component})
      message(STATUS "Trying to include Scine Component ${Component} locally.")
      include(${CMAKE_CURRENT_LIST_DIR}/${Component}/${Component}Config.cmake OPTIONAL)
    endif()

    # if Scine::${Component} still does not exist, set it to not found
    if(NOT TARGET Scine::${Component})
      set(Scine_${Component}_FOUND 0)
      if(Scine_FIND_REQUIRED_${Component})
        message(FATAL_ERROR "Scine ${Component} not available.")
      else()
        message(STATUS "Scine ${Component} not available locally.")
      endif()
    else()
      set(Scine_${Component}_FOUND 1)
    endif()
  endforeach()
else()
  # By default, include Scine
  include(${CMAKE_CURRENT_LIST_DIR}/Scine/ScineConfig.cmake)
endif()
