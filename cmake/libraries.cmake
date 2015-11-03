# Macro to load AMP
MACRO( CONFIGURE_AMP )
    VERIFY_PATH( ${AMP_DIRECTORY} )
    INCLUDE( ${AMP_DIRECTORY}/amp.cmake )
    SET( GLOBAL_AMP_LIBS )
    SET( TMP_LIB nolib-NOTFOUND )	# For some strage reason we need to set this to not-found before we use it for the first time
    FOREACH ( amp_lib ${AMP_LIBS} )
        IF ( ( ${amp_lib} STREQUAL "-Wl,--whole-archive" ) OR ( ${amp_lib} STREQUAL "-Wl,--no-whole-archive" ) )
            # This is a special case for adding the whole archive for materials
            SET( GLOBAL_AMP_LIBS ${GLOBAL_AMP_LIBS} ${amp_lib} )
        ELSE()
            # Search the given path for the AMP library, and add it to the global list
            FIND_LIBRARY( TMP_LIB  NAMES ${amp_lib}  PATHS ${AMP_DIRECTORY}/lib  NO_DEFAULT_PATH )
            IF ( NOT TMP_LIB )
                MESSAGE ( FATAL_ERROR "AMP library (${amp_lib}) not found in ${AMP_DIRECTORY}/lib" )
            ENDIF()
            SET( GLOBAL_AMP_LIBS ${GLOBAL_AMP_LIBS} ${TMP_LIB} )
            # We need to set the TMP_LIB to not-found for the next iteration to work
            SET( TMP_LIB ${amp_lib}-NOTFOUND )
        ENDIF()
    ENDFOREACH()
    SET( AMP_LIBS ${GLOBAL_AMP_LIBS} )
    SET( AMP_SOURCE_DIR "${AMP_DIRECTORY}" )
    SET( AMP_CONFIGURED_THROUGH_INSTALL 1 )
    UNSET( GLOBAL_AMP_LIBS )
    MESSAGE( "AMP found:" )
    MESSAGE( ${CMAKE_CXX_FLAGS} )
    MESSAGE( ${AMP_LIBS} )
ENDMACRO()


# Macro to configure specific options for this project
MACRO ( CONFIGURE_THIS )
    # Put user code here
    SET( LINK_LIBRARIES ${LINK_LIBRARIES} ${AMP_LIBS} )
ENDMACRO ()

