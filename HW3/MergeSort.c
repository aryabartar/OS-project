#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h> 
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/wait.h>
#include<time.h> 


void fillData(int a[], int);
void mergeSort (int *, int l , int r);
void merge(int array[], int , int , int );

int main()
{
    const int ARRAY_SIZE = 5;
    

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

    mergeSort(array ,0 , ARRAY_SIZE-1);


    for (int i = 0; i < ARRAY_SIZE ; i++){
        printf("%d ", array[i]);
    }

    //detach from shared memory
    shmdt(array);

    // destroy the shared memory 
    shmctl(shmid,IPC_RMID,NULL); 


    return 0;
}

void fillData(int a[], int len) 
{ 
    srand(time(0));
	// Create random arrays 
    int i; 
	for (i=0; i<len; i++) 
		a[i] = rand()%300; 

	return; 
} 

void mergeSort (int *array, int l , int r)
{
    int array_length = r-l+1;
    printf("l is %d| r is %d\n" , l , r);
    if (r <= l )
    {
        return; 
    }

    int lfork_status, rfork_status;
    lfork_status = fork();
    printf ("Left forked\n");

    if (lfork_status < 0)
    {
        perror("Error while making left fork.");
        exit(-1);
    } 
    else if (lfork_status == 0) //this is child
    {
        mergeSort(array, l , l+array_length/2 -1);
        exit(0);
    }
    else  // parent 
    {
        rfork_status = fork();
        printf ("Right forked\n");

        if (rfork_status < 0)
        {
            perror("Error while making right fork.");
            exit(-1);
        } 
        else if (rfork_status == 0) //this is child
        {
            mergeSort(array, l+array_length/2 , r);
            exit(0);
        }
    }

	int status; 

    // Wait for child processes to finish 
	waitpid(lfork_status, 0, 0); 
	waitpid(rfork_status, 0, 0); 
    
    merge(array , l , l+array_length/2 -1 , r);
}

void merge(int arr[], int l, int m, int r) 
{ 
    int i, j, k; 
    int n1 = m - l + 1; 
    int n2 =  r - m; 
  
    int L[n1], R[n2]; 
  
    for (i = 0; i < n1; i++) 
        L[i] = arr[l + i]; 
    for (j = 0; j < n2; j++) 
        R[j] = arr[m + 1+ j]; 
  
    i = 0; // Initial index of first subarray 
    j = 0; // Initial index of second subarray 
    k = l; // Initial index of merged subarray 
    while (i < n1 && j < n2) 
    { 
        if (L[i] <= R[j]) 
        { 
            arr[k] = L[i]; 
            i++; 
        } 
        else
        { 
            arr[k] = R[j]; 
            j++; 
        } 
        k++; 
    } 
  
    while (i < n1) 
    { 
        arr[k] = L[i]; 
        i++; 
        k++; 
    } 

    while (j < n2) 
    { 
        arr[k] = R[j]; 
        j++; 
        k++; 
    } 
    printf("Merge is eunning!\n");
} 