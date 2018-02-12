#include "print.h"
#include "AMP/utils/AMP_MPI.h"

#include <iostream>

void print_hello_world()
{
    AMP::AMP_MPI comm( AMP_COMM_WORLD );
    std::cout << "Rank " << comm.getRank() << ":  Hello world\n";
}
