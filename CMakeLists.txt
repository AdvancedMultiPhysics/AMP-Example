# Set some CMake properties    
CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
CMAKE_POLICY(SET CMP0004 OLD)
IF ( ${CMAKE_MAJOR_VERSION} EQUAL 3 )
    CMAKE_POLICY(SET CMP0026 OLD)
ENDIF()


# Load the AMP variables (we need to load the compilers before doing anything)
IF ( NOT AMP_DIRECTORY )
    MESSAGE( FATAL_ERROR "PLease set: AMP_DIRECTORY" )
ELSEIF ( NOT EXISTS "${AMP_DIRECTORY}/amp.cmake" )
    MESSAGE( FATAL_ERROR "${AMP_DIRECTORY}/amp.cmake does not exist, has AMP been installed?" )
ENDIF()
INCLUDE( "${AMP_DIRECTORY}/amp.cmake" )


# Set the project name.  This will also control the names of the macros (ADD_PROJ_TEST, etc).
SET( PROJ EXAMPLE )


# Configure the project and enable any additional languages
MESSAGE("===================")
MESSAGE("Configuring ${PROJ}")
MESSAGE("===================")
PROJECT( ${PROJ} )
#ENABLE_LANGUAGE(Fortran)
IF( PREFIX )
    SET( ${PROJ}_INSTALL_DIR ${PREFIX} )
ELSEIF( NOT ATOMIC_INSTALL_DIR )
    SET( ${PROJ}_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR} )
ENDIF()


# Call the cmake file from the TPL builder (if used) to add any third party libraries that AMP may not be aware of.
IF ( TPL_DIRECTORY )
    INCLUDE( "${TPL_DIRECTORY}/TPLs.cmake" )
ENDIF()


# Set CMake include files
INCLUDE( CheckIncludeFile )
INCLUDE( "${AMP_DIRECTORY}/cmake/macros.cmake" )
INCLUDE( "${CMAKE_CURRENT_SOURCE_DIR}/cmake/libraries.cmake" )


# Get the repository revision
#WRITE_REPO_VERSION( "${${PROJ}_INSTALL_DIR}/include/Version.h" )


# Set testing paramaters
ENABLE_TESTING()
INCLUDE(CTest)


# Create custom targets for build-test, check, and distclean
ADD_CUSTOM_TARGET( build-test )
ADD_CUSTOM_TARGET( check COMMAND  make test  )
ADD_DISTCLEAN( src )


# Add some directories to include
INCLUDE_DIRECTORIES( "${${PROJ}_INSTALL_DIR}/include" )


# Configure libraries
CONFIGURE_AMP()
CONFIGURE_THIS()


# Create the target for documentation
ADD_CUSTOM_TARGET( doc )
ADD_CUSTOM_TARGET( latex_docs )
IF ( USE_EXT_DOXYGEN )
    SET( DOXYFILE_IN ${AMP_SOURCE}/doxygen/Doxyfile.in)
    SET( DOXY_HEADER_FILE ${AMP_SOURCE}/doxygen/html/header.html )
    SET( DOXY_FOOTER_FILE ${AMP_SOURCE}/doxygen/html/footer.html )
    SET( DOXYFILE_OUTPUT_DIR ${${PROJ}_INSTALL_DIR}/doc/ )
    SET( DOXYFILE_SRC_HTML_DIR ${AMP_SOURCE}/doxygen/html )
    SET( DOXYFILE_SOURCE_DIR ${${PROJ}_SOURCE_DIR}/src )
    SET( DOXYFILE_EXTRA_SOURCES ${AMP_SOURCE}/src )
    SET( DOXYFILE_EXTRA_EXCLUDE ${AMP_SOURCE}/src/DoxygenMainpage.h )
    SET( REL_PACKAGE_HTML "" )
    SET( DOXYGEN_MACROS "${DOXYGEN_MACROS}" )
    MESSAGE("DOXYGEN_MACROS = ${DOXYGEN_MACROS}")
    INCLUDE(cmake/UseDoxygen.cmake)
ENDIF()


# Set project libraries (order matters)
SET( EXAMPLE_LIBS  testlib )


# Add the src directory
SET( EXCLUDE_TESTS_FROM_ALL 0 )
ADD_SUBDIRECTORY( src )



