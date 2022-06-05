extern(C) extern void psvDebugScreenPrintf(const(char*) fmt, ...);
alias printf = psvDebugScreenPrintf;

struct IntDynamicArray
{
	int* values;
	ulong length;
}

class Test
{
	__gshared static int[] testStaticConstructor;
	immutable(char*) getStringFromD()
	{
		return "Hello World from D! Simple Test".ptr;
	}
}


class UltraTest : Test
{
	override immutable(char*) getStringFromD()
	{
		return this.classinfo.name.ptr;
	}
}


//Guarantee that _testInstance is not collected and thus break the C code
__gshared Test _testInstance;
extern(C) void* createTest()
{
	_testInstance = new Test();
	return cast(void*)_testInstance;
}
extern(C) void checkDynamicCast(Test _TestInstance)
{
	if(cast(UltraTest)_TestInstance is null)
		printf("DynamicCast worked!");
	else
		printf("DynamicCast failed");
}


extern(C) immutable(char*) getStringFromD()
{
	return new UltraTest().getStringFromD;
}

extern(C) float getFloatFromD()
{
	return 500.52f;
}

extern(C) int getDynamicArraySum()
{
	int[] tester;
	for(int i = 0; i < 50; i++)
		tester~= (i*300) + i/2;
	
	int sum = 0;
	foreach(v; tester)
		sum+= v;
	return sum;
}


extern(C) IntDynamicArray intDynamicArrayFromD()
{
	return IntDynamicArray(Test.testStaticConstructor.ptr, Test.testStaticConstructor.length);
}


extern(C) extern int _Cmain(int argc, const(char*) argv);

//Tests wether D can control the main function
extern(C) int main(int argc, const(char*) argv)
{
	import lwdr;
	// LWDR.startRuntime();// startRuntime and stopRuntime doesn't work yet :(
	int ret = _Cmain(argc, argv);
	// LWDR.stopRuntime();
	return ret;
}



static this()
{
	for(int i = 0; i < 5; i++)
		Test.testStaticConstructor~= i;
}