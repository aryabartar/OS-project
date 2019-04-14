#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/wait.h>

void fillData(int a[], int);
void mergeSort(int *, int l, int r);
void merge(int array[], int, int, int);
void printArray (int array[] , int size);

int M = 100;

int main(int argc, char *argv[])
{
    clock_t begin = clock();

    const int ARRAY_SIZE = 10000;

    int shmid;
    key_t key;

    /* make the key: */
    if ((key = ftok("MergeSort.c", 65)) == -1) /*Here the file must exist */
    {
        perror("ftok");
        exit(1);
    }

    /*  create the segment: */
    if ((shmid = shmget(key, ARRAY_SIZE * sizeof(int), 0666 | IPC_CREAT)) == -1)
    {
        perror("shmget");
        exit(1);
    }

    // shmat to attach to shared
    int *array = (int *)shmat(shmid, (void *)0, 0);

    fillData(array, ARRAY_SIZE);

    mergeSort(array, 0, ARRAY_SIZE - 1);

    printArray(array , ARRAY_SIZE);

    //detach from shared
    shmdt(array);

    // destroy the shared
    shmctl(shmid, IPC_RMID, NULL);

    clock_t end = clock();
    double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
    printf("\nTotal run time is: %f \n", time_spent);
    return 0;
}

void printArray (int array[] , int size){
    for (int i = 0; i < size; i++)
    {
        printf("%d ", array[i]);
    }
}
void fillData(int a[], int len)
{
    srand(time(0));
    // Create random arrays
    int i;
    for (i = 0; i < len; i++)
        a[i] = rand() % 1000;

    return;
}

void merge(int arr[], int l, int m, int r)
{
    int i, j, k;
    int n1 = m - l + 1;
    int n2 = r - m;

    int L[n1], R[n2];

    for (i = 0; i < n1; i++)
        L[i] = arr[l + i];
    for (j = 0; j < n2; j++)
        R[j] = arr[m + 1 + j];

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
}

void mergeSort(int *array, int l, int r)
{
    int array_length = r - l + 1;
    if (r <= l)
    {
        return;
    }

    if (array_length < M)
    {
        mergeSort(array, l, l + array_length / 2 - 1);
        mergeSort(array, l + array_length / 2, r);
    }
    else
    {
        int lfork_status, rfork_status;
        lfork_status = fork();

        if (lfork_status == 0) //this is child
        {
            mergeSort(array, l, l + array_length / 2 - 1);
            exit(0);
        }
        else // parent
        {
            rfork_status = fork();

            if (rfork_status == 0) //this is child
            {
                mergeSort(array, l + array_length / 2, r);
                exit(0);
            }
        }

        waitpid(lfork_status, 0, 0);
        waitpid(rfork_status, 0, 0);
    }
    merge(array, l, l + array_length / 2 - 1, r);
}
