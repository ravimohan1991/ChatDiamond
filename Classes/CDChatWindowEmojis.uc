/*
 *   --------------------------
 *  |  UTChatWindowEmojis.uc
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
 *   December, 2022: Native experiments
 *   April, 2023: Native - scripting hybrid progress
 */

//================================================================================
// UTChatWindowEmojis
//
// - Flashing of availabule emojis
//================================================================================

class CDChatWindowEmojis extends UWindowPageWindow;

 #exec Texture Import File=Textures\emodisplay.bmp    Name=IYellow    Mips=off

 //var() int Element

 //var CDMiniFrameList DrawnMiniFrameList;

 var int NumberOfColumnElements;

 var float MFWidhtToHeightRatio;

 var CDEmoDisplayArea TheEmoDisplayArea;
 var CDChatWindowChat ChatWindow;

 var CDModMenuWindowFrame FrameWindow;

 var int MaxMFRows;

 var color WhiteColor, BlackColor;
 var color PinkColor;

 var float  PrevWinWidth, PrevWinHeight;
 var float  PageWidth, PageHeight;
 var string DetailMode;

 var UWindowSmallButton ButSend;
 var UWindowSmallButton ButSave;
 var UWindowSmallButton ButtonPlaySpectate;
 var UWindowSmallButton ButtonDisconnectAndQuit;
 var UWindowEditControl EditMesg;

 var UWindowHSliderControl MiniFrameSlider;

 function Created ()
 {
 	//local CDDiscordActor DA;

 	// Some sweet values after dynamic interpolation
 	NumberOfColumnElements = 8;
 	MFWidhtToHeightRatio = 1.1;

 	Super.Created();

 	//Log("Attempting Native Actor Spawn!");
 	//DA = Root.GetPlayerOwner().spawn(class'CDDiscordActor', Root.GetPlayerOwner(), 'NativeTest');

 	TheEmoDisplayArea = CDEmoDisplayArea(CreateControl(Class'CDEmoDisplayArea', 0, 25, 385, 187));
 	TheEmoDisplayArea.AbsoluteFont = Font(DynamicLoadObject("UWindowFonts.TahomaB12", class'Font'));
 	TheEmoDisplayArea.bAutoScrollbar = False;
 	TheEmoDisplayArea.Clear();
 	TheEmoDisplayArea.bVariableRowHeight = True;
 	TheEmoDisplayArea.bScrollOnResize = True;
 	TheEmoDisplayArea.EmoWindowPage = self;

 	// Literal copy paste from CDChatWindowChat
 	ButSave = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 4, 230, 50, 25));
 	ButSave.SetText("Save");
 	ButSave.DownSound = sound'UnrealShare.FSHLITE2';

 	ButSend = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 278, 230, 50, 25));
 	ButSend.SetText("Send");
 	ButSend.DownSound = sound'UnrealShare.FSHLITE2';

 	ButtonDisconnectAndQuit = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 333, 230, 50, 25));
 	ButtonDisconnectAndQuit.SetText("RAGE");//("Goodbye!");
 	ButtonDisconnectAndQuit.DownSound = sound'UnrealShare.FSHLITE2';

 	ButtonPlaySpectate = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 4, 255, 380, 25));

 	if(GetPlayerOwner().GetDefaultURL("OverrideClass") == "Botpack.CHSpectator")
 	{
 		ButtonPlaySpectate.SetText("Play");
 	}
 	else
 	{
 		ButtonPlaySpectate.SetText("Spectate");
 	}
 	ButtonPlaySpectate.DownSound = sound'UnrealShare.FSHLITE2';

 	// must go here to get 1st focus
 	EditMesg = UWindowEditControl(CreateControl(Class'UWindowEditControl', 56, 230, 217, 16));
 	EditMesg.EditBoxWidth = 217;
 	EditMesg.SetNumericOnly(False);
 	EditMesg.SetFont(0);
 	EditMesg.SetHistory(True);
 	EditMesg.SetValue("");
 	EditMesg.Align = TA_Left;

 	SetAcceptsFocus();

 	PrevWinWidth  = WinWidth;
 	PrevWinHeight = WinHeight;
 }

 function Notify (UWindowDialogControl C, byte E)
 {
 	Super.Notify(C,E);

 	if(E == DE_MouseMove)
 	{
 		if(C == ButSend)
 		{
 			FrameWindow.StatusBarText = "Send the message!";
 		}

 		if(C == ButSave)
 		{
 			FrameWindow.StatusBarText = "Save the messages in ChatDiamond.ini!";
 		}

 		if(C == ButtonPlaySpectate)
 		{
 			FrameWindow.StatusBarText = "Based on the context, play or spectate!";
 		}

 		if(C == ButtonDisconnectAndQuit)
 		{
 			FrameWindow.StatusBarText = "Shut down the game and do `better` things!";
 		}

 		if(C == EditMesg)
 		{
 			FrameWindow.StatusBarText = "Type a message for everyone!";
 		}
 	}

 	if(E == DE_MouseLeave)
 	{
 		if(C == ButSend)
 		{
 			FrameWindow.StatusBarText = "";
 		}

 		if(C == ButSave)
 		{
 			FrameWindow.StatusBarText = "";
 		}

 		if(C == ButtonPlaySpectate)
 		{
 			FrameWindow.StatusBarText = "";
 		}

 		if(C == ButtonDisconnectAndQuit)
 		{
 			FrameWindow.StatusBarText = "";
 		}

 		if(C == EditMesg)
 		{
 			FrameWindow.StatusBarText = "";
 		}
 	}

 	Switch(E)
 	{
 		case DE_Change:
 			switch(C)
 			{
 				case MiniFrameSlider:
 				/*	MFWidhtToHeightRatio = MiniFrameSlider.GetValue();
 					MiniFrameSlider.SetText(string(MFWidhtToHeightRatio));
 					MFEmo.Width = WinWidth / 8;
 					MFEmo.Height =  int(MFEmo.Width * MFWidhtToHeightRatio);*/
 				break;

 				case EditMesg:
 					if(ChatWindow!= none && EditMesg.GetValue() != "" && ChatWindow.EditMesg.GetValue() != EditMesg.GetValue())
 					{
 						ChatWindow.EditMesg.SetValue(EditMesg.GetValue());
 					}
 				break;
 			}
 			break;
 		case DE_Click:
 			switch(C)
 			{
 				case ButSave:
 							ChatWindow.SaveConfig();
 							ButSave.bDisabled = True;
 							GetPlayerOwner().ClientMessage("All Messages have been saved to ChatDiamond.ini");
 						break;

 						case ButSend:
 							ChatWindow.SendMessage(EditMesg);
 						break;

 						case ButtonDisconnectAndQuit:
 							Root.QuitGame();
 						break;

 				// Courtsey ProAsm's UTCmds8
 				case ButtonPlaySpectate:
 						if(GetPlayerOwner().PlayerReplicationInfo.bIsSpectator)
 						{
 							GetPlayerOwner().PreClientTravel();
 							GetPlayerOwner().ClientTravel("?OverrideClass=", TRAVEL_Relative, False);
 							ButtonPlaySpectate.SetText("Spectate");
 						}
 						else
 						{
 							GetPlayerOwner().PreClientTravel();
 							GetPlayerOwner().ClientTravel("?OverrideClass=Botpack.CHSpectator", TRAVEL_Relative, False);
 							ButtonPlaySpectate.SetText("Play");
 						}
 						break;
 			}
 			break;
 		case 7:
 			ChatWindow.SendMessage(EditMesg);
 		break;
 		default:
 		break;
 	}
 }

 function EmoHelper(string StatusBarText, bool bSet)
 {
 	if(bSet)
 	{
 		FrameWindow.StatusBarText = StatusBarText;
 	}
 	else
 	{
 		FrameWindow.StatusBarText = "";
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
 	if ((DiffX != 0 || DiffY != 0))
 	{
 		TheEmoDisplayArea.SetSize(TheEmoDisplayArea.WinWidth + DiffX, TheEmoDisplayArea.WinHeight + DiffY);
 		TheEmoDisplayArea.WrapWidth = TheEmoDisplayArea.WinWidth - 80;

 		ButSave.WinTop += DiffY;

 		ButSend.WinLeft += DiffX;
 		ButSend.WinTop += DiffY;

 		ButtonDisconnectAndQuit.WinLeft += DiffX;
 		ButtonDisconnectAndQuit.WinTop += DiffY;

 		EditMesg.WinTop += DiffY;
 		EditMesg.SetSize(EditMesg.WinWidth + DiffX, EditMesg.WinHeight);
 		EditMesg.EditBoxWidth = EditMesg.WinWidth;

 		ButtonPlaySpectate.WinTop += DiffY;
 		ButtonPlaySpectate.SetSize(ButtonPlaySpectate.WinWidth + DiffX, ButtonPlaySpectate.WinHeight);
 	}
 	PrevWinWidth = WinWidth;
 	PrevWinHeight = WinHeight;
 }

 function BeforePaint( Canvas C, float X, float Y )
 {
 	Super.BeforePaint(C, X, Y);
 	Resize();
 }

 // Not painting on, rather, over TheEmoDisplayArea
 function Paint(Canvas C, float MouseX, float MouseY)
 {
 	local float TitleXLength, TitleYLength;
 	local string StringToDraw;

 	Super.Paint(C,MouseX,MouseY);

 	// Page Title
 	C.Font = Root.Fonts[F_LargeBold];

 	StringToDraw = "Chat Diamond EMO Representation";
 	C.TextSize(StringToDraw, TitleXLength, TitleYLength);

 	C.SetPos((WinWidth * Root.GUIScale) / 2 - TitleXLength / 2, Root.GUIScale * TitleYLength * 0.25);
 	C.DrawText(StringToDraw);

 	//DrawnMiniFrameList.Clear();

 	//Log(MiniFrameY @ "Y depth is: " @ MiniFrameY + MiniFrameHeight);

 	//DrawnMiniFrameList.ComputeRowAndColumnOfElements(ThisWindowRegion, TitleYLength, BetweenTheMiniFrameSeperationX,
 	//BetweenTheMiniFrameSeperationY);
 	// Log(Root.GUIScale @ "Display Height is: " $ TheEmoDisplayArea.WinHeight * Root.GUIScale $ " LL height is: " $ DrawnMiniFrameList.GetMiniFrameListHieght());
 }

 function Close (optional bool bByParent)
 {
 	Super.Close(bByParent);
 	SaveConfig();
 }

 defaultproperties
 {
 	WhiteColor=(R=255,G=255,B=255)
 	PinkColor=(R=255,G=192,B=203)
 	BlackColor=(R=0,G=0,B=0)
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
