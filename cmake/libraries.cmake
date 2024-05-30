# Macro to configure specific options for this project
MACRO ( CONFIGURE_THIS )
    # Put user code here
    NULL_USE( ENABLE_GCOV )
    SET( LINK_LIBRARIES ${LINK_LIBRARIES} ${AMP_LIBS} )
ENDMACRO ()

