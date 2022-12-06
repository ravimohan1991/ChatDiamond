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
//- Here we can keep the record of just the Human (and or bot) sent messages
//==============================================================================

class CDChatWindowChat extends UWindowPageWindow config (ChatDiamond);

 var() config string ChatLog[200];

 var UMenuLabelControl  lblHeading;
 var CDUTChatTextTextureAnimEmoteArea TheTextArea;
 var UTChatWinControl   EditMesg;

 var UWindowSmallButton ButSend;
 var UWindowSmallButton ButSave;
 var UWindowSmallButton ButtonPlaySpectate;
 var UWindowSmallButton ButtonDisconnectAndQuit;

 var GameReplicationInfo CDGRI;
 var PlayerReplicationInfo LocalPRI;
 var bool bIsWindowChatFunctional;
 var CDUTConsole ChatDiamondConsole;

 // Server being visited
 struct VisitingServerInformation
 {
 	var string CDServerName;
 	// Dragon's barbed alogrithm, in uscript, for identification
 	var string CDMD5Hash;
 };

 var VisitingServerInformation VSRP;// Visiting Server Relevant Platter
 var string TemporaryServerHash;
 var string TemporaryServerName;

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

 	CDGRI = Root.GetPlayerOwner().GameReplicationInfo;
 	LocalPRI = Root.GetPlayerOwner().PlayerReplicationInfo;

 	VSRP.CDServerName = GenerateServerName();
 	VSRP.CDMD5Hash = class'CDHash'.static.MD5(VSRP.CDServerName);

 	lblHeading = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0, 0, 200, 16));
 	lblHeading.Font = F_Bold;
 	lblHeading.SetText(" Date                                       Message ");
 	lblHeading.Align = TA_Left;
 	lblHeading.SetTextColor(GrnColor);

 	TheTextArea = CDUTChatTextTextureAnimEmoteArea(CreateControl(Class'CDUTChatTextTextureAnimEmoteArea', 1, 16, 385, 212));
 	TheTextArea.AbsoluteFont = Font(DynamicLoadObject("UWindowFonts.TahomaB12", class'Font'));
 	TheTextArea.bAutoScrollbar = False;
 	TheTextArea.SetTextColor(SilColor);
 	TheTextArea.Clear();
 	TheTextArea.bChat = True;
 	TheTextArea.bVariableRowHeight = True;
 	TheTextArea.bScrollOnResize = True;

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
 		}
 	}
 }

 function PadVerticallyWithHorizontal(optional int VerticalPaddingAmount)
 {
 	local int Counter, MaximumPadCount;


 	if(VerticalPaddingAmount > 0)
 	{
 		MaximumPadCount = VerticalPaddingAmount;
 	}
 	else
 	{
 		MaximumPadCount = 4;
 	}

 	for(Counter = 0; Counter < MaximumPadCount; Counter++)
 	{
 		TheTextArea.AddText("");
 	}
 }

