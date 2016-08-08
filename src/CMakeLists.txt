# Configure the files in this directory as a library named testlib
BEGIN_PACKAGE_CONFIG( testlib )
INSTALL_EXAMPLE_TARGET( testlib )


# Install main project library (all sub libraries should be configured prior to this call)
INSTALL_PROJ_LIB()


# Add the test subfolder
ADD_SUBDIRECTORY(test)


