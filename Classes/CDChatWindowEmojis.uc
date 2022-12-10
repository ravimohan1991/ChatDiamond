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
//================================================================================

class CDChatWindowEmojis extends UWindowPageWindow;

 //var() int Element

 struct MiniFrameDimensions
 {
 	var int Width;
 	var int Height;

 	var int XPos, YPos;
 	var int MFNumber;
 };
 var MiniFrameDimensions MFEmo;

 var int NumberOfColumnElements;
 var float MFWidhtToHeightRatio;

 var CDUTChatTextTextureAnimEmoteArea TheEmoDisplayArea;

 var color WhiteColor, GrayColor;

 var float  PrevWinWidth, PrevWinHeight;
 var float  PageWidth, PageHeight;
 var string DetailMode;

 var bool bFirstResize;

 function Created ()
 {
 	local int /*NumberOfRowElements,*/ NumberOfColumnElements;

 	NumberOfColumnElements = 2;
 	MFWidhtToHeightRatio = 0.2;

 	MFEmo.Width = WinWidth / NumberOfColumnElements;
 	MFEmo.Height =  int(WinWidth * MFWidhtToHeightRatio);

 	Super.Created();

 	TheEmoDisplayArea = CDUTChatTextTextureAnimEmoteArea(CreateControl(Class'CDUTChatTextTextureAnimEmoteArea', 0, 0, WinWidth, WinHeight));
 	TheEmoDisplayArea.AbsoluteFont = Font(DynamicLoadObject("UWindowFonts.TahomaB12", class'Font'));
 	TheEmoDisplayArea.bAutoScrollbar = False;
 	TheEmoDisplayArea.SetTextColor(GrayColor);
 	TheEmoDisplayArea.Clear();
 	TheEmoDisplayArea.bVariableRowHeight = True;
 	TheEmoDisplayArea.bScrollOnResize = True;

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

 	 //DrawStretchedTexture(C, WinWidth / 2, WinWidth / 2, MFEmo.Width, MFEmo.Height, Texture'UWindow.MenuBar');
 	 DrawMiniFrame(C, WinWidth / 4, WinWidth / 4, 2);
 	C.Style = GetPlayerOwner().ERenderStyle.STY_Normal;
 }

 function DrawMiniFrame(Canvas C, float X, float Y, int BorderWidth)
 {
 	/* Maybe for later lazy sunday afternoons
 	local texture LT;

 	LT = self.GetLookAndFeelTexture();
 	*/

 	// Top Line
 	DrawStretchedTexture(C, X, Y, BorderWidth, BorderWidth, Texture'BlueMenuTL');
	DrawStretchedTexture(C, X + BorderWidth, Y, MFEmo.Width - 2 * BorderWidth, BorderWidth, Texture'BlueMenuT');
	DrawStretchedTexture(C, X + MFEmo.Width - BorderWidth, Y, BorderWidth, BorderWidth, Texture'BlueMenuTR');

 	// Bottom Line
 	DrawStretchedTexture(C, X, Y + MFEmo.Height - BorderWidth, BorderWidth, BorderWidth, Texture'BlueMenuBL');
 	DrawStretchedTexture(C, X + BorderWidth, Y + MFEmo.Height - BorderWidth, MFEmo.Width - 2 * BorderWidth, BorderWidth, Texture'BlueMenuB');
 	DrawStretchedTexture(C, X + MFEmo.Width - BorderWidth, Y + MFEmo.Height - BorderWidth, BorderWidth, BorderWidth, Texture'BlueMenuBR');

 	// Left and Right Lines
 	DrawStretchedTexture(C, X, Y + BorderWidth, BorderWidth, MFEmo.Height - 2 * BorderWidth, Texture'BlueMenuL');
 	DrawStretchedTexture(C, X + MFEmo.Width - BorderWidth, Y + BorderWidth, BorderWidth, MFEmo.Height - 2 * BorderWidth, Texture'BlueMenuR');
 }

 function Close (optional bool bByParent)
 {
 	Super.Close(bByParent);
 	SaveConfig();
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
