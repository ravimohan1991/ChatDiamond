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
#include <iostream>
#include <fstream>

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


void ACDDiscordActor::execGetGameSystemPath(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execGetGameSystemPath);

	P_FINISH;

	*(FString*)Result = appBaseDir();

	unguard;
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execGetGameSystemPath)

void ACDDiscordActor::execCacheChatLine(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execCacheChatLine);
	P_GET_STR(ChatLine)
	P_FINISH;

	std::wstring WString(*ChatLine);
	std::string ChatLineString(WString.begin(), WString.end());

	// Open file
	std::ofstream ChatCacher;

	// Open a file to perform a write operation using a file object.
	// https://stackoverflow.com/questions/2393345/how-to-append-text-to-a-text-file-in-c
	ChatCacher.open("ChatDiamond.txt", std::ios::app);

	// Checking whether the file is open. Append text if open
	if (ChatCacher.is_open())
	{
		ChatCacher << ChatLineString <<  "\n"; // Inserting text.
		ChatCacher.close(); // Close the file object.
	}

	unguard;
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execCacheChatLine)

void ACDDiscordActor::execGetLineFromCacheBottom(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execGetLineFromCacheBottom);
	
	P_GET_INT(LineNumber);
	P_FINISH;

	uint32_t NumberOfLinesFromBottom = 0;
	std::string Line;

	// Open file
	std::ifstream ChatCacher;

	// Open a file to perform a write operation using a file object.
	// https://stackoverflow.com/questions/2393345/how-to-append-text-to-a-text-file-in-c
	ChatCacher.open("ChatDiamond.txt", std::ios::ate);

	// Checking whether the file is open. Append text if open
	if (ChatCacher.is_open())
	{
		std::streampos Size = ChatCacher.tellg();

		for (uint32_t i = 1; i <= Size; i++)
		{
			ChatCacher.seekg(-i, std::ios::end);

		}
	}

	unguard;
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execGetLineFromCacheBottom)

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
		for (const std::ssub_match& Tempo : Match)
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
		for (const std::ssub_match& Tempo : Match)
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
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execSpitIpFromChatString)


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