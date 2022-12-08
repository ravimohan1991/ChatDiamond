/*
 *   -------------------
 *  |  CDAboutWindow.uc
 *   -------------------
 *   This file is part of CDAboutWindow for UT99.
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
// CDAboutWindow
//
//- For the display of involved parties
//==============================================================================

class CDAboutWindow expands UWindowPageWindow;

 var color WhiteColor, GrayColor;
 var color ChatDiamondTitleColor;

 var float  PrevWinWidth, PrevWinHeight;
 var string DetailMode;

 var CDUWindowCreditsControl CDCreditsControl;

 function Created()
 {
 	Super.Created();

 	CDCreditsControl = CDUWindowCreditsControl(CreateWindow(class'CDUWindowCreditsControl', 0, 0, WinWidth, WinHeight));
 	CDCreditsControl.Register(Self);

 	CDCreditsControl.Initiate();

 	CDCreditsControl.AddLineText("Chat Diamond", 3, ChatDiamondTitleColor, true);
 	CDCreditsControl.AddPadding(5);
 	CDCreditsControl.AddLineText("Version: "$ class'UTChat'.default.Version);
 	CDCreditsControl.AddPadding(10);

 	CDCreditsControl.AddLineText("Coder:");
 	CDCreditsControl.AddPadding(4);
 	CDCreditsControl.AddLineText("The_Cowboy", 1);
 	CDCreditsControl.AddPadding(15);
 	CDCreditsControl.AddLineText("Special Thanks To:");
 	CDCreditsControl.AddPadding(4);
 	CDCreditsControl.AddLineText("ProAsm", 1);
 	CDCreditsControl.AddLineText("Daan 'Defrost' Scheerens from Zeropoint Productions", 1);
 	CDCreditsControl.AddLineUrl("https://github.com/dscheerens/nexgen",, "GitHub");
 	CDCreditsControl.AddLineText("No0ne", 1);
 	CDCreditsControl.AddLineText("Bruce Bickar aka BDB", 1);
 	CDCreditsControl.AddLineUrl("https://www.utassault.net/leagueas/",, "LeagueAS");
 	CDCreditsControl.AddLineText("Mongo and DrSin", 1);
 	CDCreditsControl.AddLineText("[os]sphx", 1);
 	CDCreditsControl.AddLineText("Dean Harmon (for WOT Greal)", 1);
 	CDCreditsControl.AddPadding(20);
 	CDCreditsControl.AddLineUrl("https://eatsleeput.com/d/192-chatdiamond", 2 ,"Forum");
 	CDCreditsControl.AddLineText("Please visit the forum for suggestions and feedbacks");

 	// Setting initial conditions for each scrolling context
 	// If scroll's height is greater than display area, then scroll. Else just stay.
 	if(CDCreditsControl.HeightTotal + 20 <= CDCreditsControl.WinHeight)
 	{
 		CDCreditsControl.Offset = -(CDCreditsControl.WinHeight - CDCreditsControl.HeightTotal) / 2;
 	}
 	else
 	{
 		CDCreditsControl.Offset = -10;
 	}

 	SetAcceptsFocus();

 	PrevWinWidth  = WinWidth;
 	PrevWinHeight = WinHeight;
 }


 function Notify (UWindowDialogControl C, byte E)
 {
 	Super.Notify(C,E);
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
 		CDCreditsControl.SetSize(CDCreditsControl.WinWidth + DiffX, CDCreditsControl.WinHeight + DiffY);
 		CDcreditsControl.Resize();
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

 	//DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BlackTexture');
 	C.Style = GetPlayerOwner().ERenderStyle.STY_Normal;
 }

 function Close (optional bool bByParent)
 {
 	Super.Close(bByParent);
 }

 defaultproperties
 {
   ChatDiamondTitleColor=(R=180,G=180,B=180)
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
