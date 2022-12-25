/*
 *   --------------------------
 *  |  CDUTConsoleWindow.uc
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
// CDUTConsoleWindow
//
//- Minor modified UT's console window
//==============================================================================

class CDUTConsoleWindow extends UWindowPageWindow config (ChatDiamond);

 var UWindowConsoleTextAreaControl TextArea;
 var UWindowEditControl	EditControl;

 var UWindowCheckbox EventsFilter;
 var UWindowCheckbox NonChatMessageFilter;

 var UWindowSmallButton CleanConsoleWindow;

 var int BottomGapForConfiguration;
 var CDModMenuWindowFrame FrameWindow;

 var config string History[32];

 var float PrevWinWidth, PrevWinHeight;
 var Color CheckBoxTextColor;

 function Created()
 {
 	local int i;
 	local UWindowEditBoxHistory CurrentHistory;

 	local int EffectiveHeight;

 	EffectiveHeight = WinHeight - BottomGapForConfiguration;

 	EventsFilter = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 10, WinHeight - 15, 100, 16));
 	EventsFilter.TextColor = CheckBoxTextColor;
 	EventsFilter.SetText("Filter Events");
 	EventsFilter.SetHelpText("Filter out death event messages!");
 	EventsFilter.bChecked = CDUTConsole(Root.Console).bFilterEvents;
 	EventsFilter.SetFont(F_Normal);
 	EventsFilter.Align = TA_Left;

 	NonChatMessageFilter = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 140, WinHeight - 15, 100, 16));
 	NonChatMessageFilter.TextColor = CheckBoxTextColor;
 	NonChatMessageFilter.SetText("Filter NonChat");
 	NonChatMessageFilter.SetHelpText("Filter out non chat messages!");
 	NonChatMessageFilter.bChecked = CDUTConsole(Root.Console).bFilterNonChatMessages;
 	NonChatMessageFilter.SetFont(F_Normal);
 	NonChatMessageFilter.Align = TA_Left;

 	CleanConsoleWindow = UWindowSmallButton(CreateControl(class'UWindowSmallButton', WinWidth - 50, WinHeight - 17, 35, 16));
 	CleanConsoleWindow.SetText("Clear!");
 	CleanConsoleWindow.DownSound = sound'UnrealShare.FSHLITE2';

 	TextArea = UWindowConsoleTextAreaControl(CreateWindow(class'UWindowConsoleTextAreaControl', 0, 0, WinWidth, EffectiveHeight - 100));
 	EditControl = UWindowEditControl(CreateControl(class'UWindowEditControl', 0, 0, WinWidth, 40));
 	EditControl.SetFont(F_Normal);
 	EditControl.SetNumericOnly(False);
 	EditControl.SetMaxLength(400);
 	EditControl.SetHistory(True);

 	for (i = ArrayCount(History) - 1; i >= 0; i--)
 	{
 		if (History[i] == "") continue;
 		CurrentHistory = UWindowEditBoxHistory(EditControl.EditBox.HistoryList.Insert(class'UWindowEditBoxHistory'));
 		CurrentHistory.HistoryText = History[i];
 	}
 	EditControl.EditBox.CurrentHistory = EditControl.EditBox.HistoryList;

 	SetAcceptsFocus();

	PrevWinWidth = WinWidth;
	PrevWinHeight = WinHeight;
 }

 function Notify(UWindowDialogControl C, byte E)
 {
 	local string s;
 	local int i;
 	local UWindowEditBoxHistory CurrentHistory;

 	Super.Notify(C, E);

 	if(E == DE_MouseMove)
 	{
 		if(C == EventsFilter)
 		{
 			FrameWindow.StatusBarText = "Filter out death event messages!";
 		}

 		if(C == NonChatMessageFilter)
 		{
 			FrameWindow.StatusBarText = "Filter out non-chat messages!";
 		}

 		if(C == CleanConsoleWindow)
 		{
 			FrameWindow.StatusBarText = "Clean the console window!";
 		}
 	}

 	if(E == DE_MouseLeave)
 	{
 		if(C == EventsFilter)
 		{
 			FrameWindow.StatusBarText = "";
 		}

 		if(C == NonChatMessageFilter)
 		{
 			FrameWindow.StatusBarText = "";
 		}

 		if(C == CleanConsoleWindow)
 		{
 			FrameWindow.StatusBarText = "";
 		}
 	}

 	switch(E)
 	{
 		case DE_EnterPressed:
 			switch(C)
 			{
 				case EditControl:
 					if(EditControl.GetValue() != "")
 					{
 						CurrentHistory = EditControl.EditBox.HistoryList;
 						for (i = 0; i < ArrayCount(History); i++)
 						{
 							if (CurrentHistory.Next == None)
 								History[i] = "";
 							else
 							{
 								CurrentHistory = UWindowEditBoxHistory(CurrentHistory.Next);
 								History[i] = CurrentHistory.HistoryText;
 							}
 						}
 						SaveConfig();
 						s = EditControl.GetValue();
 						Root.Console.Message( None, "> "$s, 'Console' );
 						EditControl.Clear();
 						if( !Root.Console.ConsoleCommand( s ) )
 							Root.Console.Message( None, Localize("Errors","Exec","Core"), 'Console' );
 					}
 				break;
 			}
 		break;
 		case DE_WheelUpPressed:
 			switch(C)
 			{
 				case EditControl:
 					TextArea.VertSB.Scroll(-1);
 				break;
 			}
 			break;
 		case DE_WheelDownPressed:
 			switch(C)
 			{
 				case EditControl:
 					TextArea.VertSB.Scroll(1);
 					break;
 			}
 		break;
 		case DE_Change:
 			switch(C)
 			{
 				case EventsFilter:
 					CDUTConsole(Root.Console).bFilterEvents = !CDUTConsole(Root.Console).bFilterEvents;
 					EventsFilter.bChecked = CDUTConsole(Root.Console).bFilterEvents;
 				break;
 				case NonChatMessageFilter:
 					CDUTConsole(Root.Console).bFilterNonChatMessages = !CDUTConsole(Root.Console).bFilterNonChatMessages;
 					NonChatMessageFilter.bChecked = CDUTConsole(Root.Console).bFilterNonChatMessages;
 				break;
 			}
 		break;

 		case DE_Click:
 			switch(C)
 				{
 					case CleanConsoleWindow:
 						TextArea.Clear();
 					break;
				}
 		break;
 		default:
 		break;
 	}
 }

 function BeforePaint(Canvas C, float X, float Y)
 {
 	local int EffectiveHeight;// heh

 	EffectiveHeight = WinHeight - BottomGapForConfiguration;

 	EditControl.SetSize(WinWidth, 17);
 	EditControl.WinLeft = 0;
 	EditControl.WinTop = EffectiveHeight - EditControl.WinHeight;
 	EditControl.EditBoxWidth = WinWidth;

 	TextArea.SetSize(WinWidth, EffectiveHeight - EditControl.WinHeight);

 	Super.BeforePaint(C, X, Y);

 	Resize();
 }

 function Paint(Canvas C, float X, float Y)
 {
 	local int EffectiveHeight;

 	EffectiveHeight = WinHeight - BottomGapForConfiguration;

 	if(FrameWindow.bApplyBGToConsole)
 	{
 		C.DrawColor = FrameWindow.BackGroundColor;
 		DrawStretchedTexture(C, 0, 0, WinWidth, EffectiveHeight, Texture'BackgroundGradation');
 	}
 	else
 	{
 		DrawStretchedTexture(C, 0, 0, WinWidth, EffectiveHeight, Texture'BlackTexture');
 	}
 }

 function Close(optional bool bByParent)
 {
 	Super.Close(bByParent);

 	if(Root.bQuickKeyEnable)
 	{
 		Root.Console.CloseUWindow();
 	}
 }

 function Resized()
 {
 	Super.Resized();

 	Resize();
 }


 function Resize()
 {
 	local float DiffX, DiffY;

 	DiffX = WinWidth - PrevWinWidth;
 	DiffY = WinHeight - PrevWinHeight;

 	if (DiffX != 0 || DiffY != 0)
 	{
 		EventsFilter.WinTop += DiffY;
 		NonChatMessageFilter.WinTop += DiffY;
 		CleanConsoleWindow.WinTop += DiffY;
 		CleanConsoleWindow.WinLeft += DiffX;
 	}

 	PrevWinWidth = WinWidth;
 	PrevWinHeight = WinHeight;
 }


 defaultproperties
 {
 	TextArea=None
 	EditControl=None
 	BottomGapForConfiguration=20
 	CheckBoxTextColor=(R=0,G=0,B=0)
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
