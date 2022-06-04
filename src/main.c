#include <psp2/kernel/threadmgr.h>
#include <psp2/kernel/processmgr.h>
#include <stdlib.h>
#include <assert.h>
#include <stdio.h>
#include "debugScreen.h"


#define printf psvDebugScreenPrintf



//LWDR(Lightweight D runtime backend stuff) Do not remove those lines. Please find another way to support a better assertion
void* rtosbackend_heapalloc(unsigned int sz){return malloc(sz);}
void rtosbackend_heapfreealloc(void* ptr){free(ptr);}
void rtosbackend_assert(char* file, uint line){assert(0);}
void rtosbackend_assertmsg(char* msg, char* file, uint line){assert(0);}
void rtosbackend_arrayBoundFailure(char* file, uint line){assert(0);}


extern char* getStringFromD();
float getFloatFromD();
int getDynamicArraySum();

int main(int argc, char *argv[]) {
	psvDebugScreenInit();
	//Test cases from D

	printf("Hello, world!\n %s %f %d", 
		getStringFromD(), 
		getFloatFromD(),
		getDynamicArraySum()
	);
	
	sceKernelDelayThread(3*1000000); // Wait for 3 seconds
	sceKernelExitProcess(0);
	return 0;
}
