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
 *   April, 2023: Native - scripting hybrid progress
 */

#include "ChatDiamondNative.h"
#include <regex>
#include <iostream>
#include <fstream>

#include "google/cloud/translate/v3/translation_client.h"
#include "google/cloud/project.h"

IMPLEMENT_PACKAGE(ChatDiamond);

IMPLEMENT_CLASS(ACDDiscordActor);

json ACDDiscordActor::JsonVariable;

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

void ACDDiscordActor::execTranslate(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execTranslate);

	P_FINISH;

	auto constexpr kText = R"""(
								Four score and seven years ago our fathers brought forth on this
								continent, a new nation, conceived in Liberty, and dedicated to
								the proposition that all men are created equal.)""";

	namespace translate = ::google::cloud::translate_v3;

	auto client = translate::TranslationServiceClient(
			translate::MakeTranslationServiceConnection());

	auto const project = google::cloud::Project("chatdiamond-translator");
	auto const target = std::string{ "es-419" };
	
	try
	{
		auto response = client.TranslateText(project.FullName(), target, { std::string{kText} });

		if (!response) throw std::move(response).status();

		for (auto const& translation : response->translations()) 
		{
			GLog->Logf(TEXT("[Chat Diamond] Translation: %s"), translation.translated_text());
		}
	}
	catch (google::cloud::Status const& status)
	{
		GLog->Logf(TEXT("[Chat Diamond] google::cloud::Status thrown %s"), status.message().data());
	}

	unguard;
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execTranslate)

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

/**
 * Algorithm implementation courtsey https://stackoverflow.com/a/53640374/20867796
 * Optimization needed
 */
void ACDDiscordActor::execGetLineFromCacheBottom(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execGetLineFromCacheBottom);

	P_GET_INT(LineNumber);
	P_FINISH;

	std::ifstream ChatCache("ChatDiamond.txt");
	int LNumber = LineNumber;

	ChatCache.seekg(0, ChatCache.end);

	while (ChatCache.tellg() != 0 && LNumber)
	{
		ChatCache.seekg(-1, ChatCache.cur);

		if (ChatCache.peek() == '\n')
		{
			LNumber--;
		}
	}

	if (ChatCache.peek() == '\n')
	{
		ChatCache.seekg(1, ChatCache.cur);
	}

	std::string ChatMeta;

	std::getline(ChatCache, ChatMeta);// this line is blank IDK
	std::getline(ChatCache, ChatMeta);

	*(FString*)Result = ChatMeta.c_str();

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
		*IPCategory = 0;
		*(FString*)Result = IPString.c_str();
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
		*IPCategory = 1;
		*(FString*)Result = IPString.c_str();
		return;
	}

	*IPCategory = 2;
	*(FString*)Result = IPString.c_str();

	unguard;
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execSpitIpFromChatString)

void ACDDiscordActor::execAddJsonKeyValue(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execAddJsonKeyValue);

	P_GET_STR(Key);
	P_GET_STR(Value);
	P_FINISH;

	std::wstring KWString(*Key);
	std::string KeyString(KWString.begin(), KWString.end());

	std::wstring VWString(*Value);
	std::string ValueString(VWString.begin(), VWString.end());

	if (KeyString != "" && ValueString != "")
	{
		JsonVariable.emplace(KeyString, ValueString);
	}

	unguard
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execAddJsonKeyValue)

void ACDDiscordActor::execResetJsonContainer(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execResetJsonContainer);

	P_FINISH;

	JsonVariable.clear();

	unguard
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execResetJsonContainer)

void ACDDiscordActor::execFetchValue(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execFetchValue);

	P_GET_STR(Key);
	P_FINISH;

	std::wstring KWString(*Key);
	std::string KeyString(KWString.begin(), KWString.end());

	std::string ReturnString;

	if (JsonVariable.empty() || !JsonVariable.contains(KeyString))
	{
		ReturnString = "";
	}
	else
	{
		ReturnString = JsonVariable[KeyString];
	}

	*(FString*)Result = ReturnString.c_str();

	unguard
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execFetchValue)

void ACDDiscordActor::execSerializeJson(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execSerializeJson);

	P_FINISH;

	std::string SerializedJson;
	SerializedJson = "";

	if(!JsonVariable.empty() && JsonVariable.is_object())
	{
		try
		{
			SerializedJson = JsonVariable.dump(-1, ' ', false, json::error_handler_t::ignore);
		}
		catch (std::exception& e)
		{
			GLog->Logf(TEXT("[Chat Diamond] exception %s"), e.what());//Log output and use printf format.
		}
	}

	JsonVariable.clear();

	*(FString*)Result = SerializedJson.c_str();

	unguard;
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execSerializeJson)

void ACDDiscordActor::execDeSerializeJson(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execDeSerializeJson);

	P_GET_STR(JsonString);
	P_FINISH;

	std::wstring JWString(*JsonString);
	std::string StringToDeserialize(JWString.begin(), JWString.end());

	if(json::accept(StringToDeserialize))
	{
		JsonVariable = json::parse(StringToDeserialize);
	}
	else
	{
		GLog->Logf(TEXT("[ChatDiamond] Illformed string %s detected for json deserialization"), StringToDeserialize.c_str());
	}

	unguard;
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execDeSerializeJson)

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