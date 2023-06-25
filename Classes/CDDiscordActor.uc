/*
 *   ---------------------
 *  |  CDDiscordActor.uc
 *   ---------------------
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

//==============================================================================
// CDDiscordActor
// Test native code for CDDiscordActor. By []KAOS[]Casey.
// Courtsey https://www.oldunreal.com/phpBB3/viewtopic.php?f=37&t=3938
//==============================================================================
class CDDiscordActor extends Actor
	native
	noexport;

 var CDChatWindowChat WindowChat;

/*******************************************************************************
 * A native routine for learning and testing basic native interface.
 *
 * @PARAM S           The string to print (log)
 * @PARAM I           The integer number to print (log)
 *
 *******************************************************************************
 */

 native final function bool TestFunction(string S, int I); //This function returns true, and prints the parameters.

/*******************************************************************************
 * A native routine to detect the first instance of IP in chat message.
 * The format is as follows:
 * 1. Game Server IP 139.162.235.XXX:4554 (note the port)
 * 2. Web Server IP 192.168.1.2 (note no port)
 *
 * @PARAM Message              The chat message to be scanned
 * @PARAM ICategory            Set to
 *                                0 if found game server IP
 *                                1 if found web server IP
 *                                2 if no match is found
 * @see https://github.com/ravimohan1991/ChatDiamond/blob/main/UTNativeEssentials/ChatDiamond/Src/ChatDiamondNative.cpp
 *      for complete implementation of the native function
 *
 *******************************************************************************
*/

 native final static function string SpitIpFromChatString(string Message, out int ICategory); // For now, the routine shall fish for first instance only

/*******************************************************************************
 * A native routine to cache the chat message along with meta data into
 * ChatDiamond.txt file. This basically provides virtually unlimited messages
 * caching.
 *
 * @PARAM ChatLine             Chat message with metadata in json format
 *                             {"ChatMessage":"smooth","FaceName":"SoldierSkins.Gard4Radkin","LocalTime":"Saturday 20 May 2023 21:57"
 *                             ,"PlayerName":"MEDIBOT2000","SkinName":"SoldierSkins.Gard3","Team":"Red"}
 *******************************************************************************
*/

 native final static function CacheChatLine(string ChatLine);

/*******************************************************************************
 * A native routine to get the nth line from bottom of file
 *
 * @PARAM LineNumber           Line from the bottom
 * @return                     the chat metadata
 *******************************************************************************
*/

 native final static function string GetLineFromCacheBottom(int LineNumber);

/*******************************************************************************
 * A collection of native routines for managing json formatting of chat metadata
 *******************************************************************************
*/

 native static function AddJsonKeyValue(string Key, string Value);
 native static function string FetchValue(string Key);
 native static function string SerializeJson();
 native static function DeSerializeJson(string JsonString);
 native static function ResetJsonContainer();

/*
 native final static function OpenNativeTestWindow(bool bVisible, UWindowWindow ParentWindow);
 native final static function int CacheListOfFiles(string Extension, string FolderPath);
 native final static function string GetIthFileFromCacheList(int I);
 native final static function string GetGameSystemPath();
 native final static function Texture LoadTextureFromFileOnTheRun(string FileName);
 */

 function PostBeginPlay()
 {
 	Log("Testing out, well, the TestFunction!");
 	TestFunction("Test", 888); //Your log should output "Hello World! S=Test,I=888"
 }

 function Tick(float delta)
 {
 	if(WindowChat.Root != none && WindowChat.Root.GetPlayerOwner() != none && WindowChat.Root.GetPlayerOwner().GameReplicationInfo != none && WindowChat.Root.GetPlayerOwner().GameReplicationInfo != WindowChat.CDGRI)
 	{
 		WindowChat.CDGRI = WindowChat.Root.GetPlayerOwner().GameReplicationInfo;
 		WindowChat.TemporaryServerName = WindowChat.GenerateServerName();

 		if(WindowChat.TemporaryServerName != "" && WindowChat.TemporaryServerName != "Another UT Server")// ye I don't know what you are doing playing on such server anyways
 		{
 			WindowChat.TemporaryServerHash = class'CDHash'.static.MD5(WindowChat.TemporaryServerName);
 			if(WindowChat.VSRP.CDMD5Hash != WindowChat.TemporaryServerHash)
 			{
 				WindowChat.VSRP.CDServerName = WindowChat.TemporaryServerName;
 				WindowChat.VSRP.CDMD5Hash = WindowChat.TemporaryServerHash;
 				class'CDDiscordActor'.static.ResetJsonContainer();
 				class'CDDiscordActor'.static.AddJsonKeyValue("ServerName", WindowChat.VSRP.CDServerName);
 				class'CDDiscordActor'.static.AddJsonKeyValue("LocalTime", WindowChat.LocalTimeAndMPOVMarker());
 				if(WindowChat.Root.GetPlayerOwner().Level != none && WindowChat.Root.GetPlayerOwner().Level.GetAddressURL() != "")
 				{
 					class'CDDiscordActor'.static.AddJsonKeyValue("ServerAddress", WindowChat.Root.GetPlayerOwner().Level.GetAddressURL());
 				}
 				else
 				{
 					class'CDDiscordActor'.static.AddJsonKeyValue("ServerAddress", "No address");
 				}
 				WindowChat.LoadMessages(class'CDDiscordActor'.static.SerializeJson());
 				class'CDDiscordActor'.static.ResetJsonContainer();
 			}
 		}
 	}

 	if(WindowChat.Root != none && WindowChat.Root.GetPlayerOwner() != none && WindowChat.Root.GetPlayerOwner().GameReplicationInfo != none && WindowChat.Root.GetPlayerOwner().GameReplicationInfo.GameEndedComments != "")
 	{
 		if(!WindowChat.bGameEnded)
 		{
 			WindowChat.bGameEnded = true;

 			if(WindowChat.FrameWindow.bOpenChatWindowOnMatchCompletion)
 			{
 				WindowChat.Root.Console.KeyEvent(EInputKey(WindowChat.CSWindow.ConfigureWindow.ChatWindowKeyForBind), IST_Press, 0.0);
 			}
 		}
 	}
 	else
 	{
 		WindowChat.bGameEnded = false;
 	}

 	Super.Tick(delta);
 }

defaultproperties
{
}

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
