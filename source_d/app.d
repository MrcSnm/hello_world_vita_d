class Test
{
	immutable(char*) getStringFromD()
	{
		return "Hello World from D! Simple Test".ptr;
	}
}


class UltraTest : Test
{
	override immutable(char*) getStringFromD()
	{
		return "Hello World from D!!! Ultra Test!".ptr;
	}
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