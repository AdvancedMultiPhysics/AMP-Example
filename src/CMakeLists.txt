# Configure the files in this directory as a library named testlib
BEGIN_PACKAGE_CONFIG( testlib )
INSTALL_EXAMPLE_TARGET( testlib )

# Add the test subfolder
ADD_SUBDIRECTORY(test)


