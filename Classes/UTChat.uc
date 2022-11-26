//===============================================================================
//                  UTChat - by ProAsm and No0ne - 2021/22
//                 Thanks to ZeroPoint (Defrost) of Nexgen
//===============================================================================
//
class UTChat expands Mutator config(UTChat);

var() config bool   bShowChatMessages;
var() config bool   bEnableSpecsInLog;
var() config bool   bDrawUTChatLogo;
var() config bool   bNoEmoticons;
var() config bool   bNoEmojiFace;
var() config bool   bNoBotsInChat;
var() config bool   bStdDMPlayerColor;
var() config bool   bEnableStartControl;
var() config bool   bDisableAntiSpam;
var() config bool   bFontOverRide;
var() config bool   bPlayerJoinLeave;
var() config bool   bDisableChatLog;
var() config bool   bNoChatBorders;
var() config bool   bNoChatShading;
var() config bool   bAdminDuration;

var() config int    ChatDelayTime;
var() config int    ChatFontSize;
var() config int    ChatRepeatDelay;
var() config Color  ChatsTextColor;
var() config Color  OtherTextColor;

var() config string LogonMessageLine1;
var() config string LogonMessageLine2;

var() config string Chat[200];

var UTChatGRI       UTGRI;
var UTChatHud       UTHUD;
var UTChatStartUp   UTSU;
var UTChatSvrAdds   UTSA;

var bool bInitialized, bFirstTick, bNexgen, bDisBotInfo;
var string LastChatMessage;
var string sMonth, sDate, sHour, sTime;
var string PrevName, PrevMesg, PrevComplete, Version, sCode;
var int MsgPID, CurrentID, iPlayers;
var float NewTime, LastMesgTime;

var string MySpecs[11];

function PreBeginPlay()
{
    Super.PreBeginPlay();

	if (!bInitialized)
	{
		bInitialized=True;

        if (Level.Netmode != NM_StandAlone)
        {
	        if (bEnableStartControl && !DeathMatchPlus(level.game).bTournament)
		        DeathMatchPlus(Level.Game).bNetReady = False;
		}

        UTGRI = Level.Game.Spawn( class'UTChatGRI' );

	    bFirstTick = false;
        if (Level.NetMode == NM_StandAlone)
        {
            InitHUD();
            Disable('Tick');
            bFirstTick = true;
            UTGRI.bLocal = True;
        }
        else
        {
            CheckForNexgen();
        }

        MsgPID = -1;
        CurrentID = 0;
        iPlayers = 0;
        SaveConfig();

        UTSA = Level.game.Spawn(class'UTChatSvrAdds');
        UTSA.UTGRI = UTGRI;
	}
}

function PostBeginPlay()
{
    local int j;

    Super.PostBeginPlay();

    if (ChatDelayTime < 2)
        ChatDelayTime = 2;

    UTGRI.bShowChatMessages = bShowChatMessages;
    UTGRI.bNoEmoticons      = bNoEmoticons;
    UTGRI.bNoEmojiFace      = bNoEmojiFace;
    UTGRI.bNoBotsInChat     = bNoBotsInChat;
    UTGRI.bStdDMPlayerColor = bStdDMPlayerColor;
    UTGRI.ChatsTextColor    = ChatsTextColor;
    UTGRI.OtherTextColor    = OtherTextColor;
    UTGRI.RepeatDelay       = ChatRepeatDelay;
    UTGRI.ChatDelayTime     = ChatDelayTime;
    UTGRI.bDrawChatLogo     = bDrawUTChatLogo;
    UTGRI.bNoAntiSpam       = bDisableAntiSpam;
    UTGRI.bFontOverRide     = bFontOverRide;
    UTGRI.ChatFontSize      = ChatFontSize;
    UTGRI.bStartControl     = bEnableStartControl;
    UTGRI.bPlayerJoinLeave  = bPlayerJoinLeave;
    UTGRI.bNoChatLog        = bDisableChatLog;
    UTGRI.bNoChatBorders    = bNoChatBorders;
    UTGRI.bNoChatShading    = bNoChatShading;
    UTGRI.bAdminDuration    = bAdminDuration;
    UTGRI.Version = Version;

    UpdateGRI();

	Level.Game.registerMessageMutator(self);
    Level.Game.registerDamageMutator(self);

    if (Level.Game.IsA('CTFGame') || Level.Game.bTeamGame)
        UTGRI.bTeamGame = True;

    j = Rand(900);
    if (j < 100)
        j += 100;
    sCode = string(j);
    UTGRI.sCode = sCode;

	if (bEnableStartControl && !DeathMatchPlus(Level.Game).bTournament && Level.Netmode != NM_StandAlone)
	{
	    if (bShowChatMessages)
	        UTSU = Level.Game.Spawn(class'UTChatStartUp');
    }

    Level.Game.Spawn(class'UTChatReplacement');

    SetTimer(1.0, True);

    if (UTHUD == None && bShowChatMessages)
        UTHUD = Spawn(class'UTChatHud');

    CheckForSSB();
}

