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
 *   December, 2022: Native experiments
 *   April, 2023: Native - scripting hybrid progress
 */

//==============================================================================
// CDChatWindowChat
//
//- Here we can keep the record of just the Human (and or bot) sent messages
//==============================================================================

class CDChatWindowChat extends UWindowPageWindow config (ChatDiamond);

// About the naming, Kernel is defined
// "the central or most important part of something."
 #exec AUDIO IMPORT FILE="Sounds\telegram.wav" NAME=MessageKernel GROUP="Sound"

 var() config string IgnorableStrings[40];

 var() config bool bIgnoreMessageFilter;

 //var config bool bUserWantsMessageSound;
 var bool bGameEnded;

 var UMenuLabelControl  lblHeading;
 var CDUTChatTextTextureAnimEmoteArea TheTextArea;
 var UWindowEditControl EditMesg;

 var UWindowSmallButton ButSend;
 var UWindowSmallButton ButClear;
 var UWindowSmallButton ButtonPlaySpectate;
 var UWindowSmallButton ButtonDisconnectAndQuit;

 var CDModMenuWindowFrame FrameWindow;
 var CDClientSideWindow CSWindow;
 var GameReplicationInfo CDGRI;
 var PlayerReplicationInfo LocalPRI;
 var bool bIsWindowChatFunctional;
 var CDUTConsole ChatDiamondConsole;
 var CDChatWindowEmojis EmoWindowPage;

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
 var CDDiscordActor CDDA;

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

 	bGameEnded = false;

 	CDGRI = Root.GetPlayerOwner().GameReplicationInfo;
 	LocalPRI = Root.GetPlayerOwner().PlayerReplicationInfo;

 	CDDA = Root.GetPlayerOwner().Spawn(class'CDDiscordActor', Root.GetPlayerOwner());
 	CDDA.WindowChat = self;

 	VSRP.CDServerName = GenerateServerName();
 	VSRP.CDMD5Hash = class'CDHash'.static.MD5(VSRP.CDServerName);

 	lblHeading = UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0, 0, 200, 16));
 	lblHeading.Font = F_Bold;
 	lblHeading.SetText("");
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
 	TheTextArea.CDChatWindow = self;
 	TheTextArea.lblChatHeading = lblHeading;

 	ButClear = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 4, 230, 50, 25));
 	ButClear.SetText("Clear");
 	ButClear.DownSound = sound'UnrealShare.FSHLITE2';

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
 	EditMesg = UWindowEditControl(CreateControl(Class'UWindowEditControl', 56, 230, 217, 16));
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

 function LoadMessages(optional string sMesg, optional bool bTalkMessage)
 {
 	local string sTemp;
 	local int i;

 	if (sMesg != "")
 	{
 		TheTextArea.AddText(sMesg);
 		CDDA.CacheChatLine(sMesg);
 		if(bTalkMessage && FrameWindow.bPlaySoundOnMessageArrival)
 		{
 			Root.GetPlayerOwner().ClientPlaySound(sound'MessageKernel');
 		}
 	}
 	else
 	{
 		TheTextArea.Clear();
 		for (i = FrameWindow.LastHistoricMessagesNumber + 1; i > 0; i--)
 		{
 			sTemp = CDDA.GetLineFromCacheBottom(i);
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
 * 5. Face loading (done)
 * 6. Player Join/Leave notififcation with time stamp
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
 	local string SkinName, FaceName, DisplayableSpectatorMessage, SenderString, PlayerName;
 	local Pawn LP;
 	local PlayerReplicationInfo SpectatorLPRI, SomeDifferentPRI;
 	local int i;

 	if(Message == "" || (bIgnoreMessageFilter && IsMessageIgnorable(Message)) || PRI == none || CDDA == none)
 	{
 		return;
 	}

 	if(MessageType == 'Say' || MessageType == 'TeamSay')
 	{
 		if(PRI != none)
 		{
 			LP = Pawn(PRI.Owner);

 			if(LP != none)
 			{
 				LP.GetMultiSkin(LP, SkinName, FaceName);
 			}
 			else
 			{
				FaceName = "";
 				SkinName = "";
 			}

 			PlayerName = PRI.PlayerName;
 		}
 		else
 		{
 			FaceName = "";
 			SkinName = "";

 			PlayerName = "NoOne";
 		}

 		if(PlayerName == "")
 		{
 			PlayerName = "NoOne";
 		}

 		if(FaceName == "")
 		{
 			FaceName = "Dummy";
 		}

 		if(SkinName == "")
 		{
 			SkinName = "Dummy";
 		}

 		CDDA.ResetJsonContainer();
 		CDDA.AddJsonKeyValue("FaceName", FaceName);
 		CDDA.AddJsonKeyValue("SkinName", SkinName);
 		CDDA.AddJsonKeyValue("LocalTime", LocalTimeAndMPOVMarker());
 		CDDA.AddJsonKeyValue("PlayerName", PlayerName);
 		CDDA.AddJsonKeyValue("ChatMessage", Message);

 		if(PRI.bAdmin)
 		{
 			CDDA.AddJsonKeyValue("Team", "Admin");
 		}
 		else if(PRI.Team == 0)
 		{
 			CDDA.AddJsonKeyValue("Team", "Red");
 		}
 		else if(PRI.Team == 1)
 		{
 			CDDA.AddJsonKeyValue("Team", "Blue");
 		}
 		else // for 4-way I need to think
 		{
 			CDDA.AddJsonKeyValue("Team", "Unknowm");
 		}

 		LoadMessages(CDDA.SerializeJson(), true);
 		CDDA.ResetJsonContainer();
 	}
 	else
 	{
 		// Maybe exhaustive.
 		// Well, player join leave and server adds and whatnot. So we shall use
 		// our filter. Spectators' message is of the form
 		// Message = The_Cowboy:Howdy!
 		if(FilterSenderName(Message) == PRI.PlayerName)
 		{
 			DisplayableSpectatorMessage =  PrepareSpectatorMessageForDisplay(Message, SpectatorLPRI);

 			if(SpectatorLPRI != none)
 			{
 				LP = Pawn(SpectatorLPRI.Owner);
 			}

 			PlayerName = PRI.PlayerName;
 			if(PlayerName == "")
 			{
 				PlayerName = "NoOne";
 			}

 			if(LP != none)
 			{
 				LP.GetMultiSkin(LP, SkinName, FaceName);
 			}

 			if(FaceName == "")
 			{
 				FaceName = "Dummy";
 			}

 			if(SkinName == "")
 			{
 				SkinName = "Dummy";
 			}

 			CDDA.ResetJsonContainer();
 			CDDA.AddJsonKeyValue("FaceName", FaceName);
 			CDDA.AddJsonKeyValue("SkinName", SkinName);
 			CDDA.AddJsonKeyValue("LocalTime", LocalTimeAndMPOVMarker());
 			CDDA.AddJsonKeyValue("PlayerName", PlayerName);
 			CDDA.AddJsonKeyValue("ChatMessage", DisplayableSpectatorMessage);
 			CDDA.AddJsonKeyValue("Team", "Spectator");

 			LoadMessages(CDDA.SerializeJson(), true);
 			CDDA.ResetJsonContainer();
 		}
 		else
 		{
 			SenderString = FilterSenderName(Message);

 			SomeDifferentPRI = none;

 			for(i = 0; i < 32; i++)
 			{
 				if (Root.GetPlayerOwner().GameReplicationInfo != none && Root.GetPlayerOwner().GameReplicationInfo.PRIArray[i] != None)
				{
					SpectatorLPRI = Root.GetPlayerOwner().GameReplicationInfo.PRIArray[i];
					if (SpectatorLPRI != none && SpectatorLPRI.bIsSpectator && !SpectatorLPRI.bWaitingPlayer && SpectatorLPRI.StartTime > 0
						&& SpectatorLPRI.PlayerName == SenderString)
					{
						SomeDifferentPRI = SpectatorLPRI;
						break;
					}
				}
 			}

 			// Ok the message may be of the case
 			// (somespectator name):hola
 			// SomeDifferentPRI seems like spectator pri
 			if(SomeDifferentPRI != none)
 			{

 				DisplayableSpectatorMessage =  PrepareSpectatorMessageForDisplay(Message);

 				LP = Pawn(SomeDifferentPRI.Owner);

 				if(LP != none)
 				{
 					LP.GetMultiSkin(LP, SkinName, FaceName);
 				}

 				if(FaceName == "")
 				{
 					FaceName = "Dummy";
 				}

 				if(SkinName == "")
 				{
 					SkinName = "Dummy";
 				}

 				PlayerName = SomeDifferentPRI.PlayerName;
 				if(PlayerName == "")
 				{
 					PlayerName = "NoOne";
 				}

 				CDDA.ResetJsonContainer();
 				CDDA.AddJsonKeyValue("FaceName", FaceName);
 				CDDA.AddJsonKeyValue("SkinName", SkinName);
 				CDDA.AddJsonKeyValue("LocalTime", LocalTimeAndMPOVMarker());
 				CDDA.AddJsonKeyValue("PlayerName", PlayerName);
 				if(DisplayableSpectatorMessage != "")
 				{
 					CDDA.AddJsonKeyValue("ChatMessage", DisplayableSpectatorMessage);
 				}
 				else
 				{
 					CDDA.AddJsonKeyValue("ChatMessage", "No Message");
 				}
 				CDDA.AddJsonKeyValue("Team", "Spectator");

 				LoadMessages(CDDA.SerializeJson(), true);
 				CDDA.ResetJsonContainer();
 			}
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

 	if(RelevantPRI != none)
 	{
 		foreach Root.GetPlayerOwner().AllActors(class'PlayerReplicationInfo', RelevantPRI)
 		{
 			if(RelevantPRI.PlayerName == SpectatorName)
 			{
 				break;
 			}
 		}
 	}

 	return TempoString;
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

/*******************************************************************************
 * A routine to gauge what to ignore and what not!
 *
 * @PARAM Message              The message to be gauged
 * @return                     True if the message is to be ignored
 *                             False if the message is not to be ignored
 *
 *******************************************************************************
 */

 function bool IsMessageIgnorable(coerce string Message)
 {
 	local int IgnorableMessageCounter;

 	// Lot of string comparison
 	for(IgnorableMessageCounter = 0; IgnorableMessageCounter < 40; IgnorableMessageCounter++)
 	{
 		// Remember the continuation concept
 		if(IgnorableStrings[IgnorableMessagecounter] == "")
 		{
 			return false;
 		}

 		if(instr(Message, IgnorableStrings[IgnorableMessageCounter]) != -1)
 		{
 			return true;
 		}
 	}

 	return false;
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
 *******************************************************************************
 */

 function string LocalTimeAndMPOVMarker()
 {
 	local string Mon, Day, Min, Hour;
 	local PlayerPawn PlayerOwner;

 	PlayerOwner = Root.GetPlayerOwner();

 	if(PlayerOwner == none)
 	return "";

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

 	return Day @ PlayerOwner.Level.Day @ Mon @ PlayerOwner.Level.Year @ Hour $ ":" $ Min;
 }

 function SetChatTextStatus(string Text)
 {
 	FrameWindow.StatusBarText = Text;
 	TheTextArea.bIsStatusSetByChatMessage = true;
 }

 function Notify (UWindowDialogControl C, byte E)
 {
 	Super.Notify(C,E);

 	if(E == DE_MouseMove)
 	{
 		if(C == ButSend)
 		{
 			FrameWindow.StatusBarText = "Send the message!";
 			TheTextArea.bIsStatusSetByChatMessage = false;
 		}

 		if(C == ButClear)
 		{
 			FrameWindow.StatusBarText = "Clear the messages in the window!";
 			TheTextArea.bIsStatusSetByChatMessage = false;
 		}

 		if(C == ButtonPlaySpectate)
 		{
 			FrameWindow.StatusBarText = "Based on the context, play or spectate!";
 			TheTextArea.bIsStatusSetByChatMessage = false;
 		}

 		if(C == ButtonDisconnectAndQuit)
 		{
 			FrameWindow.StatusBarText = "Shut down the game and do `better` things!";
 			TheTextArea.bIsStatusSetByChatMessage = false;
 		}

 		if(C == EditMesg)
 		{
 			FrameWindow.StatusBarText = "Type a message for everyone!";
 			TheTextArea.bIsStatusSetByChatMessage = false;
 		}
 	}

 	if(E == DE_MouseLeave)
 	{
 		if(C == EditMesg)
 		{
 			FrameWindow.StatusBarText = "";
 		}

 		if(C == ButSend)
 		{
 			FrameWindow.StatusBarText = "";
 		}

 		if(C == ButClear)
 		{
 			FrameWindow.StatusBarText = "";
 		}

 		if(C == ButtonPlaySpectate)
 		{
 			FrameWindow.StatusBarText = "";
 		}

 		if(C == ButtonDisconnectAndQuit)
 		{
 			FrameWindow.StatusBarText = "";
 		}
 	}

 	Switch(E)
 	{
 		case DE_Change:
 			switch(C)
 				{
 				case EditMesg:
 					if(EmoWindowPage != None && EditMesg.GetValue() != "" && EmoWindowPage.EditMesg.GetValue() != EditMesg.GetValue())
 					{
 						EmoWindowPage.EditMesg.SetValue(EditMesg.GetValue());
 					}
 				break;
 				}
 		break;

 		case DE_Click:
 			switch(C)
 				{
 					case ButClear:
 						TheTextArea.Clear();
 						GetPlayerOwner().ClientMessage("All Messages have been cleared in the window");
 					break;

 					case ButSend:
 						//class'CDDiscordActor'.static.CacheListOfFiles(EditMesg.GetValue(), class'CDDiscordActor'.static.GetGameSystemPath());
 						SendMessage();

 						//class'CDDiscordActor'.static.OpenNativeTestWindow(true, FrameWindow);
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

 function SendMessage(optional UWindowEditControl EditMessage)
 {
 	if(EditMessage != none && EditMessage.GetValue() != "")
 	{
 		GetPlayerOwner().ConsoleCommand("SAY " $ EditMessage.GetValue());
 		EditMessage.SetValue("");

 		EditMesg.SetValue("");
 	}
 	else// this class operation
 	{
 		if (EditMesg.GetValue() != "")
 		{
 			GetPlayerOwner().ConsoleCommand("SAY " $ EditMesg.GetValue());
 			EditMesg.SetValue("");

 			EmoWindowPage.EditMesg.SetValue("");
 		}
 	}
 }

 function Tick(float delta)
 {
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

 	TheTextArea.EmoSizeMultiplier = FrameWindow.EmoSize;
 	TheTextArea.TickCounterWarpNumber = (int(FrameWindow.EmoteAnimSpeed) / 24);
 	TheTextArea.bAutoScrollBar = FrameWindow.bAutoScrollChat;
 	EmoWindowPage.TheEmoDisplayArea.TickCounterWarpNumber = TheTextArea.TickCounterWarpNumber;
 	TheTextArea.AnimShockEmote.TexChatSizeFraction = 0.08 * FrameWindow.EmoSize;
 	TheTextArea.AnimTrashTalkEmote.TexChatSizeFraction = 0.08 * FrameWindow.EmoSize;
 	TheTextArea.AnimBananaEmote.TexChatSizeFraction = 0.065 * FrameWindow.EmoSize;
 	TheTextArea.AnimBarfEmote.TexChatSizeFraction = 0.08 * FrameWindow.EmoSize;
 	TheTextArea.AnimWaveEmote.TexChatSizeFraction = 0.08 * FrameWindow.EmoSize;
 	TheTextArea.AnimArseMissEmote.TexChatSizeFraction = 0.08 * FrameWindow.EmoSize;
 	TheTextArea.DateFormatIndex = FrameWindow.DateFormatIndex;

 	if(FrameWindow.bAutoScrollChat)
 	{
 	 	TheTextArea.VertSB.Pos = TheTextArea.VertSB.MaxPos;
 	}
 }

 function ChatConfigurationUpdated()
 {
 	TheTextArea.EmoSizeMultiplier = FrameWindow.EmoSize;
 	TheTextArea.TickCounterWarpNumber = (int(FrameWindow.EmoteAnimSpeed) / 24);
 	TheTextArea.bAutoScrollBar = FrameWindow.bAutoScrollChat;
 	EmoWindowPage.TheEmoDisplayArea.TickCounterWarpNumber = TheTextArea.TickCounterWarpNumber;
 	TheTextArea.AnimShockEmote.TexChatSizeFraction = 0.08 * FrameWindow.EmoSize;
 	TheTextArea.AnimTrashTalkEmote.TexChatSizeFraction = 0.08 * FrameWindow.EmoSize;
 	TheTextArea.AnimBananaEmote.TexChatSizeFraction = 0.065 * FrameWindow.EmoSize;
 	TheTextArea.AnimBarfEmote.TexChatSizeFraction = 0.08 * FrameWindow.EmoSize;
 	TheTextArea.AnimWaveEmote.TexChatSizeFraction = 0.08 * FrameWindow.EmoSize;
 	TheTextArea.AnimArseMissEmote.TexChatSizeFraction = 0.08 * FrameWindow.EmoSize;

 	if(TheTextArea.DateFormatIndex != FrameWindow.DateFormatIndex)
 	{
 		TheTextArea.DateFormatIndex = FrameWindow.DateFormatIndex;
 		lblHeading.SetText("");
 	}
 }

 function Resize()
 {
 	local float DiffX, DiffY;

 	DiffX = WinWidth - PrevWinWidth;
 	DiffY = WinHeight - PrevWinHeight;
 	if (DiffX != 0 || DiffY != 0)
 	{
 		TheTextArea.SetSize(TheTextArea.WinWidth + DiffX, TheTextArea.WinHeight + DiffY);
 		TheTextArea.WrapWidth = WinWidth - 80;

 		TheTextArea.HorizontalSB.WinTop += DiffY;
 		TheTextArea.HorizontalSB.WinWidth = WinWidth - 15;

 		ButClear.WinTop += DiffY;

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

 	if(GetPlayerOwner() != none && GetPlayerOwner().GetDefaultURL("OverrideClass") == "Botpack.CHSpectator")
 	{
 		ButtonPlaySpectate.SetText("Play");
 	}
 	else
 	{
 		ButtonPlaySpectate.SetText("Spectate");
 	}
 }

 function BeforePaint( Canvas C, float X, float Y )
 {
 	Super.BeforePaint(C, X, Y);
 	Resize();
 }

 function Paint(Canvas C, float MouseX, float MouseY)
 {
 	// local Texture SomeTextureImportedNatively;

 	Super.Paint(C, MouseX, MouseY);

 	// SomeTextureImportedNatively = CDDA.LoadTextureFromFileOnTheRun("hmm"); //class'CDDiscordActor'.static.LoadTextureFromFileOnTheRun("hmm");

 	if(FrameWindow.bApplyBGToChatWindow)
 	{
 		C.DrawColor = FrameWindow.BackGroundColor;
 		DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BackgroundGradation');
 	}
 	else
 	{
 		DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BlackTexture');
 	}
 }

 function Close(optional bool bByParent)
 {
 	Super.Close(bByParent);
 	SaveConfig();
 }

 // How about all the talk messages on ignore list?
 defaultproperties
 {
 	SilColor=(R=180,G=180,B=180)
 	GrnColor=(R=0,G=255,B=32)
 	TxtColor=(R=255,G=255,B=255,A=0)
 	YelColor=(R=192,G=192,B=1)
 	IgnorableStrings(0)="Base is uncovered!"
 	IgnorableStrings(1)="Somebody get our flag back!"
 	IgnorableStrings(2)="I've got the flag."
 	IgnorableStrings(3)="I've got your back."
 	IgnorableStrings(4)="I'm hit! I'm hit!"
 	IgnorableStrings(5)="Man down!"
 	IgnorableStrings(6)="I'm under heavy attack!"
 	IgnorableStrings(7)="You got point."
 	IgnorableStrings(8)="I've got our flag."
 	IgnorableStrings(9)="I'm in position."
 	IgnorableStrings(10)="Hang in there."
 	IgnorableStrings(11)="Control point is secure."
 	IgnorableStrings(12)="Enemy flag carrier is here."
 	IgnorableStrings(13)="I need some backup."
 	IgnorableStrings(14)="Incoming!"
 	IgnorableStrings(15)="I've got your back."
 	IgnorableStrings(16)="Objective destroyed."
 	bIgnoreMessageFilter=true
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
