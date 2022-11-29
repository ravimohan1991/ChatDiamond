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

 var float  PrevWinWidth, PrevWinHeight;
 var string DetailMode;

 var CDUWindowCreditsControl CDCreditsControl;

 function Created()
 {
 	Super.Created();
 	CDCreditsControl = CDUWindowCreditsControl(CreateWindow(class'CDUWindowCreditsControl', 20, 20, 500, 400));
 	CDCreditsControl.Register(Self);
 	//C.Notify(C.DE_Created);
 	CDCreditsControl.AddLineText("Chat Diamond");
 	CDCreditsControl.AddPadding(5);
 	CDCreditsControl.AddLineText("Version: "$ class'UTChat'.default.Version);
 	CDCreditsControl.AddPadding(10);
 	//C.AddLineImage(texture'author2',60,60);
 	CDCreditsControl.AddLineText("Coder:");
 	CDCreditsControl.AddPadding(4);
 	CDCreditsControl.AddLineText("The_Cowboy");
 	CDCreditsControl.AddPadding(15);
 	CDCreditsControl.AddLineText("Special Thanks To:");
 	CDCreditsControl.AddPadding(4);
 	CDCreditsControl.AddLineText("ProAsm");
 	CDCreditsControl.AddLineText("Daan 'Defrost' Scheerens from Zeropoint Productions");
 	CDCreditsControl.AddLineUrl("https://github.com/dscheerens/nexgen",, "GitHub");
 	CDCreditsControl.AddLineText("No0ne");
 	CDCreditsControl.AddLineText("Bruce Bickar aka BDB");
 	CDCreditsControl.AddLineText("Mongo and DrSin");
 	CDCreditsControl.AddLineText("[os]sphx");
 	CDCreditsControl.AddLineText("Dean Harmon (for WOT Greal)");
 	CDCreditsControl.AddPadding(20);
 	CDCreditsControl.AddLineUrl("https://eatsleeput.com/d/192-chatdiamond",,"Forum");
 	CDCreditsControl.AddLineText("Please visit the forum for suggestions and feedbacks");
 
 	PrevWinWidth  = WinWidth;
 	PrevWinHeight = WinHeight;
 }


 function Notify (UWindowDialogControl C, byte E)
 {
 	Super.Notify(C,E);
 }

 function SendMessage()
 {
 /*
  	if ( EditMesg.GetValue() != "" )
 	{
 	    GetPlayerOwner().ConsoleCommand("SAY " $ EditMesg.GetValue());
 	    EditMesg.SetValue("");
 	}
 */
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
 		CDCreditsControl.WinTop += DiffY;
 		CDCreditsControl.SetSize(CDCreditsControl.WinWidth + DiffX, CDCreditsControl.WinHeight);
 		CDCreditsControl.EditBoxWidth = CDCreditsControl.WinWidth;
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
 	{
 		DrawStretchedTexture(C,0.00,0.00,WinWidth,WinHeight,Texture'Emojis1');
 	}
 	else
 	{
 		DrawStretchedTexture(C,0.00,0.00,WinWidth,WinHeight,Texture'Emojis2');
 	}
 	
 	C.Style = GetPlayerOwner().ERenderStyle.STY_Normal;
 }

 function Close (optional bool bByParent)
 {
 	Super.Close(bByParent);
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