/*******************************************************************************
 * Routine to generate message string and display the same
 * Please note: The message from spectators are of type `Event` and not
 * distinguishable from messages different from Say or TeamSay
 *
 * TODO:
 * 1. Server Information
 * 2. Tab for history. Public chat should be cleaned everytime game is loaded. Force clean?
 * 3. Contextual deletion of History?
 * 4. Filter default messages (for instance I have got the flag! or custom cmds)
 * 5. Face loading
 *
 * @PARAM PRI                 The PlayerReplicationInfo of involved individual
 *                            Behavior differs (as far as I understand)
 *                            1. Multiplay: PRI is that of client
 *                            2. Single Player: PRI can be of Human or bot
 * @PARAM Message             The actual message of type `Say` or `TeamSay` etc
 *                            may contain sender's name in multiplay games
 * @PARAM MessageType         The type of message like so
 *                            Say, TeamSay, and Event (should be enough here)
 *
 *******************************************************************************
 */

 function InterpretAndDisplayTextClientSide(PlayerReplicationInfo PRI, coerce string Message, name MessageType)
 {
 	local string SkinName, FaceName, DisplayableSpectatorMessage;
 	local Pawn LP;
 	local PlayerReplicationInfo SpectatorLPRI;

 	if(MessageType == 'Say' || MessageType == 'TeamSay')
 	{
 		if(PRI != none)
 		{
 			LP = Pawn(PRI.Owner);
 			LP.GetMultiSkin(LP, SkinName, FaceName);
 		}
 		else
 		{
 			FaceName = "";
 			SkinName = "";
 		}

 		if(FaceName == "")
 		{
 			FaceName = "Dummy";
 		}

 		if(SkinName == "")
 		{
 			SkinName = "Dummy";
 		}

 		if(PRI.bAdmin)
 		{
 			LoadMessages(FaceName $ ":" $ SkinName $ "::" $ LocalTimeAndMPOVMarker("+") $ "  " $ PRI.PlayerName $ ": " $ Message);
 		}
 		else if(PRI.Team == 0)
 		{
 		 LoadMessages(FaceName $ ":" $ SkinName $ "::" $ LocalTimeAndMPOVMarker("<") $ "  " $ PRI.PlayerName $ ": " $ Message);
 		}
 		else if(PRI.Team == 1)
 		{
 			LoadMessages(FaceName $ ":" $ SkinName $ "::" $ LocalTimeAndMPOVMarker(">") $ "  " $ PRI.PlayerName $ ": " $ Message);
 		}
 		else // for 4-way I need to think
 		{
 			LoadMessages(FaceName $ ":" $ SkinName $ "::" $ LocalTimeAndMPOVMarker("-") $ "  " $ PRI.PlayerName $ ": " $ Message);
 		}
 	}

 	if(PRI.bIsSpectator)
 	{
 		// Maybe exhaustive.
 		// Well, player join leave and server adds and whatnot. So we shall use
 		// our filter. Spectators' message is of the form
 		// Message = The_Cowboy:Howdy!
 		if(FilterSenderName(Message) == PRI.PlayerName)
 		{
 			DisplayableSpectatorMessage =  PrepareSpectatorMessageForDisplay(Message, SpectatorLPRI);
 			LP = Pawn(SpectatorLPRI.Owner);

 			LP.GetMultiSkin(LP, SkinName, FaceName);

 			if(FaceName == "")
 			{
 				FaceName = "Dummy";
 			}

 			if(SkinName == "")
 			{
 				SkinName = "Dummy";
 			}

 			LoadMessages(FaceName $ ":" $ SkinName $ "::" $ LocalTimeAndMPOVMarker("-") $ "  " $ PrepareSpectatorMessageForDisplay(Message));
 		}
 	}
 }

 function string PrepareSpectatorMessageForDisplay(string SpectatorMessage, optional out PlayerReplicationInfo RelevantPRI)
 {
 	local string TempoString, SpectatorName;
 	local int NameEndPosition;

 	// Assuming name has no funny character, i.e delimiter itself
 	NameEndPosition = Instr(SpectatorMessage, ":");

 	if(NameEndPosition != -1)
 	{
 		SpectatorName = Left(SpectatorMessage, NameEndPosition);
 	}

 	TempoString = Mid(SpectatorMessage, NameEndPosition + 1);

 	foreach Root.GetPlayerOwner().AllActors(class'PlayerReplicationInfo', RelevantPRI)
 	{
 		if(RelevantPRI.PlayerName == SpectatorName)
 		{
 			break;
 		}
 	}

 	return SpectatorName $ ": " $ TempoString;
 }

 function string FilterSenderName(coerce string Message)
 {
 	local int NameEndPosition;
 	local string SenderName;

 	// Assuming name has no funny character, i.e delimiter itself
 	NameEndPosition = Instr(Message, ":");

 	if(NameEndPosition != -1)
 	{
 		SenderName = Left(Message, NameEndPosition);
 	}
 	else
 	{
 		SenderName = "";
 	}

 	return SenderName;
 }


 function string GenerateServerName()
 {
 	local string GeneratedServerName;

 	if(CDGRI != none)
 	{
 		GeneratedServerName = CDGRI.ServerName;
 	}
 	else
 	{
 		GeneratedServerName = "";
 	}

 	return GeneratedServerName;
 }

