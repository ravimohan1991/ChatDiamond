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
 *   December, 2022: Native experiments
 *   April, 2023: Native - scripting hybrid progress
 */

//==============================================================================
// CDAboutWindow
//
//- For the display of involved parties
//==============================================================================

class CDAboutWindow expands UWindowPageWindow;

 var color WhiteColor, GrayColor;
 var color ChatDiamondTitleColor, CreditsCategoryColor;

 var float  PrevWinWidth, PrevWinHeight;
 var string DetailMode;

 var CDUWindowCreditsControl CDCreditsControl;

 function Created()
 {
    local int CategoryPadding, AfterCategoryTitlePadding;
    local int CategoryItemPadding;

    Super.Created();

    CategoryPadding = 40;
    AfterCategoryTitlePadding = 20;

    CategoryItemPadding = 10;


 	CDCreditsControl = CDUWindowCreditsControl(CreateWindow(class'CDUWindowCreditsControl', 0, 0, WinWidth, WinHeight));
 	CDCreditsControl.Register(Self);

 	CDCreditsControl.Initiate();

 	CDCreditsControl.AddLineText("Chat Diamond", 3, ChatDiamondTitleColor, true);
 	CDCreditsControl.AddPadding(AfterCategoryTitlePadding);
 	CDCreditsControl.AddLineText("Version: "$ class'CDUTConsole'.default.Version);
 	CDCreditsControl.AddPadding(CategoryPadding);

 	CDCreditsControl.AddLineText("Coder:",, CreditsCategoryColor);
 	CDCreditsControl.AddPadding(AfterCategoryTitlePadding);
 	CDCreditsControl.AddLineText("The_Cowboy", 1);
 	CDCreditsControl.AddPadding(CategoryPadding);

 	CDCreditsControl.AddLineText("Companion Libraries",, CreditsCategoryColor);
 	CDCreditsControl.AddPadding(AfterCategoryTitlePadding);
 	CDCreditsControl.AddLineText("Niels Lohmann", 1);
 	CDCreditsControl.AddLineUrl("https://github.com/nlohmann/json",, "C++ Json");
 	CDCreditsControl.AddPadding(CategoryPadding);

 	CDCreditsControl.AddLineText("Special Thanks To:",, CreditsCategoryColor);
 	CDCreditsControl.AddPadding(AfterCategoryTitlePadding);
 	CDCreditsControl.AddLineText("No0ne (for nice suggestions)", 1);
 	CDCreditsControl.AddPadding(CategoryItemPadding);
 	CDCreditsControl.AddLineText("ProAsm", 1);
 	CDCreditsControl.AddPadding(CategoryItemPadding);
 	CDCreditsControl.AddLineText("Daan 'Defrost' Scheerens from Zeropoint Productions", 1);
 	CDCreditsControl.AddLineUrl("https://github.com/dscheerens/nexgen",, "GitHub");
 	CDCreditsControl.AddPadding(CategoryItemPadding);
 	CDCreditsControl.AddLineText("Bruce Bickar aka BDB", 1);
 	CDCreditsControl.AddLineUrl("https://www.utassault.net/leagueas/",, "LeagueAS");
 	CDCreditsControl.AddPadding(CategoryItemPadding);
 	CDCreditsControl.AddLineText("Mongo and DrSin", 1);
 	CDCreditsControl.AddPadding(CategoryItemPadding);
 	CDCreditsControl.AddLineText("[os]sphx", 1);
 	CDCreditsControl.AddPadding(CategoryItemPadding);
 	CDCreditsControl.AddLineText("Dean Harmon (for WOT Greal)", 1);
 	CDCreditsControl.AddPadding(CategoryItemPadding);
 	CDCreditsControl.AddLineText("Anthrax and UT99 patch team", 1);
 	CDCreditsControl.AddLineText("Anthrax again for UTDemo Manager", 1);
 	CDCreditsControl.AddPadding(CategoryItemPadding);
 	CDCreditsControl.AddLineText("[]KAOS[]Casey for", 1);
 	CDCreditsControl.AddLineUrl("https://www.oldunreal.com/phpBB3/viewtopic.php?f=37&t=3938",, "Native-Mod Tutorial");
 	CDCreditsControl.AddPadding(CategoryPadding);

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

 	C.Style = GetPlayerOwner().ERenderStyle.STY_Normal;
 }

 function Close (optional bool bByParent)
 {
 	Super.Close(bByParent);
 }

 defaultproperties
 {
 	ChatDiamondTitleColor=(R=180,G=180,B=180)
 	CreditsCategoryColor=(R=200,G=40,B=100)
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
