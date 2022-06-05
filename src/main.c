#include <psp2/kernel/threadmgr.h>
#include <psp2/kernel/processmgr.h>
#include <stdlib.h>
#include <assert.h>
#include <stdio.h>
#include <pthread.h>
#include "debugScreen.h"
#include "tests.h"
#define printf psvDebugScreenPrintf

//This function is called from D's main
int _Cmain(int argc, char* argv)
{
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
	if(dArray.length == 0)
		printf("static this() is not yet implemented");
	printf("\n");

	sceKernelDelayThread(3*1000000); // Wait for 3 seconds
	sceKernelExitProcess(0);
	return 0;
}
