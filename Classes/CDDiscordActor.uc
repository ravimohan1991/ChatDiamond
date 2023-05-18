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
 */

//==============================================================================
// CDDiscordActor
// Test native code for CDDiscordActor. By []KAOS[]Casey.
// Courtsey https://www.oldunreal.com/phpBB3/viewtopic.php?f=37&t=3938
//==============================================================================
class CDDiscordActor extends Actor
	native
	noexport;

/*******************************************************************************
 * A native routine for learning and testing basic native interface.
 *
 * @PARAM S           The string to print (log)
 * @PARAM I           The integer number to print (log)
 *
 *******************************************************************************
 */

 native final function bool TestFunction(string S, int I); //This function returns true, and prints the parameters.

/********************************************************************************
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

/********************************************************************************
 * A native routine to cache the chat message along with meta data into
 * ChatDiamond.txt file. This basically provides virtually unlimited messages
 * caching.
 *
 * @PARAM ChatLine             Chat message with metadata
 *                             CommandoSkins.Grail:CommandoSkins.goth::Thursday 18 May 2023 - 21:41  somasup: some chatmessage
 *******************************************************************************
*/
 native final static function CacheChatLine(string ChatLine);

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
