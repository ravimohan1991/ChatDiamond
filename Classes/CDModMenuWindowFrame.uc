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
// The uwindow frame for client-side window
//=============================================================================

class CDModMenuWindowFrame expands UTChatWindowFrame;

 function created()
 {
 	super.created();
 
 	bLeaveOnScreen = true;
 	bStatusBar = true;
 	//if (UTWRI.bEmojis)
 	//{
 	//    bSizable = False;
 	//    bMoving = False;
 	//}
 	//else
 	//{
 		bSizable = True;
 		bMoving = true;
 		MinWinWidth  = 395;
 		MinWinHeight = 322;
 	//}
 
 	SetSizePos();
 
 	WindowTitle = "ChatDiamond - "$class'UTChat'.default.Version;;
 }
 
 defaultproperties
 {
 	XPos=50
 	YPos=40
 	ClientClass=Class'CDClientSideWindow'
 }

/*
#exec texture IMPORT NAME=Emojis1 File=Textures\emojis1.pcx GROUP=Commands Mips=on
#exec texture IMPORT NAME=Emojis2 File=Textures\emojis2.pcx GROUP=Commands Mips=off

var UWindowPageControl Pages;
var UWindowPageControlPage ACEBan;
var UWindowPageControlPage UPCSS;

function WriteText(canvas C, string text, int q)
{
     local float W, H;

     TextSize(C, text, W, H);
     ClipText(C, 10, q, text, false);
}


function Created()
{
      Super.Created();
      Saveconfig();

      WinLeft = int(Root.WinWidth - WinWidth) / 2;
      WinTop = int(Root.WinHeight - WinHeight) / 2;

      Pages = UMenuPageControl(CreateWindow(class'UMenuPageControl', 0, 0, WinWidth, WinHeight));

      Pages.SetMultiLine(True);

      Pages.AddPage("Public Chats", class'UTChatWindowChat');
      Pages.AddPage("Configs", class'UTChatWindowConfig');
      Pages.Addpage("Emojis", class'UTChatWindowEmojis');
      //Pages.AddPage("About", class'ACEM_About');

}
*/
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