function CheckForNexgen()
{
	local ReplicationInfo XRI;
	local bool bSave;

    bSave = False;
    foreach AllActors(Class'ReplicationInfo', XRI)
    {
        if (XRI.IsA('NexgenConfigExt'))
        {
            bNexgen = True;
            UTGRI.bNexgen = True;
            if (XRI.GetPropertyText("enableNexgenStartControl") ~= "True")
            {
                if (bEnableStartControl && !DeathMatchPlus(level.game).bTournament)
                {
                    XRI.SetPropertyText("enableNexgenStartControl", "False");
                    bSave = True;
                }
            }
            if (XRI.GetPropertyText("useNexgenHUD") ~= "True")
            {
                if (bShowChatMessages)
                {
                    XRI.SetPropertyText("useNexgenHUD", "False");
                    bSave = True;
                }
            }
            if (bSave)
                XRI.SaveConfig();
            break;
        }
    }
}

function CheckForSSB()
{
	local ReplicationInfo XRI;

    bDisBotInfo = True;
    UTGRI.bDisBotInfo = True;

    foreach AllActors(Class'ReplicationInfo', XRI)
    {
        if (XRI.IsA('SmartSBGameReplicationInfo'))
        {
            if (XRI.GetPropertyText("bDisableBotInfo") ~= "False")
            {
                bDisBotInfo = False;
                UTGRI.bDisBotInfo = False;
                break;
            }
        }
    }
}

event Timer()
{
    local Pawn pn;

    if (!bDrawUTChatLogo)
    {
		for (pn = Level.PawnList; pn != None; pn = pn.NextPawn)
		{
		    if (pn.IsA('PlayerPawn') && pn.bIsPlayer && Level.TimeSeconds - pn.PlayerReplicationInfo.StartTime >= 5 && pn.PlayerReplicationInfo.PlayerID > MsgPID)
		    {
                pn.ClientMessage(LogonMessageLine1);
                pn.ClientMessage(LogonMessageLine2);
		        MsgPID = pn.PlayerReplicationInfo.PlayerID; // Increase to keep track of whom still to message
		    }
		}
    }

    if (Level.Game.bGameEnded && !UTGRI.bGameEnded)
        UTGRI.bGameEnded = True;

    if (bPlayerJoinLeave && !bNexgen)
        CheckIfSpecLeft();
}

function Tick(float deltaTime)
{
    local Pawn P;

    if (!bFirstTick)
    {
		bFirstTick = true;
		InitHUD();
	}

    if ( Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_StandAlone)
    {
        if (Level.Game.CurrentID > CurrentID)           // player has joined
        {
            for (P=Level.PawnList; P!=None; P=P.NextPawn)
            {
                if (P != None && P.PlayerReplicationInfo.PlayerID == CurrentID)
                    break;
            }
            if (P == None)
                return;

            CurrentID++;
            if (P.IsA('Bot'))
                CheckForBots(P);

            if (P.PlayerReplicationInfo.PlayerName != Level.Game.DefaultPlayerName) //"Player"
            {
                if (bPlayerJoinLeave)
                {
                    if (P.IsA('Spectator') && !bNexgen)
                    {
                        CheckForSpecs(P.PlayerReplicationInfo.PlayerName, True);
                        BroadcastMessage("[+Spectator] "$P.PlayerReplicationInfo.PlayerName);
                    }
                    else
                    if (P.IsA('Bot') && bDisBotInfo)
                        BroadcastMessage("[+Bot] "$P.PlayerReplicationInfo.PlayerName);
                    else
                    if (!bNexgen)
                    {
                        CheckForSpecs(P.PlayerReplicationInfo.PlayerName, False);
                        BroadcastMessage("[+Player] "$P.PlayerReplicationInfo.PlayerName);
                    }
                }

                if (!P.PlayerReplicationInfo.bIsABot)
                {
                    if (iPlayers < 32)
                    {
                        if (!CheckPlayerList(P.PlayerReplicationInfo.PlayerName))
                        {
                            UTGRI.Players[iPlayers] = P.PlayerReplicationInfo.PlayerName;
                            iPlayers++;
                        }
                    }

                    if (P.IsA('PlayerPawn') && bEnableStartControl && !DeathMatchPlus(Level.Game).bTournament)
                    {
                        if (Level.Netmode != NM_StandAlone && UTSU != None)
                        {
                            UTSU.ClientLogin(PlayerPawn(P));
                        }
                    }
                }
            }
        }
    }
	// Server side actions.
	if (Role == ROLE_Authority && bDisableAntiSpam)
	{
		DisableAntiSpam();         // Disable UT antispam.
	}
}

