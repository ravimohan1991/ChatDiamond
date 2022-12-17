#include "ChatDiamondNative.h"

IMPLEMENT_PACKAGE(ChatDiamond);

IMPLEMENT_CLASS(ACDDiscordActor);

ACDDiscordActor::ACDDiscordActor()
{
	//Super::AActor(); // Call super's constructor.
}

void ACDDiscordActor::execTestFunction(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execTestFunction);
	P_GET_STR(S);//Get the first parameter
	P_GET_INT(I);//and the second
	P_FINISH;//you MUST call this or it will crash.

	GLog->Logf(TEXT("Hello World! S=%s,I=%i"), *S, I);//Log output and use printf format.
	//You may also use debugf(TEXT("Hello world!")) since it may be easier to remember.
	*(UBOOL*)Result = true;// Return true to UScript, this is how you return a result. You cast your result into "Result" -- whatever it may be.
	unguard;
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execTestFunction);