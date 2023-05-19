/*
 *   --------------------------
 *  |  CDModMenuWindowFrame.uc
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

//=============================================================================
// CDModMenuWindowFrame
//
// The console type uwindow frame for client-side window
//=============================================================================

class CDModMenuWindowFrame expands UWindowConsoleWindow Config (ChatDiamond);

 // INI variables
 var() config int Xpos;
 var() config int Ypos;
 var() config int Wpos;
 var() config int Hpos;
 var() config float FrameWidth, FrameHeight;

 // From ConfigurationWindow
 var() config color BackGroundColor;
 var() config bool bApplyBGToChatWindow;
 var() config bool bApplyBGToConsole;
 var() config bool bPlaySoundOnMessageArrival;
 var() config float EmoSize;
 var() config float EmoteAnimSpeed;
 var() config int LastHistoricMessagesNumber;

 var CDConfigurationWindow ConfigurationWindow;

 function created()
 {
 	SetDimensions();

 	bAcceptsFocus = true;
 	SetAcceptsFocus();

 	super.created();

 	// The outer constraint for all the pages and window of ChatDiamond
 	MinWinWidth = 495;
 	MinWinHeight = 445;

 	bLeaveOnScreen = true;
 	bStatusBar = true;

 	bSizable = True;
 	bMoving = true;

 	// Cached value from previous session
 	if(FrameWidth > 0 && FrameHeight > 0)
 	{
 		WinWidth = FrameWidth;
 		WinHeight = FrameHeight;
 	}
 	else
 	{
 		WinWidth = 495;
 		WinHeight = 445;
 	}

 	SetSizePos();

 	WindowTitle = "Chat Diamond (" $ class'CDUTConsole'.default.Version $ ")";

 	ClientArea.OwnerWindow = self;
 }

 function ResolutionChanged(float W, float H)
 {
 	SetSizePos();
 	Super.ResolutionChanged(W, H);
 }

 function SetSizePos()
 {
 	CheckXY();

 	if (WPos > 0 && HPos > 0)
 	{
 		SetSize(WPos, HPos);
 	}
 	else
 	{
 		SetSize(WinWidth, WinHeight);
 	}

 	WinLeft = ((Root.WinWidth  - WinWidth)  / 100) * (Xpos);
 	WinTop  = ((Root.WinHeight - WinHeight) / 100) * (Ypos);
 }

 function Resized()
 {
 	if (ClientArea == None)
 	{
 		return;
 	}

 	if (!bLeaveOnscreen) // hackish way for detect first resize
 	{
 		SetSizePos();
 	}

 	Super.Resized();
 }

 function CheckXY()
 {
 	if (Xpos < 0 || Xpos > 99)
 	{
 		Xpos = 50;
 	}

 	if (Ypos < 0 || Ypos > 99)
 	{
 		Ypos = 60;
 	}
 }

 function Tick(float DeltaTime)
 {
 	local int x, y;

 	WPos = WinWidth;
 	HPos = WinHeight;

 	x = self.WinLeft / ((Root.WinWidth - WinWidth) / 100);
 	y = self.WinTop / ((Root.WinHeight - WinHeight) / 100);

 	if (Xpos != x || Ypos != y)
 	{
 		Xpos = x;
 		Ypos = y;
 	}

 	Super.Tick(DeltaTime);
 }

 function ShowWindow()
 {
 	ParentWindow.ShowChildWindow(Self);
 	WindowShown();
 }

 function Close(optional bool bByParent)
 {
 	local UWindowWindow Prev, Child;

 	CheckXY();

 	FrameWidth = WinWidth;
 	FrameHeight = WinHeight;
 	//bIsCached = true;
 	SaveConfig();

 	ClientArea.Close(True);
 	Root.Console.HideConsole();

 	for(Child = LastChildWindow; Child != None; Child = Prev)
 	{
 		Prev = Child.PrevSiblingWindow;
 		Child.Close(True);
 	}

 	SaveConfigs();

 	if(!bByParent)
 	{
 		HideWindow();
 	}
 }

 function SetDimensions()
 {
 	WinWidth = 395;
 	WinHeight = 322;
 }

 defaultproperties
 {
 	XPos=50
 	YPos=50
 	ClientClass=Class'CDClientSideWindow'
 	EmoSize=14
 	EmoteAnimSpeed=85
 	bPlaySoundOnMessageArrival=True
 	LastHistoricMessagesNumber=10
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
