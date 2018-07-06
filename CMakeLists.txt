# Set some CMake properties    
CMAKE_MINIMUM_REQUIRED(VERSION 3.9)


# Print banner
MESSAGE( "===========================" )
MESSAGE( "Configuring Example Project" )
MESSAGE( "===========================" )


# Set the project name
SET( PROJ EXAMPLE )             # Set the project name for CMake
SET( ${PROJ}_LIB example )      # Set the final library name
SET( ${PROJ}_INC )              # Set an optional subfolder for includes (e.g. include/name/...)


# Initialize the project (should disable langagues that the TPL builder will enable)
PROJECT( ${PROJ} LANGUAGES )


# Prevent users from building in place
IF ("${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}" )
    MESSAGE( FATAL_ERROR "Building code in place is a bad idea" )
ENDIF()


# Set source/install paths
SET( ${PROJ}_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src" )
SET( ${PROJ}_BUILD_DIR  "${CMAKE_CURRENT_BINARY_DIR}" )
IF( ${PROJ}_INSTALL_DIR )
    SET( ${PROJ}_INSTALL_DIR "${${PROJ}_INSTALL_DIR}" )
ELSEIF( NOT ${PROJ}_INSTALL_DIR )
    SET( ${PROJ}_INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}" )
ENDIF()
INCLUDE_DIRECTORIES( "${${PROJ}_INSTALL_DIR}/include" )


# Load AMP and extra TPLs
IF ( NOT AMP_DIRECTORY )
  MESSAGE( FATAL_ERROR "Please set: AMP_DIRECTORY" )
ENDIF()
SET( CMAKE_MODULE_PATH "${AMP_DIRECTORY}" ${CMAKE_MODULE_PATH} )
FIND_PACKAGE( AMP )
MESSAGE("AMP Found")
MESSAGE("  Include Paths: ${AMP_INCLUDE_DIRS}")
MESSAGE("  Libraries: ${AMP_LIBRARIES}")
CONFIGURE_LINE_COVERAGE()


# Include the TPL inclde paths
INCLUDE_DIRECTORIES( ${AMP_INCLUDE_DIRS} )


# Get the repository revision
WRITE_REPO_VERSION( )


# Set testing paramaters
ENABLE_TESTING()
INCLUDE(CTest)


# Create custom targets for build-test, check, and distclean
ADD_CUSTOM_TARGET( build-test )
ADD_CUSTOM_TARGET( check COMMAND  make test  )
ADD_DISTCLEAN( src libexample.* )


# Configure libraries
INCLUDE( "${CMAKE_CURRENT_SOURCE_DIR}/cmake/libraries.cmake" )
CONFIGURE_THIS()


# Set the external library link list
SET( EXTERNAL_LIBS ${EXTERNAL_LIBS} ${AMP_LIBRARIES} )


# Set a macro to add serial, 2 processor, and 4 processor tests
MACRO( ADD_EXAMPLE_TEST_1_2_4 EXENAME ${ARGN} )
    ADD_EXAMPLE_TEST( ${EXENAME} ${ARGN} )
    ADD_EXAMPLE_TEST_PARALLEL( ${EXENAME} 2 ${ARGN} )
    ADD_EXAMPLE_TEST_PARALLEL( ${EXENAME} 4 ${ARGN} )
ENDMACRO()


# Create the target for documentation
ADD_CUSTOM_TARGET( doc )
ADD_CUSTOM_TARGET( latex_docs )
ADD_DEPENDENCIES( doc latex_docs )
FILE( MAKE_DIRECTORY "${${PROJ}_INSTALL_DIR}/doc" )
IF ( USE_EXT_DOXYGEN )
    SET( DOXYFILE_LATEX NO )
    SET( DOXYFILE_IN "${${PROJ}_SOURCE_DIR}/doxygen/Doxyfile.in" )
    SET( DOXY_HEADER_FILE "${${PROJ}_SOURCE_DIR}/doxygen/html/header.html" )
    SET( DOXY_FOOTER_FILE "${${PROJ}_SOURCE_DIR}/doxygen/html/footer.html" )
    SET( DOXYFILE_OUTPUT_DIR "${${PROJ}_INSTALL_DIR}/doc" )
    SET( DOXYFILE_SRC_HTML_DIR "${${PROJ}_SOURCE_DIR}/doxygen/html" )
    SET( DOXYFILE_SOURCE_DIR "${${PROJ}_SOURCE_DIR}" )
    SET( DOXYFILE_EXTRA_SOURCES ${AMP_SOURCE}/src )
    SET( DOXYFILE_EXTRA_EXCLUDE ${AMP_SOURCE}/src/DoxygenMainpage.h )
    SET( REL_PACKAGE_HTML "" )
    SET( DOXYGEN_MACROS "${DOXYGEN_MACROS}" )
    MESSAGE("DOXYGEN_MACROS = ${DOXYGEN_MACROS}")
    INCLUDE(cmake/UseDoxygen.cmake)
ENDIF()


# Add the src directory
SET( EXCLUDE_TESTS_FROM_ALL 0 )
ADD_SUBDIRECTORY( src )


# Add the cppcheck tests
SET( CPPCHECK_TIMEOUT 700 )
SET( CPPCHECK_INCLUDE "-I${TIMER_INCLUDE}" "-I${AMP_DIRECTORY}/include" "-I${${PROJ}_INSTALL_DIR}/include" )
FIND_PACKAGE( Cppcheck )


# Add the cppclean tests
SET( CPPCLEAN_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}" )
FIND_PACKAGE( Cppclean )

