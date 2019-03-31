#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>

void fillData(int a[], int);
void mergeSort (int *, int l , int r);

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

    fillData(array, ARRAY_SIZE) ;
    printf("%d\n%d\n%d\n" , array[0], array[100] , array[999]);

    //detach from shared memory
    shmdt(array);

    // destroy the shared memory 
    shmctl(shmid,IPC_RMID,NULL); 

    printf("%d\n" , shmid);
    return 0;
}

void fillData(int a[], int len) 
{ 
	// Create random arrays 
	int i; 
	for (i=0; i<len; i++) 
		a[i] = rand()%300; 
	return; 
} 

void mergeSort (int *array, int l , int r)
{
    int array_length = r-l+1;
    
    if (r == l)
    {
        return; 
    }

    int lfork_status, rfork_status;
    lfork_status = fork();

    if (lfork_status < 0)
    {
        perror("Error while making left fork.");
        exit(-1);
    } 
    else if (lfork_status == 0) 
    {
        mergeSort(array, l , array_length/2);

    }

    
}