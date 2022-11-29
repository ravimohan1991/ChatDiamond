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
 */

//================================================================================
// UTChatWindowEmojis
//
// - Flashing of availabule emojis
// - Resizing of the window as per need
//================================================================================

class UTChatWindowEmojis extends UWindowPageWindow config (ChatDiamond);

 struct ControlDimensions
 {
   var() float LeftCoordinate;
   var() float TopCoordinate;
   var() float Width;
   var() float Height;
 };

 // Caching page variables
 var() config bool bIsCacheFilled;// Assumption: INI is not manually manipulated
 var() config float PageWidth, PageHeight;
 var() config ControlDimensions ButtonCD, TypingWindowCD;

 var UTChatWRI UTWRI;

 var UWindowSmallButton ButClose;
 var UTChatWinControl   EditMesg;

 var color WhiteColor, GrayColor;

 var float  PrevWinWidth, PrevWinHeight;
 var string DetailMode;

 var bool bFirstResize;

 function Created ()
 {
 	Super.Created();

 	if ( UTWRI == none )
 	{
 		foreach GetPlayerOwner().AllActors(class'UTChatWRI', UTWRI)
 		break;
 	}

 	DetailMode = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager TextureDetail");

 	if(!bIsCacheFilled)
 	{
 		ButClose = UWindowSmallButton(CreateControl(Class'UWindowSmallButton', 320, 229, 60, 25));
 	}
 	else
 	{
 		ButClose = UWindowSmallButton(CreateControl(Class'UWindowSmallButton', ButtonCD.LeftCoordinate, ButtonCD.TopCoordinate, ButtonCD.Width, ButtonCD.Height));
 	}
 	ButClose.Text = "Close";

 	if(!bIsCacheFilled)
 	{
 		EditMesg = UTChatWinControl(CreateControl(Class'UTChatWinControl', 10, 228, 300, 16));
 		EditMesg.EditBoxWidth = 300;
 	}
 	else
 	{
 		EditMesg = UTChatWinControl(CreateControl(Class'UTChatWinControl', TypingWindowCD.LeftCoordinate, TypingWindowCD.TopCoordinate, TypingWindowCD.Width, TypingWindowCD.Height));
 		EditMesg.EditBoxWidth = TypingWindowCD.Width;
 	}

 	EditMesg.SetNumericOnly(False);
 	EditMesg.SetFont(0);
 	EditMesg.SetHistory(True);
 	EditMesg.SetValue("");
 	EditMesg.Align=TA_Left;

 	SetAcceptsFocus();

 	PrevWinWidth  = WinWidth;
 	PrevWinHeight = WinHeight;

 	bFirstResize = true;
 }

 function Notify (UWindowDialogControl C, byte E)
 {
 	Super.Notify(C,E);

 	Switch(E)
 	{
 		case DE_Click:
 			switch(C)
 			{
 				case ButClose:
 				ParentWindow.ParentWindow.Close();
 				break;
 			}
 			break;
 		case 7:
 			SendMessage();
 			break;
 		default:
 			break;
 	}
 }

 function SendMessage()
 {
 	if ( EditMesg.GetValue() != "" )
 	{
 		GetPlayerOwner().ConsoleCommand("SAY " $ EditMesg.GetValue());
 		EditMesg.SetValue("");
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
 		if(!bFirstResize)
 		{
 			ButClose.WinLeft += DiffX;
 			ButClose.WinTop += DiffY;

 			EditMesg.WinTop += DiffY;
 			EditMesg.SetSize(EditMesg.WinWidth + DiffX, EditMesg.WinHeight);
 			EditMesg.EditBoxWidth = EditMesg.WinWidth;
 		}
 		else
 		{
 			bFirstResize = false;
 		}
 	}
 	PrevWinWidth = WinWidth;
 	PrevWinHeight = WinHeight;
 }

 function BeforePaint( Canvas C, float X, float Y )
 {
 	Super.BeforePaint(C, X, Y);
 	Resize();
 }

 function Paint (Canvas C, float MouseX, float MouseY)
 {
 	Super.Paint(C,MouseX,MouseY);

 	C.DrawColor  = WhiteColor;

 	if (DetailMode ~= "High")
 		DrawStretchedTexture(C, 0.00, 0.00, WinWidth, WinHeight, Texture'Emojis1');
 	else
 		DrawStretchedTexture(C, 0.00, 0.00, WinWidth, WinHeight, Texture'Emojis2');

 	C.Style = GetPlayerOwner().ERenderStyle.STY_Normal;
 }

 function Close (optional bool bByParent)
 {
 	Super.Close(bByParent);

 	PageWidth = WinWidth;
 	PageHeight = WinHeight;

 	ButtonCD.Height = ButClose.WinHeight;
 	ButtonCD.Width = ButClose.WinWidth;
 	ButtonCD.LeftCoordinate = ButClose.WinLeft;
 	ButtonCD.TopCoordinate = ButClose.WinTop;

 	TypingWindowCD.Height = EditMesg.WinHeight;
 	TypingWindowCD.Width = EditMesg.WinWidth;
 	TypingWindowCD.LeftCoordinate = EditMesg.WinLeft;
 	TypingWindowCD.TopCoordinate = EditMesg.WinTop;

 	SaveConfig();
 	bIsCacheFilled = true;
 }

 defaultproperties
 {
 	WhiteColor=(R=255,G=255,B=255)
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