function DisableAntiSpam()
{
    local Pawn P;

    for (P=Level.PawnList; P!=None; P=P.NextPawn)
    {
        if (P != None && P.IsA('PlayerPawn') && !P.IsA('Bot'))
        {
            PlayerPawn(P).lastMessageWindow = 0;
		}
    }
}

function bool CheckPlayerList(string pName)
{
    local int i;

    for (i=0; i<32; i++)
    {
         if (UTGRI.Players[i] == pName)
             return true;
    }
    return false;
}

function CheckForBots(Pawn P)
{
    local int i;

    for (i=0; i<32; i++)
    {
         if (UTGRI.Botnames[i] == P.PlayerReplicationInfo.PlayerName)
             return;
    }
    for (i=0; i<32; i++)
    {
         if (UTGRI.Botnames[i] == "")
         {
             UTGRI.Botnames[i] = P.PlayerReplicationInfo.PlayerName;
             UTGRI.BotPRI[i]   = P.PlayerReplicationInfo;
             return;
         }
    }
}

function InitHUD()
{
    local string sGame, sHUD;

    sGame = string(Level.Game.Class);
    sGame = Caps(sGame);

    sHUD = string(Level.Game.HUDType);
    if (InStr(sHUD, "UTChatHud") == -1)
        UTGRI.OriginalHUDClass = Level.Game.HUDType;

    if ( bShowChatMessages )
    {
        if (UTHUD == None)
            UTHUD = Spawn(class'UTChatHud');

		if (Level.Game.HUDType == class'ChallengeTeamHUD' || classIsChildOf(level.game.HUDType, class'ChallengeTeamHUD') || UTGRI.bTeamGame)
		{
			Level.Game.HudType = class'UTChatHudTM';
		}
		else
        {
			Level.Game.HudType = class'UTChatHudDM';
        }
    }
	Log("OriginalHUDClass = "$UTGRI.OriginalHUDClass$" | Current HUD = "$Level.Game.HudType$" | ServerInfo = "$class<ChallengeHUD>(Level.Game.HUDType).default.ServerInfoClass, 'UTChat');
}

function ModifyPlayer(Pawn Other)
{
    if (!UTGRI.bGameStarted)
        UTGRI.bGameStarted = True;

    Super.ModifyPlayer(Other);
}

// used by players
function bool MutatorTeamMessage( Actor Sender, Pawn Receiver, PlayerReplicationInfo PRI, coerce string S, name Type, optional bool bBeep )
{
    if (Type == 'Say' || Type == 'TeamSay')
    {
        if ( Sender == Receiver && UTGRI.bLocal == False )
        {

            if ( S ~= "!Chat" )
            {
                OpenChatWindow(PlayerPawn(Receiver));
                return True;
            }

            if ( S ~= "!qq" )
            {
                PlayerPawn(Receiver).ClientMessage("Repeat Message From: "$LastChatMessage);
                return True;
            }

		    if (!bNoEmoticons)
		    {
		        if (S ~= ":?" || S ~= "?!" || S ~= "!emojis")
		        {
		            OpenChatWindow(PlayerPawn(Receiver), True);
		            return True;
		        }
            }
        }
    }

    if (bShowChatMessages)
    {
		if (Type == 'Say' || Type == 'TeamSay')
		{
            if (PRI != None && S != "" && Left(S, 1) != "!")
            {
                if (Level.TimeSeconds > LastMesgTime)      // stop duplicate messages
                {
                    StoreMessage(PRI.PlayerName, PRI.Team, S);
                    LastMesgTime = Level.TimeSeconds + 0.1;
                }
            }
		}
    }

	if ( NextMessageMutator != None )
		return NextMessageMutator.MutatorTeamMessage( Sender, Receiver, PRI, S, Type, bBeep );
	else
		return true;
}

