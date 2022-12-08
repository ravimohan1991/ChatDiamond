/*
 *   --------------------------
 *  |  CDClientSideWindow.uc
 *   --------------------------
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
 */

//==============================================================================
// CDClientSideWindow
//
//- All the client relative tabs are responsibility of this class
//==============================================================================

class CDClientSideWindow expands UWindowConsoleClientWindow config(ChatDiamond);

 #exec texture IMPORT NAME=Emojis1 File=Textures\emojis1.pcx GROUP=Commands Mips=on
 #exec texture IMPORT NAME=Emojis2 File=Textures\emojis2.pcx GROUP=Commands Mips=off

 var UMenuPageControl    Pages;
 var CDChatWindowChat    ChatWindow;
 var UTChatWindowAdmin   AdminWindow;
 var UTChatWindowConfig  ConfigWindow;
 var UTChatWindowEmojis  EmojiWindow;
 var CDAboutWindow       AboutWindow;
 var CDUTConsoleWindow   ConsoleWindow;

 var() config int ActivePageNumber;

 function Created()
 {
 	local UWindowPageControlPage PageControl;

 	Super.Created();

 	WinLeft = int(Root.WinWidth - WinWidth) / 2;
 	WinTop = int(Root.WinHeight - WinHeight) / 2;

 	Pages = UMenuPageControl(CreateWindow(class'UMenuPageControl', 0, 0, WinWidth, WinHeight));
 	Pages.SetMultiLine(false);

 	PageControl = Pages.AddPage("Public Chats", class'CDChatWindowChat');
 	ChatWindow = CDChatWindowChat(PageControl.Page);
 	ChatWindow.FrameWindow = CDModMenuWindowFrame(ParentWindow);

 	PageControl = Pages.AddPage("Emojis", class'UTChatWindowEmojis');
 	EmojiWindow = UTChatWindowEmojis(PageControl.Page);

 	PageControl = Pages.AddPage("Console", class'CDUTConsoleWindow');
 	ConsoleWindow = CDUTConsoleWindow(PageControl.Page);
 	TextArea = ConsoleWindow.TextArea; // khe khe, also think about font TextArea.Font
 	CDUTConsole(Root.Console).ChatWindow = ChatWindow;
 	ConsoleWindow.FrameWindow = CDModMenuWindowFrame(ParentWindow);

 	PageControl = Pages.AddPage("About", class'CDAboutWindow');
 	AboutWindow = CDAboutWindow(PageControl.Page);

 	if(ActivePageNumber == 0)
 	{
 		Pages.GotoTab(Pages.GetTab("Public Chats"));
 	}
 	else if(ActivePageNumber == 1)
 	{
 		Pages.GotoTab(Pages.GetTab("Emojis"));
 	}
 	else if(ActivePageNumber == 2)
 	{
 		Pages.GotoTab(Pages.GetTab("Console"));
 	}
 	else if(ActivePageNumber == 3)
 	{
 		Pages.GotoTab(Pages.GetTab("About"));
 	}

 	//PageControl = Pages.AddPage("Admin", class'UTChatWindowAdmin');
 	//AdminWindow = UTChatWindowAdmin(PageControl.Page);

 	//PageControl = Pages.AddPage("Configs", class'UTChatWindowConfig');
 	//ConfigWindow = UTChatWindowConfig(PageControl.Page);
 }

 function AddChatMessage(string sMesg)
 {
 	if (ChatWindow != None)
 	{
 		ChatWindow.LoadMessages(sMesg);
 	}
 }

 function Resized()
 {
 	Super.Resized();
 	Pages.SetSize(WinWidth, WinHeight);
 }

 function Close(optional bool bByParent)
 {
 	Super.Close(bByParent);

 	if(Pages.SelectedTab.Caption == "Public Chats")
 	{
 		ActivePageNumber = 0;
 	}
 	else if(Pages.SelectedTab.Caption == "Emojis")
 	{
 		ActivePageNumber = 1;
 	}
 	else if(Pages.SelectedTab.Caption == "Console")
 	{
 		ActivePageNumber = 2;
 	}
 	else if(Pages.SelectedTab.Caption == "About")
 	{
 		ActivePageNumber = 3;
 	}

 	SaveConfig();
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
