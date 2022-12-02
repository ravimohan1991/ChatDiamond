/*
 *   --------------------------
 *  |  CDChatWindowChat.uc
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
// CDChatWindowChat
//
//- Here we can keep the record of just the Human sent messages
//==============================================================================

class CDChatWindowChat extends UWindowPageWindow config (ChatDiamond);

 var() config string ChatLog[200];

 var UMenuLabelControl  lblHeading;
 var UTChatTextArea     TheTextArea;
 var UTChatWinControl   EditMesg;

 var UWindowSmallButton ButSend;
 var UWindowSmallButton ButSave;
 var UWindowSmallButton ButClose;
 var UWindowSmallButton ButtonReload;

 var GameReplicationInfo CDGRI;
 var PlayerReplicationInfo LocalPRI;
 //var CDChatHUD EavesDropper;// Quite oxymoronic if I may say so
 var bool bIsWindowChatFunctional;

 var config string Chat[200];

 var color GrnColor, SilColor, YelColor, TxtColor;
 var int iTick;

//---------------------------- Options ---------------------------------

 var int ChatNum;
 var bool bAdmin, bChat;
 var string OldHelpKey;

 var float PrevWinWidth, PrevWinHeight;

 function Created ()
 {

 	Super.Created();

 	if(CDGRI == none)
 	{
 		foreach Root.GetPlayerOwner().AllActors(class'GameReplicationInfo', CDGRI)
 		break;
 	}

 	if(LocalPRI == none)
 	{
 		foreach Root.GetPlayerOwner().AllActors(class'PlayerReplicationInfo', LocalPRI)
 		break;
 	}

 	//SpawnEavesDropper();
 	//CCWindow = Root.FindChildWindow(Class'UMenu.UMenuConsoleWindow');

 	lblHeading = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0, 0, 200, 16));
 	lblHeading.Font = F_Bold;
 	lblHeading.SetText(" Date    Time   Nickname / Message ");
 	lblHeading.Align = TA_Left;
 	lblHeading.SetTextColor(GrnColor);

 	TheTextArea = UTChatTextArea(CreateControl(Class'UTChatTextArea',1, 16, 385, 212));
 	TheTextArea.AbsoluteFont = Font(DynamicLoadObject("UWindowFonts.TahomaB12", class'Font'));
 	TheTextArea.bAutoScrollbar = False;
 	TheTextArea.SetTextColor(SilColor);
 	TheTextArea.Clear();
 	TheTextArea.bChat = True;

 	ButSave = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 4, 230, 50, 25));
 	ButSave.SetText("Save");
 	ButSave.DownSound = sound'UnrealShare.FSHLITE2';

 	ButSend = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 278, 230, 50, 25));
 	ButSend.SetText("Send");
 	ButSend.DownSound = sound'UnrealShare.FSHLITE2';

 	ButClose = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 333, 230, 50, 25));
 	ButClose.SetText("Close");
 	ButClose.DownSound = sound'UnrealShare.FSHLITE2';

 	ButtonReload = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 4, 255, 380, 25));
 	ButtonReload.SetText("Reload ChatWindow");
 	ButtonReload.DownSound = sound'UnrealShare.FSHLITE2';


 	// must go here to get 1st focus
 	EditMesg = UTChatWinControl(CreateControl(Class'UTChatWinControl', 56, 230, 217, 16)); //188
 	EditMesg.EditBoxWidth = 217;
 	EditMesg.SetNumericOnly(False);
 	EditMesg.SetFont(0);
 	EditMesg.SetHistory(True);
 	EditMesg.SetValue("");
 	EditMesg.Align = TA_Left;

 	SetAcceptsFocus();
 	iTick = 50;               // LoadMessages();
 	PrevWinWidth  = WinWidth;
 	PrevWinHeight = WinHeight;
 }

 /*
 function SpawnEavesDropper()
 {
 	// We don't want multiple instances of CDChatHUD, so a smart way.
 	// Also atm the CDChatWindowChat needs be open before game is joined, in the sense, HUD is active.
 	// It is certainly not when the game is freshly initiated from the binary file
 	if(EavesDropper == none)
 	{
 		foreach Root.GetPlayerOwner().AllActors(class'CDChatHUD', EavesDropper)
 		break;

 		if(EavesDropper == none)
 		{
 			EavesDropper = Root.GetPlayerOwner().Spawn(class'CDChatHUD', Root.GetPlayerOwner(), 'NotSoSecretChatInterceptor');
 			EavesDropper.CDChatPage = self;
 			Log("Chat Page is: " $ EavesDropper.CDChatPage);
 		}
 	}
 }
 */

 function LoadMessages(optional string sMesg)
 {
 	local string sTemp;
 	local int i;

 	if (sMesg != "")
 	{
 		TheTextArea.AddText(sMesg);
 		CacheMessage(sMesg);
 	}
 	else
 	{
 		TheTextArea.Clear();
 		for (i = 0; i < 200; i++)
 		{
 			sTemp = ChatLog[i];
 			if (i > 0 && sTemp == "")
 			{
 				break;
 			}
 			TheTextArea.AddText(sTemp);
 			//sTemp = Left(sTemp, 6) $ "-" $ Mid(sTemp, 7);
 			//Chat[i] = sTemp;              // for saving
 		}
 	}
 }

 function CacheMessage(string sMesg)
 {
 	local int i;

 	for(i = 0; i < 200; i++)
 	{
 		if(ChatLog[i] == "")
 		{
 			ChatLog[i] = sMesg;
 			break;
 		}
 	}
 }

 function Notify (UWindowDialogControl C, byte E)
 {
 	Super.Notify(C,E);

 	Switch(E)
 	{
 		case DE_Change:
 			switch(C)
 				{
 				}
 		break;

 		case DE_Click:
 			switch(C)
 				{
 					case ButSave:
 						SaveConfig();
 						ButSave.bDisabled = True;
 						GetPlayerOwner().ClientMessage("All Messages have been saved to ChatDiamond.ini");
 					break;

 					case ButSend:
 						SendMessage();
 					break;

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
 	local string MessageString;

 	if (EditMesg.GetValue() != "")
 	{
 		GetPlayerOwner().ConsoleCommand("SAY " $ EditMesg.GetValue());

 		MessageString = Root.GetPlayerOwner().PlayerReplicationInfo.PlayerName $ ": " $  EditMesg.GetValue();

 		// Only for experiments. Nice way be intercepting HUD messages
 		//LoadMessages(MessageString);

 		EditMesg.SetValue("");
 	}
 }

 function Tick(float delta)
 {
 /*
    if(EavesDropper.ClientSideHUD == none || EavesDropper.ClientSideHUD.IsA('CHNullHud'))
    {
       bIsWindowChatFunctional = false;
       ButtonReload.bDisabled = false;
    }
    else
    {
       bIsWindowChatFunctional = true;
       ButtonReload.bDisabled = true;
    } */

 	if (iTick > 0)
 	{
 		iTick--;
 		if (iTick == 0)
 		{
 			LoadMessages();
 		}
 	}

 	Super.Tick(delta);
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
 		TheTextArea.SetSize(TheTextArea.WinWidth + DiffX, TheTextArea.WinHeight + DiffY);
 		TheTextArea.WrapWidth = WinWidth - 80;;

 		ButSave.WinTop += DiffY;

 		ButSend.WinLeft += DiffX;
 		ButSend.WinTop += DiffY;

 		ButClose.WinLeft += DiffX;
 		ButClose.WinTop += DiffY;

 		EditMesg.WinTop += DiffY;
 		EditMesg.SetSize(EditMesg.WinWidth + DiffX, EditMesg.WinHeight);
 		EditMesg.EditBoxWidth = EditMesg.WinWidth;

 		ButtonReload.WinTop += DiffY;
 		ButtonReload.SetSize(ButtonReload.WinWidth + DiffX, ButtonReload.WinHeight);
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
 	Super.Paint(C,MouseX,MouseY);

 	DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BlackTexture');
 	C.Style = GetPlayerOwner().ERenderStyle.STY_Normal;
 }

 function Close(optional bool bByParent)
 {
 	 //EavesDropper.Destroy();
 	Super.Close(bByParent);
 }

 defaultproperties
 {
 	SilColor=(R=180,G=180,B=180)
 	GrnColor=(R=0,G=255,B=32)
 	TxtColor=(R=255,G=255,B=255,A=0)
 	YelColor=(R=192,G=192,B=1)
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