// used by spectators and bots
function bool MutatorBroadcastMessage(Actor Sender, Pawn Receiver, out coerce string Msg, optional bool bBeep, out optional name type)
{
    local PlayerReplicationInfo SenderPRI;
    local string sTooo, sFrom, sMesg, sTmp;
    local int j;

    if (bPlayerJoinLeave && InStr(Msg, " entered the game.") >= 0)
    {
        Msg = "";
        Type = 'None';
        return nextMessageMutator.mutatorBroadcastMessage(sender, receiver, msg, bBeep, type);
    }

    // this routin to get specs in chatlog
    if ((Type == 'None' || Type == 'Event') && (Sender.IsA('Spectator')))
    {
        j = InStr(Msg, ":");
        if (j > 1)
        {
            sTooo = Left(Msg, j);
            sMesg = Mid(Msg, j+1);
            sTmp = Left(sMesg, 1);
            if (sTmp != "!")
            {
 	            // Get sender player replication info.
	            if (Sender != none && Sender.IsA('Pawn'))
	            {
			        SenderPRI = Pawn(Sender).PlayerReplicationInfo;
			        sFrom = SenderPRI.PlayerName;
                    if (Left(sMesg, 1) != "!")
                    {
                        if (Level.TimeSeconds > LastMesgTime)  // stop duplicate messages
                        {
                            BroadcastMessage(sTooo$":"$sMesg, True);
                            StoreMessage(sTooo, SenderPri.Team, sMesg);
                            LastMesgTime = Level.TimeSeconds + 0.200;
                        }
                        Msg = "";                              // stops repeats in console
                     }
                }
            }

            if ( Sender == Receiver && UTGRI.bLocal == False)
            {
                if ( sMesg ~= "!CHAT" )
                {
                    OpenChatWindow(PlayerPawn(Receiver));
                    return True;
                }

                if ( sMesg ~= "!qq" )
                {
                    PlayerPawn(Receiver).ClientMessage("Repeat Message From: "$LastChatMessage);
                    return True;
                }

		        if (!bNoEmoticons)
		        {
		            if (sMesg ~= ":?" || sMesg ~= "?!" || sMesg ~= "!emojis")
		            {
		                OpenChatWindow(PlayerPawn(Receiver), True);
		                return True;
		            }
                }
            }
        }
    }

    if (nextMessageMutator != none)
        return nextMessageMutator.mutatorBroadcastMessage(sender, receiver, msg, bBeep, type);
    else
        return true;
}

