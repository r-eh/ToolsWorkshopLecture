#include <mpi.h>
#include <stdio.h>

int main(int argc, char** argv) {
    // Initialize the MPI environment
    MPI_Init(&argc, &argv);

    MPI_Comm world_comm;
    MPI_Comm_dup(MPI_COMM_WORLD, &world_comm);

    // Get the number of processes
    int world_size;
    MPI_Comm_size(world_comm, &world_size);

    // Get the rank of the process
    int world_rank;
    MPI_Comm_rank(world_comm, &world_rank);

    // Get the name of the processor
    char processor_name[MPI_MAX_PROCESSOR_NAME];
    int name_len;
    MPI_Get_processor_name(processor_name, &name_len);

    // Print off a hello world message
    printf("Hello world from processor %s, rank %d out of %d processors\n",
           processor_name, world_rank, world_size);

    // Finalize the MPI environment.
    MPI_Finalize();
}