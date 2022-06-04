#include <psp2/kernel/threadmgr.h>
#include <psp2/kernel/processmgr.h>
#include <stdio.h>

#include "debugScreen.h"


#define printf psvDebugScreenPrintf

extern char* strFromD();

int main(int argc, char *argv[]) {
	psvDebugScreenInit();
	//printf("Hello, world!\n %s", strFromD());
	
	sceKernelDelayThread(3*1000000); // Wait for 3 seconds
	sceKernelExitProcess(0);
	return 0;
}