function bool MutatorBroadcastLocalizedMessage( Actor Sender, Pawn Receiver, out class<LocalMessage> Message, out optional int Switch, out optional PlayerReplicationInfo RelatedPRI_1, out optional PlayerReplicationInfo RelatedPRI_2, out optional Object OptionalObject )
{
	if ( NextMessageMutator != None )
		return NextMessageMutator.MutatorBroadcastLocalizedMessage( Sender, Receiver, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
	else
		return true;
}

function Mutate( string MutateString, PlayerPawn Sender )
{
    local string sTemp;
    local int i;

    if ( MutateString ~= "UTChat ShowChatLog" )
    {
        OpenChatWindow(Sender);
        return;
    }
    else
    if ( Left(MutateString, 3) == sCode && Mid(MutateString, 4) ~= "UTChatFired" )
    {
	    if (!DeathMatchPlus(Level.Game).bTournament && Level.Netmode != NM_StandAlone)
	        UTSU.PlayerPressedFire(Sender);
        return;
    }
    else
    if ( MutateString ~= "UTChat ShowEmojis" )
    {
        OpenChatWindow(Sender, True);
        return;
    }

    if (Left(MutateString, 16) == "UTChat AdminChat" || Left(MutateString, 16) == "UTChat AdminMesg")
    {
        if (Sender.PlayerReplicationInfo.bAdmin)
        {
            if (Left(MutateString, 16) == "UTChat AdminMesg")
            {
                MutateString = Mid(MutateString, 17);
                BroadcastMessage(""$MutateString, True);  // admin message
                return;
            }
            else
                MutateString = Mid(MutateString, 17);

            i = InStr(MutateString, ",");                  // chat enable
            sTemp = Left(MutateString, i);
            MutateString = Mid(MutateString, i+1);
            bShowChatMessages = bool(sTemp);

            i = InStr(MutateString, ",");                  // no emojis
            sTemp = Left(MutateString, i);
            MutateString = Mid(MutateString, i+1);
            bNoEmoticons = bool(sTemp);

            i = InStr(MutateString, ",");                  // no emoji faces
            sTemp = Left(MutateString, i);
            MutateString = Mid(MutateString, i+1);
            bNoEmojiFace = bool(sTemp);

            i = InStr(MutateString, ",");                  // no bots in chat
            sTemp = Left(MutateString, i);
            MutateString = Mid(MutateString, i+1);
            bNoBotsInChat = bool(sTemp);

            i = InStr(MutateString, ",");                  // std dm color
            sTemp = Left(MutateString, i);
            MutateString = Mid(MutateString, i+1);
            bStdDMPlayerColor = bool(sTemp);

            i = InStr(MutateString, ",");                  // repeat delay
            sTemp = Left(MutateString, i);
            MutateString = Mid(MutateString, i+1);
            ChatRepeatDelay = int(sTemp);
            UTGRI.RepeatDelay = int(sTemp);

            i = InStr(MutateString, ",");                  // chat delay
            sTemp = Left(MutateString, i);
            MutateString = Mid(MutateString, i+1);
            ChatDelayTime = int(sTemp);
            UTGRI.ChatDelayTime = int(sTemp);

            i = InStr(MutateString, ",");                  // start control
            sTemp = Left(MutateString, i);
            MutateString = Mid(MutateString, i+1);
            bEnableStartControl = bool(sTemp);
            UTGRI.bStartControl = bool(sTemp);

            i = InStr(MutateString, ",");                  // bDisableAntiSpam
            sTemp = Left(MutateString, i);
            MutateString = Mid(MutateString, i+1);
            bDisableAntiSpam = bool(sTemp);
            UTGRI.bNoAntiSpam = bool(sTemp);

            i = InStr(MutateString, ",");                  // bFontOverRide
            sTemp = Left(MutateString, i);
            MutateString = Mid(MutateString, i+1);
            bFontOverRide = bool(sTemp);
            UTGRI.bFontOverRide = bool(sTemp);

            i = InStr(MutateString, ",");                  // Font size override
            sTemp = Left(MutateString, i);
            MutateString = Mid(MutateString, i+1);
            ChatFontSize = int(sTemp);
            UTGRI.ChatFontSize = int(sTemp);

            i = InStr(MutateString, ",");                  // No Chat Borders
            sTemp = Left(MutateString, i);
            MutateString = Mid(MutateString, i+1);
            bNoChatBorders = bool(sTemp);
            UTGRI.bNoChatBorders = bNoChatBorders;

            i = InStr(MutateString, ",");                  // Disable Chatlog
            sTemp = Left(MutateString, i);
            MutateString = Mid(MutateString, i+1);
            bDisableChatLog = bool(sTemp);
            UTGRI.bNoChatLog = bDisableChatLog;

            i = InStr(MutateString, ",");                  // No Chat Shading
            sTemp = Left(MutateString, i);
            MutateString = Mid(MutateString, i+1);
            bNoChatShading = bool(sTemp);
            UTGRI.bNoChatShading = bNoChatShading;

            i = InStr(MutateString, ",");                  // Admin Duration
            sTemp = Left(MutateString, i);
            MutateString = Mid(MutateString, i+1);
            bAdminDuration = bool(sTemp);
            UTGRI.bAdminDuration = bAdminDuration;

            i = InStr(MutateString, ",");                  // clear chat log
            sTemp = Left(MutateString, i);
            if (sTemp == "1")                              // must go last
            {
                for (i=0; i<200; i++)
                     Chat[i] = "";
            }

            Sender.ClientMessage( "Admin settings updated." );
            SaveConfig();
            UpdateGRI();
        }
        else
            Sender.ClientMessage( "You require Admin access for this action!" );
        return;
    }
    Super.Mutate( MutateString, Sender );
}

function OpenChatWindow(PlayerPawn Sender, optional bool bEmoji)
{
	local UTChatWRI A, UTWRI;

    if (Level.TimeSeconds > NewTime)
    {
        UpdatePlayerBots();
        NewTime = Level.TimeSeconds + 60;
    }

	foreach AllActors(Class'UTChatWRI',A)
	{
		if ( Sender == A.Owner )
		{
			return;
		}
	}

    if (UTWRI != None)
        UTWRI.DestroyWRI();

	UTWRI = Spawn(Class'UTChatWRI',Sender,,Sender.Location);
    UTWRI.MyName = Sender.PlayerReplicationInfo.Playername;
    UTWRI.bNoChatLog = bDisableChatLog;
    UTWRI.bEmojis = bEmoji;

	if ( UTWRI == None )
	{
		Log("#### UTChat: OpenChatWindow Failed! Could not spawn ChatWRI");
		return;
	}
}

function string CheckSwearWords(string S)
{
    local string sMesg, sTemp;
    local int i, j, k, n, x;

    k = UTGRI.WordsPerMesg;
    if (k < 1)
        k = 1;
    if (k > 9)
        k = 9;

    sMesg = Caps(S);
    for (i=0; i<25; i++)
    {
         if (UTGRI.Word1[i] == "")
             break;
         for (n=0; n<k; n++)
         {
             j = InStr(sMesg, Caps(UTGRI.Word1[i]));
             if (j >= 0)
             {
                 x = Len(UTGRI.Word1[i]);
                 sTemp = Left(S, j)$UTGRI.Word2[i]$Mid(S, j + x, Len(S));
                 S = sTemp;
                 sMesg = Caps(S);
             }
         }
    }
    return S;
}

function string GetTeamSymbol(int iTem)
{
    local string sTm;

    if (iTem == 0)
        sTm = "<";
    else
    if (iTem == 1)                     // Teams 0,1,2,3,255 < > = + -
        sTm = ">";
    else
    if (iTem == 2)
        sTm = "=";
    else
    if (iTem == 3)
        sTm = "+";
    else
        sTm = "-";                     // 255 for DM sometimes
    return sTm;
}

function StoreMessage(string sName, int iTem, string sMesg)
{
    local string sTemp, sTm;
    local bool bFound;
    local int i;

    if (sName == PrevName && sMesg == PrevMesg)
        return;
    i = InStr(sName, ":");
    if (i >= 0)
        sName = Left(sName, i)$"?"$Mid(sName, i+1);

    PrevName = sName;
    PrevMesg = sMesg;

    GetDateTime();

    sMesg = CheckSwearWords(sMesg);

    sTm = GetTeamSymbol(iTem);
    sTemp = sDate$" "$sTm$" "$sTime$" ";
    sTemp = sTemp@sName$": "$sMesg;

    if (sTemp == PrevComplete)
        return;
    PrevComplete = sTemp;

    bFound = false;

    for (i=0; i<200; i++)
    {

        if (Chat[i] == "")
        {
            Chat[i] = sTemp;
            bFound = true;
            break;
        }
    }

    if (!bFound)
    {
       for (i=0; i<199; i++)
       {
            Chat[i] = Chat[i+1];
            Chat[i+1] = "";
       }
       Chat[i] = sTemp;
    }

    UpdateWRI(sTemp, "", True);

    UpdateGRI();
    SaveConfig();
    LastChatMessage = sName$": "$sMesg;
}

function int UpdateWRI(string sChat, string sToName, bool bAll)
{
	local UTChatWRI UTWRI;
	local Pawn P;
	local int x;

    x = 0;
	foreach AllActors(Class'UTChatWRI', UTWRI)
	{
		for (P = Level.PawnList; P != None; P = P.NextPawn)
		{
			if ((PlayerPawn(P) != None) && P.bIsPlayer)
			{
                if (sToName == "" && UTWRI != None)        // normal message
                {
		            UTWRI.NewChatMesg = sChat;
		            x++;
		            if (!bAll)
		                break;
		        }
		    }
		}
	}
	return x;
}

function UpdateGRI()
{
    local int i;

    if (UTGRI == none)
    {
        foreach AllActors( class'UTChatGRI', UTGRI )
        break;
    }

    for (i=0; i<200; i++)
    {
         UTGRI.ChatLog[i] = "";  // 1st clear
    }

    for (i=0; i<200; i++)
    {
         if (Chat[i] == "")
             break;
         UTGRI.ChatLog[i] = Chat[i];
    }

        UTGRI.bShowChatMessages = bShowChatMessages;
        UTGRI.bNoEmoticons      = bNoEmoticons;
        UTGRI.bNoEmojiFace      = bNoEmojiFace;
        UTGRI.bNoBotsInChat     = bNoBotsInChat;
        UTGRI.bStdDMPlayerColor = bStdDMPlayerColor;
        UTGRI.ChatsTextColor    = ChatsTextColor;
        UTGRI.OtherTextColor    = OtherTextColor;
        UTGRI.Version = Version;
}

function UpdatePlayerBots()
{
    local Pawn P;
    local int i, BT, PL;

    for (i=0; i<32; i++)
    {
        UTGRI.Players[i]  = "";
        UTGRI.BotNames[i] = "";
    }

	for (P = Level.PawnList; P != None; P = P.NextPawn)
	{
	    if (!P.IsA('Bot') && P.IsA('PlayerPawn') && P.bIsPlayer)
	    {
            UTGRI.Players[PL]  = P.PlayerReplicationInfo.PlayerName;
            PL++;
	    }
	    if (P.IsA('Bot'))
	    {
            UTGRI.BotNames[BT] = P.PlayerReplicationInfo.PlayerName;
            BT++;
	    }
	}
}

function GetDateTime()
{
	sDate = "";

	if (Level.Month < 10)
		sDate = sDate$"0"$Level.Month;
	else
		sDate = sDate$Level.Month;
    sMonth = sDate;

	if (Level.Day < 10)
		sDate = sDate$"/0"$Level.Day;
	else
		sDate = sDate$"/"$Level.Day;

        sTime = "";

	if (Level.Hour < 10)
		sTime = sTime$"0"$Level.Hour;
	else
		sTime = sTime$Level.Hour;
    sHour = sTime;

	if (Level.Minute < 10)
		sTime = sTime$":0"$Level.Minute;
	else
		sTime = sTime$":"$Level.Minute;
}

function CheckIfSpecLeft()
{
    local int i;

    for (i=0; i<10; i++)
    {
        if (MySpecs[i] == "")
            break;
        if (CheckSpecOnServer(MySpecs[i]) == false)
            CheckForSpecs(MySpecs[i], false);
    }
}

function bool CheckSpecOnServer(string sNick)
{
    local Pawn P;
	for (P = Level.PawnList; P != None; P = P.NextPawn)
	{
	    if (!P.IsA('Bot') && P.PlayerReplicationInfo != None && P.IsA('PlayerPawn'))
            if (P.PlayerReplicationInfo.PlayerName == sNick)
	            return true;                     // player found on server
    }
    return false;
}

function CheckForSpecs(string sName, bool bAdd)
{
    local int i, j;

    for (i=0; i<10; i++)
    {
        if (MySpecs[i] == sName)
        {
            if (bAdd)
                return;
            MySpecs[i] = "";
            for (j=i; j<10; j++)
            {
                MySpecs[j] = MySpecs[j+1];
            }
            MySpecs[10] = "";
            BroadcastMessage("[-Spectator] "$sName);
            return;
        }
        if (bAdd && MySpecs[i] == "")
        {
            MySpecs[i] = sName;
            return;
        }
    }
}

defaultproperties
{
    Version="v23k"
    bShowChatMessages=True
    bDrawUTChatLogo=True
    bPlayerJoinLeave=True
    ChatFontSize=14
    ChatRepeatDelay=2
    ChatDelayTime=10
    ChatsTextColor=(R=255,G=180,B=10,A=0)
    OtherTextColor=(R=50,G=200,B=200)
    LogonMessageLine1=">>> UTChat Installed <<<"
    LogonMessageLine2=">>> Type !Chat for Chat Window <<<"
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=True
}
