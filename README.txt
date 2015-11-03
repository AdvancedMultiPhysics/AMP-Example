This is an example project that uses AMP as a library.  The build is based on CMake and automatically configures most of the compile options from the AMP install (debug, release, third party libraries, etc.).  To configure and build this project:
   cmake -D AMP_DIRECTORY:PATH="path to amp install" path_to_here
Note that the AMP directory should be the absolute path.  

There are several files/variables that developers should be aware of when modifying this example for their own application:

CMakeLists.txt
This is the main cmake file that is run by the user.  Most of the traditional cmake configuration (such as compilers, compile flags, etc will be obtained from the AMP installation.  The main role of this file is to read the AMP configuration and set any application specific libraries or flags.  The file is documented internally, but consists of loading AMP, setting the project, loading the libraries and flags, and adding the source/tests.
The lines that need to be changed for a new project are:
   17: SET( PROJ EXAMPLE ) - set the project name as desired
   46: comment or uncomment the version identification as desired
   67: configure the external libraries that AMP is not aware of
   91: set the libraries this project will create (used for linking the tests)
   95: add the appropriate directories, libraries, etc.

macros.cmake (located in the AMP install cmake folder)
This is a helper file that the user can utilize which contains macros/functions for adding libraries, tests, etc.

cmake/libraries.cmake
This is a helper file that contains information needed to add libraries.  Users can add their own libraries here.


