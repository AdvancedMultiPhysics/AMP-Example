#include "utils/AMPManager.h"
#include "print.h"


int main(int argc, char *argv[])
{
    AMP::AMPManager::startup(argc,argv);
    print_hello_world();
    AMP::AMPManager::shutdown();
    return 0;
}
