/*
 *   ------------------------
 *  |  ChatDiamondNative.cpp
 *   ------------------------
 *   This file is part of ChatDiamond for UT99.
 *
 *   ChatDiamond is free software: you can redistribute and/or modify
 *   it under the terms of the Open Unreal Mod License version 1.1.
 *
 *   ChatDiamond is distributed in the hope and belief that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 *   You should have received a copy of the Open Unreal Mod License
 *   along with ChatDiamond.  If not, see
 *   <https://beyondunrealwiki.github.io/pages/openunrealmodlicense.html>.
 *
 *   Timeline:
 *   Before November, 2022: ProAsm and No0ne developed UTChat
 *                         (https://ut99.org/viewtopic.php?f=7&t=14356)
 *   November, 2022: Transitioning from UTChat to ChatDiamond
 *                 (https://ut99.org/viewtopic.php?f=7&t=14356&start=30#p139510)
 *   December, 2022: Native experiments
 */

#include "ChatDiamondNative.h"
#include <regex>

#include "shellapi.h"
#include "commdlg.h"
#include "CommCtrl.h"
#include "Window.h"

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

void ACDDiscordActor::execLoadTextureFromFileOnTheRun(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execLoadTextureFromFileOnTheRun);
	P_GET_STR(FileName);
	P_FINISH;

	UTexture* SomeTexture = NULL;
	//ULinkerLoad* Linker;
	//Linker->Summary.Guid;

	//BeginLoad();

	FString FilePath = appBaseDir();
	FilePath += TEXT("welcome.bmp");

	GLog->Logf(TEXT("Hmm so the file path is %s"), FilePath);

	FWindowsBitmap TestBitmap;
	UBOOL bResult = TestBitmap.LoadFile(*FilePath);

	if (!bResult)
	{
		GLog->Logf(TEXT("Failed to load the file!"));
		(void*)Result = NULL;
		return;
	}

	HBITMAP BitHandle = TestBitmap.GetBitmapHandle();
	TestBitmap.SizeX;

	//ULinkerLoad* Linker = GetPackageLinker(NULL, *FilePath, LOAD_None, NULL, NULL);

	UTexture TestBitMap;

	//TestBitMap.Load

	// No linker => file not present or access denied?
	/*if (1)//!Linker)
	{
		*(BYTE*)Result = NULL;
		GLog->Logf(TEXT("File is %s"));
		EndLoad();
		return;
	}*/

	//SomeTexture = LoadObject<UTexture>(NULL, NULL, *Linker->Filename, LOAD_NoFail, NULL);

	/*
	if (SomeTexture)
	{
		GLog->Logf(TEXT("ChatDiamond: Successfully loaded welldone.bmp"));
		*(UTexture*)Result = *SomeTexture;
		EndLoad();
		return;
	}
	else
	{
		GLog->Logf(TEXT("ChatDiamond: couldn't load welldone.bmp, well!"));
		(void*)Result = NULL;
		EndLoad();
		return;
	}*/

	//EndLoad();
	unguard;
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execLoadTextureFromFileOnTheRun);

void ACDDiscordActor::execSpitIpFromChatString(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execSpitIpFromChatString);
	P_GET_STR(Message);
	P_GET_INT_REF(IPCategory);
	P_FINISH;

	std::smatch Match;

	// The nice way out, from game and web server mix, seems to make an assumption that, in context of UT, the gameserver IP
	// be given by complete port number.

	// https://github.com/ravimohan1991/ChatDiamond/issues/1#issuecomment-1356906185
	std::regex GameIPMould("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\:\\d{1,4}");
	std::regex WebIPMould("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}");

	std::wstring WString(*Message);
	std::string SampleString(WString.begin(), WString.end());

	std::string IPString;

	// Look for game IP
	if (std::regex_search(SampleString, Match, GameIPMould))
	{
		for (auto Tempo : Match)
		{
			IPString = Tempo.str();
			break;
		}
	}

	if (!IPString.empty())
	{
		std::wstring WideIPString = std::wstring(IPString.begin(), IPString.end());
		*IPCategory = 0;
		*(FString*)Result = WideIPString.c_str();
		return;
	}

	// Look for game IP
	if (std::regex_search(SampleString, Match, WebIPMould))
	{
		for (auto Tempo : Match)
		{
			IPString = Tempo.str();
			break;
		}
	}

	if (!IPString.empty())
	{
		std::wstring WideIPString = std::wstring(IPString.begin(), IPString.end());
		*IPCategory = 1;
		*(FString*)Result = WideIPString.c_str();
		return;
	}

	std::wstring WideIPString = std::wstring(IPString.begin(), IPString.end());
	*IPCategory = 2;
	*(FString*)Result = WideIPString.c_str();

	unguard;
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execSpitIpFromChatString);

/*
void SomeFunction()
{
	std::string SampleString("There's no place like 127.0.0.1 and what is 192.168.1.1\n");
	std::smatch Match;
	std::regex IPMould("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}");

	while (std::regex_search(SampleString, Match, IPMould))
	{
		for (auto x : Match)
		{
			std::cout << x << " ";
		}

		std::cout << std::endl;

		SampleString = Match.suffix().str();
	}

	return 0;
}
*/

/*
 *
 *		                                  /\
 *		                                 / /
 *		                              /\| |
 *		                              | | |/\
 *		                              | | / /
 *		                              | `  /
 *		                              `\  (___
 *		                             _.->  ,-.-.
 *		                          _.'      |  \ \
 *		                         /    _____| 0 |0\
 *		                        |    /`    `^-.\.-'`-._
 *		                        |   |                  `-._
 *		                        |   :                      `.
 *		                        \    `._     `-.__         O.'
 *		 _.--,                   \     `._     __.^--._O_..-'
 *		`---, `.                  `\     /` ` `
 *		     `\ `,                  `\   |
 *		      |   :                   ;  |
 *		      /    `.              ___|__|___
 *		     /       `.           (          )
 *		    /    `---.:____...---' `--------`.
 *		   /        (         `.      __      `.
 *		  |          `---------' _   /  \       \
 *		  |    .-.      _._     (_)  `--'        \
 *		  |   (   )    /   \                       \
 *		   \   `-'     \   /                       ;-._
 *		    \           `-'           \           .'   `.
 *		    /`.                  `\    `\     _.-'`-.    `.___
 *		   |   `-._                `\    `\.-'       `-.   ,--`
 *		    \      `--.___        ___`\    \           ||^\\
 *		     `._        | ``----''     `.   `\         `'  `
 *		        `--;     \  jgs          `.   `.
 *		           //^||^\\               //^||^\\
 *		           '  `'  `               '   '  `
 */