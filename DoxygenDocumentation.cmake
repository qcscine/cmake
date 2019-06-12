#
# This file is licensed under the 3-clause BSD license.
# Copyright ETH Zurich, Laboratory for Physical Chemistry, Reiher Group.
# See LICENSE.txt for details.
#
function(scine_component_documentation)
  # Eliminate DOXYGEN_INPUT if present to avoid clash with FindDoxygen.cmake
  if(NOT DOXYGEN_INPUT)
    set(SCINE_DOXYGEN_INPUT
      ${CMAKE_CURRENT_SOURCE_DIR}/src
      ${CMAKE_CURRENT_SOURCE_DIR}/cmake
      ${CMAKE_CURRENT_SOURCE_DIR}/README.md
    )
    # Add SCINE documentation if available
    if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/doc)
      set(SCINE_DOXYGEN_INPUT ${SCINE_DOXYGEN_INPUT} 
                              ${CMAKE_CURRENT_SOURCE_DIR}/doc/layout
                              ${CMAKE_CURRENT_SOURCE_DIR}/doc/boost-dll-tutorial/tutorial.dox
                              ${CMAKE_CURRENT_SOURCE_DIR}/doc/structure/structure.dox)
    endif()
  else()
    set(SCINE_DOXYGEN_INPUT ${DOXYGEN_INPUT})
    unset(DOXYGEN_INPUT)
  endif()

  # Find Doxygen and abort if not found
  find_package(Doxygen QUIET)
  if(NOT Doxygen_FOUND)
    message(STATUS "Doxygen not found - Documentation for ${PROJECT_NAME} will not be built.")
    return()
  endif()

  # SCINE default Doxygen settings
  if(NOT DOXYGEN_PROJECT_NAME)
    set(DOXYGEN_PROJECT_NAME "Scine::${PROJECT_NAME}")
  endif()
  if(NOT DOXYGEN_PROJECT_DESCRIPTION)
    set(DOXYGEN_PROJECT_DESCRIPTION "${PROJECT_DESCRIPTION}")
  endif()
  if(NOT DOXYGEN_FULL_PATH_NAMES)
    set(DOXYGEN_FULL_PATH_NAMES YES)
  endif()
  if(NOT DOXYGEN_BUILTIN_STL_SUPPORT)
    set(DOXYGEN_BUILTIN_STL_SUPPORT YES)
  endif()
  if(NOT DOXYGEN_DISTRIBUTE_GROUP_DOC)
    set(DOXYGEN_DISTRIBUTE_GROUP_DOC YES)
  endif()
  if(NOT DOXYGEN_WARN_NO_PARAMDOC)
    set(DOXYGEN_WARN_NO_PARAMDOC YES)
  endif()
  if(NOT DOXYGEN_WARN_LOGFILE)
    set(DOXYGEN_WARN_LOGFILE "doxygen_warnings.txt")
  endif()
  if(NOT DOXYGEN_FILE_PATTERNS)
    set(DOXYGEN_FILE_PATTERNS *.cpp *.hpp *.hxx *.h *.dox *.py)
  endif()
  if(NOT DOXYGEN_RECURSIVE)
    set(DOXYGEN_RECURSIVE YES)
  endif()
  if(NOT DOXYGEN_USE_MDFILE_AS_MAINPAGE)
    set(DOXYGEN_USE_MDFILE_AS_MAINPAGE "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
  endif()
  if(NOT DOXYGEN_GENERATE_TREEVIEW)
    set(DOXYGEN_GENERATE_TREEVIEW YES)
  endif()
  if(NOT DOXYGEN_USE_MATHJAX)
    set(DOXYGEN_USE_MATHJAX YES)
  endif()
  if(NOT DOXYGEN_GENERATE_LATEX)
    set(DOXYGEN_GENERATE_LATEX NO)
  endif()
  if(NOT DOXYGEN_UML_LOOK)
    set(DOXYGEN_UML_LOOK YES)
  endif()
  if(NOT DOXYGEN_TEMPLATE_RELATIONS)
    set(DOXYGEN_TEMPLATE_RELATIONS YES)
  endif()
  if(NOT DOXYGEN_IMAGE_PATH)
    set(DOXYGEN_IMAGE_PATH "${PROJECT_SOURCE_DIR}/doc/resources")
  endif()
  

  # Add the target
  doxygen_add_docs(${PROJECT_NAME}Documentation ${SCINE_DOXYGEN_INPUT})

  # Install the result of the target
  #install(
  #  DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/html
  #  DESTINATION share/Scine/${PROJECT_NAME}/
  #)
endfunction()
