/*
 *   -------------------------
 *  |  CDHelperContextMenu.uc
 *   -------------------------
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

class CDChatWindowHelperContextMenu expands UWindowRightClickMenu;

 var UWindowPullDownMenuItem CopyChatMessage;
 var UWindowPullDownMenuItem CopyIP;

 var localized string OpenLocationName;

 var UBrowserServerGrid	Grid;
 var UBrowserServerList	List;

 var string TextToCopyFromChatCache;

 function Created()
{
 	Super.Created();

 	CopyChatMessage = AddMenuItem("Copy this message", None);
 	CopyIP = AddMenuItem("Copy IP", None);
 	//AddMenuItem("-", None);
 }

 function ExecuteItem(UWindowPulldownMenuItem I)
 {
 	local string ExtractedIP;
 	local int IPCategory;

 	switch(I)
 	{
 		case CopyIP:
 			ExtractedIP = class'CDDiscordActor'.static.SpitIpFromChatString(TextToCopyFromChatCache, IPCategory);
 			GetPlayerOwner().CopyToClipboard(ExtractedIP);
 		break;
 		case CopyChatMessage:
 			GetPlayerOwner().CopyToClipboard(TextToCopyFromChatCache);
 		break;
 	}

 	Super.ExecuteItem(I);
 }

 function ShowWindow()
 {
 //	Copy.bDisabled = List == None || List.GamePort == 0;

 	Selected = None;

 	Super.ShowWindow();
 }

defaultproperties
{
 	Grid=None
 	List=None
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
