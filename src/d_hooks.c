
/**
 * For using D code, using the LWDR (LightWeight D Runtime) Those functions should be implemented to access several stuff as:
 * 
 * new Class()
 * destroy(classInstance)
 * array~= value (Append value)
 * array.length = 10 (Set dynamic array size)
 * Thread Local Storage (non __gshared data)
 * Class c = new SubClass(); (polymorphism)
 * cast(SubClass)classInstance is null (dynamic cast)
 * 
 * So, this file is pretty important. If you do not wish to integrate it, feel free to use betterC
 */

#include <stdlib.h>
#include <assert.h>
#include <pthread.h>

//LWDR(Lightweight D runtime backend stuff) Do not remove those lines. Please find another way to support a better assertion
void* rtosbackend_heapalloc(unsigned int sz){return malloc(sz);}
void rtosbackend_heapfreealloc(void* ptr){free(ptr);}
void rtosbackend_assert(char* file, uint line){assert(0);}
void rtosbackend_assertmsg(char* msg, char* file, uint line){assert(0);}
void rtosbackend_arrayBoundFailure(char* file, uint line){assert(0);}

// #define MAX_THREADS 32
// pthread_key_t tls_keys[MAX_THREADS];
// #define CHECK_CREATE_KEY(index) if((index) > MAX_THREADS || (index) < 0) \
// 									assert(0); \
// 								if(tls_keys[index] == NULL) \
// 									pthread_key_create(&tls_keys[index], NULL);



extern void* pte_osTlsGetValue(unsigned int index);
extern void pte_osTlsSetValue(unsigned int index, void* value);

void* rtosbackend_getTLSPointerCurrThread(int index)
{
	//CHECK_CREATE_KEY(index);
	// return pthread_getspecific(tls_keys[index]);
	//SCE -> return sceKernelGetTLSAddr(index);
	return pte_osTlsGetValue(index);
}
void rtosbackend_setTLSPointerCurrThread(void* value, int index)
{
	// CHECK_CREATE_KEY(index);
	// pthread_setspecific(tls_keys[index], value);
	pte_osTlsSetValue(index, value);
}
