#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>

int main()
{
    const int ARRAY_SIZE = 1000;
    

    int shmid;
    key_t key; 

    /* make the key: */
    if ((key = ftok("MergeSort.c",65)) == -1) /*Here the file must exist */ 
    {
        perror("ftok");
        exit(1);
    }

    /*  create the segment: */
    if ((shmid = shmget(key, ARRAY_SIZE * sizeof(int), 0666 | IPC_CREAT)) == -1) {
        perror("shmget");
        exit(1);
    }
    
    // shmat to attach to shared memory
    int *array = (int*) shmat(shmid,(void*)0,0);

    array[0] = 1;
    array[100] = 22;
    array[999] = 333;
    printf("%d\n%d\n%d\n" , array[0], array[100] , array[999]);

    //detach from shared memory
    shmdt(array);

    // destroy the shared memory 
    shmctl(shmid,IPC_RMID,NULL); 

    printf("%d\n" , shmid);
    return 0;
}