/*******************************************************************************
 * Routine for modifying the console message as per our interpretation
 * and encode the deliminators accordingly
 *
 * @PARAM Message             The actual message
 * @PARAM CategoryDeliminator Categories are like so
 *                            1. - for neutral spectator (white color)
 *                            2. < for red team category
 *                            3. > for blue team category
 *                            4. = for green color  (could be 4 way team)
 *                            5. + for golden color (could be 4 way team). Admin
 *                               for now.
 *
 * @also see CDUTChatTextTextureAnimEmoteArea::DrawTextTextureLine
 *
 *******************************************************************************
 */

 function string LocalTimeAndMPOVMarker(string CategoryDeliminator)
 {
 	local string Mon, Day, Min, Hour;
 	local PlayerPawn PlayerOwner;

 	PlayerOwner = Root.GetPlayerOwner();

 	Min = string(PlayerOwner.Level.Minute);
 	if(int(Min) < 10) Min = "0" $ Min;

 	switch(PlayerOwner.Level.month)
 	{
 		case  1: Mon = "Jan"; break;
 		case  2: Mon = "Feb"; break;
 		case  3: Mon = "Mar"; break;
 		case  4: Mon = "Apr"; break;
 		case  5: Mon = "May"; break;
 		case  6: Mon = "Jun"; break;
 		case  7: Mon = "Jul"; break;
 		case  8: Mon = "Aug"; break;
 		case  9: Mon = "Sep"; break;
 		case 10: Mon = "Oct"; break;
 		case 11: Mon = "Nov"; break;
 		case 12: Mon = "Dec"; break;
 	}

 	switch(PlayerOwner.Level.dayOfWeek)
 	{
 		case 0: Day = "Sunday";    break;
 		case 1: Day = "Monday";    break;
 		case 2: Day = "Tuesday";   break;
 		case 3: Day = "Wednesday"; break;
 		case 4: Day = "Thursday";  break;
 		case 5: Day = "Friday";    break;
 		case 6: Day = "Saturday";  break;
 	}

 	if(PlayerOwner.Level.Hour < 10)
 	{
 		Hour = 0 $ string(PlayerOwner.Level.Hour);
 	}
 	else
 	{
 		Hour = string(PlayerOwner.Level.Hour);
 	}

 	return Day @ PlayerOwner.Level.Day @ Mon @ PlayerOwner.Level.Year @ CategoryDeliminator @ Hour $ ":" $ Min;
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

 		// Only for experiments.
 		// LoadMessages(MessageString);

 		EditMesg.SetValue("");
 	}
 }

 function Tick(float delta)
 {
 	if(Root.GetPlayerOwner().GameReplicationInfo != CDGRI)
 	{
 		CDGRI = Root.GetPlayerOwner().GameReplicationInfo;
 		TemporaryServerName =  GenerateServerName();

 		if(TemporaryServerName != "" && TemporaryServerName != "Another UT Server")// ye I don't know what you are doing playing on such server anyways
 		{
 			TemporaryServerHash = class'CDHash'.static.MD5(TemporaryServerName);
 			if(VSRP.CDMD5Hash != TemporaryServerHash)
 			{
 				VSRP.CDServerName = TemporaryServerName;
 				VSRP.CDMD5Hash = TemporaryServerHash;
 				LoadMessages(VSRP.CDServerName);
 			}
 		}
 	}

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

 function Paint(Canvas C, float MouseX, float MouseY)
 {
 	Super.Paint(C,MouseX,MouseY);

 	DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BlackTexture');
 	C.Style = GetPlayerOwner().ERenderStyle.STY_Normal;
 }

 function Close(optional bool bByParent)
 {
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
