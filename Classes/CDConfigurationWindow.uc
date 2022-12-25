/*
 *   ---------------------------
 *  |  CDConfigurationWindow.uc
 *   ---------------------------
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
// CDConfigurationWindow
//
//- ChatDiamond configuration or calibration levers!
//==============================================================================

class CDConfigurationWindow expands UWindowPageWindow;

#exec Texture Import File=Textures\BackgroundTexture.bmp    Name=BackgroundGradation    Mips=off

 var CDModMenuWindowFrame FrameWindow;

 var UWindowHSliderControl BackGroundRedSlider;
 var UWindowHSliderControl BackGroundGreenSlider;

 var UWindowHSliderControl BackGroundBlueSlider;
 var float  PrevWinWidth, PrevWinHeight;

 function Created()
 {
 	super.Created();

 	BackGroundRedSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', 20, 40, 250, 50));
 	BackGroundRedSlider.SetTextColor(class'CDChatWindowEmojis'.default.WhiteColor);
 	BackGroundRedSlider.SetText("Red Color");
 	BackGroundRedSlider.SetRange(0, 255, 2);
 	BackGroundRedSlider.SetValue(FrameWindow.BackGroundColor.R);

 	BackGroundGreenSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', 20, 60, 250, 50));
 	BackGroundGreenSlider.SetTextColor(class'CDChatWindowEmojis'.default.WhiteColor);
 	BackGroundGreenSlider.SetText("Green Color");
 	BackGroundGreenSlider.SetRange(0, 255, 2);
 	BackGroundGreenSlider.SetValue(FrameWindow.BackGroundColor.G);

 	BackGroundBlueSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', 20, 80, 250, 50));
 	BackGroundBlueSlider.SetTextColor(class'CDChatWindowEmojis'.default.WhiteColor);
 	BackGroundBlueSlider.SetText("Blue Color");
 	BackGroundBlueSlider.SetRange(0, 255, 2);
 	BackGroundBlueSlider.SetValue(FrameWindow.BackGroundColor.B);

 	SetAcceptsFocus();

 	PrevWinWidth  = WinWidth;
 	PrevWinHeight = WinHeight;

 }

 function Notify (UWindowDialogControl C, byte E)
 {
 	super.Notify(C, E);

 	Switch(E)
 	{
 		case DE_Change:
 			switch(C)
 			{
 				case BackGroundRedSlider:
 					FrameWindow.BackGroundColor.R = BackGroundRedSlider.GetValue();
 					FrameWindow.SaveConfig();
 				break;

 				case BackGroundGreenSlider:
 					FrameWindow.BackGroundColor.G = BackGroundGreenSlider.GetValue();
 					FrameWindow.SaveConfig();
 				break;

 				case BackGroundBlueSlider:
 					FrameWindow.BackGroundColor.B = BAckGroundBlueSlider.GetValue();
 					FrameWindow.SaveConfig();
 				break;
 			}
 		break;
 	}
 }

 function Resized()
 {
 	Super.Resized();
 	Resize();

 	BackGroundRedSlider.SetValue(FrameWindow.BackGroundColor.R);
 	BackGroundGreenSlider.SetValue(FrameWindow.BackGroundColor.G);
 	BackGroundBlueSlider.SetValue(FrameWindow.BackGroundColor.B);
 }

 function Resize()
 {
 	local float DiffX, DiffY;

 	DiffX = WinWidth - PrevWinWidth;
 	DiffY = WinHeight - PrevWinHeight;
 	if ((DiffX != 0 || DiffY != 0))
 	{
 		//BackgroundRedSlider.WinLeft += DiffX;
 		//BackgroundRedSlider.WinTop += DiffY;
 	}
 	PrevWinWidth = WinWidth;
 	PrevWinHeight = WinHeight;
 }

 function BeforePaint( Canvas C, float X, float Y )
 {
 	Super.BeforePaint(C, X, Y);
 	Resize();
 }

 function Paint(Canvas C, float MouseX, float MouseY)
 {
 	Super.Paint(C, MouseX, MouseY);

 	C.DrawColor = FrameWindow.BackGroundColor;
 	DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BackgroundGradation');
 }

 function Close (optional bool bByParent)
 {
 	Super.Close(bByParent);
 }

 defaultproperties
 {
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
