#include <psp2/kernel/threadmgr.h>
#include <psp2/kernel/processmgr.h>
#include <stdlib.h>
#include <assert.h>
#include <stdio.h>
#include "debugScreen.h"


#define printf psvDebugScreenPrintf


typedef struct IntDynamicArray
{
	int* values;
	unsigned long long length;
} IntDynamicArray;


//LWDR(Lightweight D runtime backend stuff) Do not remove those lines. Please find another way to support a better assertion
void* rtosbackend_heapalloc(unsigned int sz){return malloc(sz);}
void rtosbackend_heapfreealloc(void* ptr){free(ptr);}
void rtosbackend_assert(char* file, uint line){assert(0);}
void rtosbackend_assertmsg(char* msg, char* file, uint line){assert(0);}
void rtosbackend_arrayBoundFailure(char* file, uint line){assert(0);}


extern char* getStringFromD();
extern void* createTest();
extern void checkDynamicCast(void* _TestInstance);
extern float getFloatFromD();
extern int getDynamicArraySum();
extern IntDynamicArray intDynamicArrayFromD();

int main(int argc, char *argv[]) {
	psvDebugScreenInit();
	//Test cases from D

	printf("Hello, world!\n %s %f %d", 
		getStringFromD(), 
		getFloatFromD(),
		getDynamicArraySum()
	);
	void* _TestInstance = createTest();
	checkDynamicCast(_TestInstance);

	printf("\nArray Test: ");
	IntDynamicArray dArray = intDynamicArrayFromD();
	for(int i = 0; i < dArray.length; i++)
		printf("%d ", dArray.values[i]);
	printf("\n");

	
	sceKernelDelayThread(3*1000000); // Wait for 3 seconds
	sceKernelExitProcess(0);
	return 0;
}
