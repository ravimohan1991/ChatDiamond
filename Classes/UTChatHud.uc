//===============================================================================
//              UTChatHud - by ProAsm and No0ne - 2021/22
//               Thanks to ZeroPoint (Defrost) of Nexgen
//===============================================================================

class UTChatHud expands Info config(UTChat);

#exec Texture Import File=Textures\hudbak000.pcx  Name=HudBak000     Mips=off
#exec Texture Import File=Textures\hudbak001.pcx  Name=HudBak001     Mips=off
#exec Texture Import File=Textures\hudready1.pcx  Name=HudReady1     Mips=off
#exec Texture Import File=Textures\hudstart1.pcx  Name=HudStart1     Mips=off
#exec Texture Import File=Textures\hudbak016.pcx  Name=HudBak016     Mips=off
#exec Texture Import File=Textures\hudbak032.pcx  Name=HudBak032     Mips=off
#exec Texture Import File=Textures\hudbak192.pcx  Name=HudBak192     Mips=off

var config bool  bUseUTChat;
var config bool  bSolidChat;
var config bool  bUseEmojis;
var config bool  bSwapFaces;
var config bool  bStdColor;
var config bool  bBotsInChat;
var config bool  bChatBorder;

var config float EmojiTrim;
var config int   ChatLines;
var config int   OtherLines;
var config int   MyFontSize;
var config int   ComboPos;
var config int   ShadeColor;
var config int   ChatBoxSize;
var config int   ChatDuration;
var config int   OtherDuration;

var UTChatHudX UTHUDX;
var UTChatGRI  UTGRI;

var PlayerPawn Player, PlayerOwner;

var Font  ChatFont;
var Color ChatColor, WhiteColor, GreenColor, SilverColor, GrayColor, CyanColor, YellColor;
var Color ChatHudColor, SpecHudColor;
var Color Colors[11];                   // List of colors for text.

var int   ChatTime, ChatWidth, EngVer, ThisFont;
var float ChatPos, LastRepTime;
var float xScale, baseFontHeight, ChatFontHeight, lastSetupTime, TimeSeconds, lastLevelTimeSeconds, lastResX, lastResY;

// Colors.
const C_RED = 0;
const C_BLUE = 1;
const C_GREEN = 2;   //
const C_YELLOW = 3;
const C_WHITE = 4;   //
const C_REDD = 5;
const C_TEAL = 6;
const C_CYAN = 7;    //
const C_METAL = 8;   //
const C_GOLD = 9;  //
const C_PURPLE = 10;  //

var int TestPing;

struct CustMesg
{
	var PlayerReplicationInfo PPRI;
	var string Mess;
};

struct MessageInfo                      // Structure for storing message information.
{
	var string text[5];                 // Message text list.
	var int col[5];                     // Message text colors.
	var float timeStamp;                // Time at which the message was received.
};

var CustMesg    ChatMessage[7];         // 6+1
var MessageInfo OtherMesses[9];         // 8+1
var string      Mutes[10];

var Texture Smiley;
var Texture faceImg;                    // Face texture to display in the chat message box.
var Texture FaceEmoji;
var int msgCount;                       // Number of other messages stored.

var float msgBoxLineHeight;             // Height of a line in the message box.
var float ChatBoxHeight;                // Total height of the message box.
var string LastChat, LastPri, LastSpec;

var Color SvrAddColr;
var int iTock, EmojiTime, BannerTime;

simulated function PostBeginPlay()
{
    local int i;

    Super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
    {
        iTock = 2;

        EngVer = int(Level.EngineVersion);
        UTHUDX = Spawn(class'UTChatHudX');

        CheckGRI();
        ComboPos = -1;

        if (ChatLines > 6)
            ChatLines = 6;
        if (ChatLines < 2)
            ChatLines = 2;

        if (OtherLines > 8)
            OtherLines = 8;
        if (OtherLines < 0)
            OtherLines = 0;

        if (MyFontSize > 26)
            MyFontSize = 26;
        if (MyFontSize < 10)
            MyFontSize = 10;

        for (i=0; i<6; i++)                      //clear mesg lines
        {
            ChatMessage[i].PPRI = None;
            ChatMessage[i].Mess = "";
        }

        SaveConfig();
        SetTimer(1.0, True);
        CheckGRI();
        InitColors();
    }
}

simulated function CheckChatFonts(Canvas C)
{
    local float CX;

    CheckGRI();

    ThisFont = MyFontSize;
    if (UTGRI != None && UTGRI.bFontOverRide)
        ThisFont = UTGRI.ChatFontSize;

    if (UTGRI != None && UTGRI.bNoEmoticons)
        bUseEmojis = False;

    if (UTGRI != None && UTGRI.bNoEmojiFace)
        bSwapFaces = False;

    if (MyFontSize > 24)                         // auto font
    {
        if (C.ClipX >= 600)
            ThisFont = 10;
        if (C.ClipX >= 1200)
            ThisFont = 12;
        if (C.ClipX >= 1500)
            ThisFont = 14;
        if (C.ClipX >= 1800)
            ThisFont = 16;
        if (C.ClipX >= 2100)
            ThisFont = 18;
        if (C.ClipX >= 2400)
            ThisFont = 22;
        if (C.ClipX >= 2700)
            ThisFont = 24;
    }

    ChatFont = Font(DynamicLoadObject("LadderFonts.UTLadder"$ThisFont, class'Font'));

    C.Font = ChatFont;
    C.StrLen( "M", CX, baseFontHeight );
    ChatFontHeight = baseFontHeight;
    if (bUseEmojis)
        ChatFontHeight += baseFontHeight * 0.15;
    ChatBoxHeight = (ChatFontHeight * ChatLines) + (baseFontHeight * 0.5);
    msgBoxLineHeight = int(baseFontHeight + 4.0);
}

simulated function CheckGRI()
{
    if ( UTGRI == None )
    {
        foreach AllActors( class'UTChatGRI', UTGRI )
        break;
    }
}

simulated function Texture CheckForEmoji(string sTex)
{
    local string sTemp;
    local int i;

    FaceEmoji = None;

    for (i=0; i<28; i++)
    {
         sTemp = UTHUDX.GetEmojiSym(i);
         if (Caps(sTemp) == Caps(sTex))
         {

             if (bSwapFaces)
                 FaceEmoji = UTHUDX.GetEmojiTex(i, false);
             if (bUseEmojis)
                 return UTHUDX.GetEmojiTex(i, true);
         }
    }
    return FaceEmoji;
}

simulated function Texture CheckForWords(string sTex)
{
    local string sTemp;
    local int i;

    FaceEmoji = None;

    for (i=0; i<10; i++)
    {
         sTemp = UTHUDX.WordEmojis[i].Symbol;
         if (Caps(sTemp) == Caps(sTex))
         {
             if (bUseEmojis)
                 return UTHUDX.WordEmojis[i].Image1;
         }
    }
    return None;
}

simulated function Message(string Msg, name msgType, PlayerReplicationInfo Pri1, PlayerReplicationInfo Pri2)
{
	local int PlayerColor;
	local int messageColor;
	local bool bIsSpecSayMsg, bAddToBox;
	local GameReplicationInfo gri;
	local int index, j;
	local string locationName, sName, sMesg;

    if (UTGRI.bPlayerJoinLeave && !UTGRI.bNexgen)
    {
        if (InStr(Msg, "entered the game.") >= 0)
        {
            Msg = "";
            return;
        }
    }

	// Check if the message was sent by a spectator using say.
	if ((msgType == 'Event' || msgType == 'None') && (InStr(msg, ":") > 0))
	{
        CheckGRI();

        if (UTGRI != None)
        {
	        if (bBotsInChat || UTGRI.bLocal)
	        {
	            j = InStr(msg, ":");
	            sName = Left(msg, j);
	            sMesg = Mid(msg, j+2);
	            bAddToBox = false;

	            for (j=0; j<32; j++)
	            {
	                 if (UTGRI.BotNames[j] == sName && sName != "")
	                 {
	                     bAddToBox = True;
	                     Pri1 = UTGRI.BotPRI[j];
	                     msg = sMesg;
	                     break;
	                 }
	            }
	        }
	    }
    }

    if ((UTGRI != None && UTGRI.bLocal == True) && (msgType == 'Say' || msgType == 'TeamSay'))
    {
        if ( Msg ~= "!CHAT" )
        {
            if (PlayerOwner != None)
                PlayerOwner.ConsoleCommand("Mutate UTChat ShowChatLog");
            return;
        }
    }

	if (msgType == 'Event' && InStr(msg, ":") > 0 && !bAddToBox)
	{
		// Get shortcut to the game replication info.
		gri = Player.GameReplicationInfo;

		// Find a player.
		while (index < arrayCount(gri.PRIArray) && gri.PRIArray[index] != none)
		{
			if (gri.PRIArray[index].bIsSpectator && left(Msg, len(gri.PRIArray[index].playerName) + 1) ~= (gri.PRIArray[index].playerName $ ":"))
 		    {
				if (bIsSpecSayMsg)
				{
					if (len(gri.PRIArray[index].playerName) > len(Pri1.playerName))
					{
						Pri1 = gri.PRIArray[index];
					}
				}
				else
				{
					bIsSpecSayMsg = true;
					Pri1 = gri.PRIArray[index];
				}
			}
			index++;
		}
	}

    Msg = CheckBadWording(Msg);                            // check for swearing etc

	// Check message type.
	if (bIsSpecSayMsg)                                     // spectator
	{
		j = InStr(Msg, ":");                               // added to remove spec double names
		if (j > 1)
		{
		    if ((Msg != LastSpec) || (Level.TimeSeconds > LastRepTime)) // clears after x second
		    {
		        LastSpec = Msg;
                Msg = Mid(Msg, j+1);
                faceImg = Texture'Faceless';
 		        AddChatMessage(Pri1, Msg);
 		        if (UTGRI.RepeatDelay == 0)
 		            LastRepTime = Level.TimeSeconds + 0.100000;
 		        else
 		            LastRepTime = Level.TimeSeconds + UTGRI.RepeatDelay;
 		    }
 		    else
 		        Msg = "";
	    }
	}
	else
	if (Pri1 != none && msg != "" && (msgType == 'Say' || msgType == 'TeamSay' || bAddToBox))
	{
		// Chat message.
		PlayerColor = getPlayerColor(Pri1);
		if (Level.NetMode != NM_StandAlone && Pri1.bIsABot && !bBotsInChat && !bAddToBox)
		{
		    AddMsg(5, "", PlayerColor, Pri1.PlayerName$": ", 6, msg);
            return;
		}

		if (Pri1.talkTexture != none)
		{
			faceImg = Pri1.talkTexture;
		}

		if (msgType == 'TeamSay')
		{
			if (Pri1.bIsSpectator && !Pri1.bWaitingPlayer)
			{
				messageColor = C_WHITE;
			}
			else
			{
				messageColor = C_GREEN;
			}

			if (!Pri1.bIsSpectator)
			{
			    if (Pri1.playerLocation != none)
			    {
			        locationName = Pri1.playerLocation.locationName;
			    }
			    else
			    if (Pri1.playerZone != none)
			    {
					locationName = Pri1.playerZone.zoneName;
				}
			}
		}
		else
		{
			if (Pri1.bIsSpectator && !Pri1.bWaitingPlayer)
			{
				messageColor = C_METAL;
			}
			else
			{
				messageColor = C_GOLD;
			}
		}

        if (bUseUTChat && UTGRI.bShowChatMessages)
        {
		    if ((Msg != LastChat && Pri1.PlayerName != LastPri) || (Level.TimeSeconds > LastRepTime)) // clears after x second
			{
		        LastChat = Msg;
			    AddChatMessage(Pri1, Msg);
	            if (UTGRI.RepeatDelay == 0 || UTGRI.bGameEnded)
	                LastRepTime = Level.TimeSeconds + 0.100000;
	            else
	                LastRepTime = Level.TimeSeconds + UTGRI.RepeatDelay;
			}
        }
        else
        if (msg != "")
            addColorizedMessage(Msg, Pri1, Pri2);
	}
	else
	if (msg != "")
	{
		// Other messages.
	    addColorizedMessage(Msg, Pri1, Pri2);
	}
}

simulated function string CheckBadWording(string S)
{
    local string sMesg, sTemp;
    local int i, j, k, n, x;

    CheckGRI();

    if (UTGRI != None)
    {
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
    }
    return S;
}

simulated function int getPlayerColor(PlayerReplicationInfo pri)
{
	local int colorNum;

	if (pri != None && pri.bIsSpectator && !pri.bWaitingPlayer)
	{
		colorNum = C_METAL;
	}
	else
	if (pri != None && pri.team < 4)
	{
		colorNum = pri.team;
	}
	else
	{
		colorNum = C_WHITE;
	}

	return colorNum;
}

simulated function bool CheckForBot(string sNick)
{
    local int j;

	for (j=0; j<32; j++)
	{
	     if (UTGRI.BotNames[j] == sNick && sNick != "")
	         return True;
	}
    return False;
}

simulated function addColorizedMessage(string msg, PlayerReplicationInfo pri1, PlayerReplicationInfo pri2)
{
	local string firstPlayerName;
	local string secondPlayerName;
	local int firstIndex;
	local int secondIndex;
	local int firstPlayerColor;
	local int secondPlayerColor;
	local string msgPart1;
	local string msgPart2;
	local string msgPart3;
	local int msgColor;
	local string tempPlayerName;
	local int tempIndex;
	local int tempPlayerColor, x;

	msgColor = C_CYAN;

	if (msg ~= "<<< Press [Fire] to start the Game >>>")   // utchat
	{
        msgColor = C_GOLD;
	}

    if (Left(msg, 20) == "Repeat Message From:")
    {
        msgColor = C_WHITE;
    }

    if (msg ~= "All messages have been saved to UTChatlog.ini")
    {
        msgColor = C_WHITE;
    }

    if (InStr(msg, "has started the game!") >= 0)
    {
        x = InStr(msg, "!");
        msg = Left(msg, x)$".";
        msgColor = C_GOLD;
    }

	// Get player name indices.
	getPlayerNameIndices(msg, pri1, pri2, firstIndex, secondIndex);

	// Get player names & colors.
	if (pri1 != none)
	{
		firstPlayerName = pri1.playerName;
		firstPlayerColor = getPlayerColor(pri1);
	}

	if (pri2 != none)
	{
		secondPlayerName = pri2.playerName;
		secondPlayerColor = getPlayerColor(pri2);
	}

	// Swap first and second player if necessary.
	if (secondIndex >= 0 && (secondIndex < firstIndex || firstIndex < 0))
	{
		tempPlayerName = secondPlayerName;
		tempIndex = secondIndex;
		tempPlayerColor = secondPlayerColor;
		secondPlayerName = firstPlayerName;
		secondIndex = firstIndex;
		secondPlayerColor = firstPlayerColor;
		firstPlayerName = tempPlayerName;
		firstIndex = tempIndex;
		firstPlayerColor = tempPlayerColor;
	}

	// Split message.
	if (firstIndex >= 0 && secondIndex >= 0)
	{
		msgPart1 = left(msg, firstIndex);
		msgPart2 = mid(msg, firstIndex + len(firstPlayerName), secondIndex - firstIndex - len(firstPlayerName));
		msgPart3 = mid(msg, secondIndex + len(secondPlayerName));
	}
	else
	if (firstIndex >= 0)
	{
		msgPart1 = left(msg, firstIndex);
		msgPart2 = mid(msg, firstIndex + len(firstPlayerName));
		secondPlayerName = "";
	}
	else
	{
		firstPlayerName = "";
		secondPlayerName = "";
		msgPart1 = msg;
	}

    if (UTGRI.bPlayerJoinLeave && !UTGRI.bNexgen)
    {
        if (InStr(msg, "entered the game.") >= 0 || Right(msg, 17) ~= "entered the game.")
            return;

        if (InStr(msg, " left the game.") >= 0)
        {
            x = InStr(msg, " left the game.");
            tempPlayerName = Left(msg, x);
            if (pri1 != None && pri1.bIsSpectator)         // never comes here
                msgPart1 = "[-Spectator] ";
            else
            if (pri1 != None && pri1.bIsABot && UTGRI.bDisBotInfo)
                msgPart1 = "[-Bot] ";
            else
            if (CheckForBot(tempPlayerName) && UTGRI.bDisBotInfo)
                msgPart1 = "[-Bot] ";
            else
                msgPart1 = "[-Player] ";
            msgPart2 = "";
            msgPart3 = "";
            firstPlayerName = "";
            firstPlayerColor = 0;
            SecondPlayerName = Left(msg, x);
            secondPlayerColor = getPlayerColor(pri1);
            msg = "";
        }

        if (Left(msg, 10) ~= "[+Player] " || Left(msg, 13) ~= "[+Spectator] " || Left(msg, 13) ~= "[-Spectator] " || Left(msg, 7) ~= "[+Bot] ")
        {
            if (Left(msg, 10) ~= "[+Player] ")
            {
                msgPart1 = Left(msg, 10);
                msgPart2 = "";
                msgPart3 = "";
                firstPlayerName = "";
                firstPlayerColor = 0;
                secondPlayerName = Mid(msg, 10);
                secondPlayerColor = getPlayerColor(pri1);
                msg = "";
            }
            else
            if (Left(msg, 13) ~= "[+Spectator] " || Left(msg, 13) ~= "[-Spectator] ")
            {
                msgPart1 = Left(msg, 13);
                msgPart2 = "";
                msgPart3 = "";
                firstPlayerName = "";
                firstPlayerColor = 0;
                secondPlayerName = Mid(msg, 13);
                secondPlayerColor = getPlayerColor(pri1);
                msg = "";
            }
            else
            {
                msgPart1 = Left(msg, 7);
                msgPart2 = "";
                msgPart3 = "";
                firstPlayerName = "";
                firstPlayerColor = 0;
                secondPlayerName = Mid(msg, 7);
                secondPlayerColor = getPlayerColor(pri1);
                msg = "";
            }
        }

    }

	// Add message.
	AddMsg(msgColor, msgPart1, firstPlayerColor, firstPlayerName, msgColor, msgPart2, secondPlayerColor, secondPlayerName, msgColor, msgPart3);
}

simulated function getPlayerNameIndices(string msg, out PlayerReplicationInfo pri1, out PlayerReplicationInfo pri2, out int index1, out int index2)
{
	local PlayerReplicationInfo tmpPRI;
	local GameReplicationInfo gri;
	local int index;
	local int nameIndex;

	// Get shortcut to the game replication info.
	gri = player.gameReplicationInfo;

    if (gri == None)
        return;

	// Initially no indices have been found.
	index1 = -1;
	index2 = -1;

	// Check if the first PRI is actually in the message. This appears not to be the case for some
	// messages (for example with the Stranglove weapon mod).
	if (pri1 != none && instr(msg, pri1.playerName) < 0)
	{
		pri1 = none;
	}

	// Swap player replication info's if needed.
	if (pri1 == none && pri2 != none)
	{
		pri1 = pri2;
		pri2 = none;
	}
	else
	if (pri1 != none && pri2 != none && len(pri2.playerName) > len(pri1.playerName))
	{
		// Ensure the longest playername is located first.
		tmpPRI = pri1;
		pri1 = pri2;
		pri2 = tmpPRI;
	}

	// Get the position of the first player name in the message.
	if (pri1 == none)
	{
		// No PRI found, try to find one.
		index = 0;
		while (index < arrayCount(gri.PRIArray) && gri.PRIArray[index] != none)
		{

			// Get current player replication info.
			tmpPRI = gri.PRIArray[index];

			// Get position of the players name in the message.
			nameIndex = instr(msg, tmpPRI.playerName);

			// Select PRI?
			if (nameIndex >= 0 && (pri1 == none || len(tmpPRI.playerName) > len(pri1.playerName)))
			{
				// Yes, no name has been found so far or a longer player name has been found.
				pri1 = tmpPRI;
				index1 = nameIndex;
			}

			// Continue with next player name.
			index++;
		}
	}
	else
	{
		// Already got PRI, just find the index of the name.
		index1 = instr(msg, pri1.playerName);
	}

	// Get the position of the second player name in the message.
	if (pri1 != none && pri2 == none)
	{
		// No PRI found, try to find one.
		index = 0;
		while (index < arrayCount(gri.PRIArray) && gri.PRIArray[index] != none)
		{
			// Get current player replication info.
			tmpPRI = gri.PRIArray[index];

			// Get position of the players name in the message.
			nameIndex = instr(msg, tmpPRI.playerName);

			// Check for overlap.
			if (index1 >=0 && nameIndex >= 0 && index1 <= nameIndex && nameIndex < index1 + len(pri1.playerName))
			{
				// Overlap detected, check if name occurs after the first player name.
				nameIndex = instr(mid(msg, index1 + len(pri1.playerName)), tmpPRI.playerName);
				if (nameIndex >= 0)
				{
					nameIndex += index1 + len(pri1.playerName);
				}
			}

			// Select PRI?
			if (nameIndex >= 0 && (pri2 == none || len(tmpPRI.playerName) > len(pri2.playerName)))
			{
				// Yes, no name has been found so far or a longer player name has been found.
				pri2 = tmpPRI;
				index2 = nameIndex;
			}

			// Continue with next player name.
			index++;
		}

	}
	else
	if (pri2 != none)
	{
		// Already got PRI, just find the index of the name.
		nameIndex = instr(msg, pri2.playerName);

		// Check for overlap.
		if (index1 >= 0 && nameIndex >= 0 && index1 <= nameIndex && nameIndex < index1 + len(pri1.playerName))
		{
			// Overlap detected, check if name occurs after the first player name.
			nameIndex = instr(mid(msg, index1 + len(pri1.playerName)), pri2.playerName);
			if (nameIndex >= 0)
			{
				nameIndex += index1 + len(pri1.playerName);
			}
		}

		// Set index.
		index2 = nameIndex;
	}
}

simulated function AddMsg(int col1, string text1, optional int col2, optional string text2, optional int col3, optional string text3,
                          optional int col4, optional string text4, optional int col5, optional string text5)
{
	local int index;

    if (Left(Text1, 1) == "")         // admin message
    {
        Text1 = Mid(Text1, 1);
        col1 = C_WHITE;
        col2 = C_WHITE;
        col3 = C_WHITE;
        col4 = C_WHITE;
    }

	// Find position in messages list.
	if (msgCount < OtherLines)
	{
		index = msgCount;
		msgCount++;
	}
	else
	{
		// List is full, shift messages.
		for (index = 1; index < msgCount; index++)
		{
			OtherMesses[index - 1] = OtherMesses[index];
		}
		index = msgCount - 1;
	}

	// Store message.
	OtherMesses[index].text[0] = text1;
	OtherMesses[index].text[1] = text2;
	OtherMesses[index].text[2] = text3;
	OtherMesses[index].text[3] = text4;
	OtherMesses[index].text[4] = text5;
	OtherMesses[index].col[0] = col1;
	OtherMesses[index].col[1] = col2;
	OtherMesses[index].col[2] = col3;
	OtherMesses[index].col[3] = col4;
	OtherMesses[index].col[4] = col5;
	OtherMesses[index].TimeStamp = TimeSeconds;
}

simulated function Timer()
{
	local int i;

	Super.Timer();

    if (Level.NetMode != NM_DedicatedServer)
    {

        if (UTGRI == None)
            CheckGRI();

        if (iTock > 0)
        {
            iTock--;
            if (iTock == 0)
            {
                if (UTGRI != None)
                {
                    if (UTGRI.bNoEmoticons)      // check admin settings
                        bUseEmojis = False;
                    if (UTGRI.bNoEmojiFace)
                        bSwapFaces = False;
                    if (UTGRI.bNoBotsInChat)
                        bBotsInChat = False;
                    if (UTGRI.bStdDMPlayerColor)
                        bStdColor = True;
                }
            }
        }
    }

    if (ChatTime > 0)
    {
        ChatTime--;
        if (ChatTime == 0)
        {
            ScrollChatMessages();
            for (i=0; i<ChatLines; i++)
            {
                if (ChatMessage[i].Mess != "")
                {
                    CheckGRI();
                    if (UTGRI != None && UTGRI.bAdminDuration)
                        ChatTime = UTGRI.ChatDelayTime;
                    else
                        ChatTime = ChatDuration;
                    if (Len(ChatMessage[i].Mess) < 6 && ChatMessage[i+1].Mess != "")
                        ChatTime = ChatTime / 2;
                    break;
                }
            }
        }
    }

    if (EmojiTime > 0)
        EmojiTime--;

    if (BannerTime > 0)
        BannerTime--;
}

simulated function InitColors()
{
    CheckGRI();
    if (UTGRI == None)
        return;

    ChatColor = UTGRI.ChatsTextColor;
    Colors[7] = UTGRI.OtherTextColor;

    ChatColor = CheckForBlack(ChatColor, True);
    Colors[7] = CheckForBlack(Colors[7], False);
}

simulated function ScrollChatMessages()
{
    local int i;

    for (i=0; i<ChatLines; i++)
    {
         ChatMessage[i].PPRI = ChatMessage[i+1].PPRI;
         ChatMessage[i].Mess = ChatMessage[i+1].Mess;
         ChatMessage[i+1].PPRI = None;
         ChatMessage[i+1].Mess = "";
    }
}

simulated function PreRenderHUD(Canvas C)
{
	Player = C.Viewport.Actor;
    Setup(C);
}

simulated function postRenderHUD(Canvas C)
{
    CheckGRI();

	if (UTGRI != None && UTGRI.bShowChatMessages && bUseUTChat)
	{
	    DrawMessageBox(C);
	}
}

simulated function Setup(Canvas C)
{
	local int index, Dur;
	local bool bUpdateBase;

    if (UTGRI == None)
        CheckGRI();

    InitColors();

    // Make sure the font ain't none.
	CheckChatFonts(C);

	// Get local PlayerPawn.
	Player = C.Viewport.Actor;

    xScale = (ChallengeHUD(Player.myHUD).HUDScale * C.ClipX) / 1280.0;


	// Set base hud color.
    if (UTGRI != None && UTGRI.bTeamGame)
    {
        if (Player.PlayerReplicationInfo != None && Player.PlayerReplicationInfo.Team < 4)
            ChatHudColor = class'ChallengeTeamHUD'.default.TeamColor[Player.PlayerReplicationInfo.Team];
    }
    else
    {
        ChatHudColor = ChallengeHUD(Player.myHUD).HUDColor;
    }

	// Prevent redundant setups.
	if (lastSetupTime == Level.TimeSeconds)
	{
		return;
	}

	// Timer control.
	TimeSeconds += (Level.TimeSeconds - lastLevelTimeSeconds) / Level.TimeDilation;
	lastLevelTimeSeconds = Level.TimeSeconds;

	// Check if the base variables need to be updated.
	bUpdateBase = lastResX != c.clipX || lastResY != c.clipY;

	// Update HUD base variables.
	if (bUpdateBase)
	{
		// General variables.
		C.font = ChatFont;
		CheckChatFonts(C);
		lastResX = c.clipX;
		lastResY = c.clipY;
	}

    Dur = OtherDuration;
    if (UTGRI != None && UTGRI.bAdminDuration)
        Dur = 10;

	// Remove expired messages.
	if (msgCount > 0 && TimeSeconds - OtherMesses[0].TimeStamp > Dur)
	{
		for (index = 1; index < msgCount; index++)
		{
			OtherMesses[index - 1] = OtherMesses[index];
		}
		msgCount--;
	}

	lastSetupTime = Level.TimeSeconds;
}

simulated function DrawTypingPrompt( canvas Canvas, console Console )
{
	local string TypingPrompt;
	local float MyOldClipX, OldClipY, OldOrgX, OldOrgY, YPos;
	local Color ThisColor;

    ThisColor = Canvas.DrawColor;

    CheckChatFonts(Canvas);
    CheckGRI();

	MyOldClipX = Canvas.ClipX;
	OldClipY = Canvas.ClipY;
	OldOrgX = Canvas.OrgX;
	OldOrgY = Canvas.OrgY;

	Canvas.DrawColor = GreenColor;
	TypingPrompt = "(>"@Console.TypedStr$"_";
	YPos = ChatFontHeight * ChatLines + 4;
	if (bUseEmojis)
	    YPos += 4;
	Canvas.SetOrigin(0, FMax(0,YPos + 7 * xScale));
	Canvas.SetPos( 0, 0 );

    Canvas.SetClip( ChatWidth-100, Canvas.ClipY );
    Canvas.DrawTextClipped( TypingPrompt, false );

	Canvas.SetOrigin( OldOrgX, OldOrgY );
	Canvas.SetClip( MyOldClipX, OldClipY );

	Canvas.DrawColor = ThisColor;
}

simulated function AddChatMessage(PlayerReplicationInfo PR, string Mesg)
{
    local int i;

    for (i=0; i<10; i++)
    {
         if ((Mutes[i] != "") && (PR.PlayerName == Mutes[i]))
             return;
    }

    if (Mesg == ":?")
    {
        if (EmojiTime == 0)
            EmojiTime = 10;
        else
            return;
    }

    if (Mesg == "?!")
    {
        if (BannerTime == 0)
            BannerTime = 10;
        else
            return;
    }

    CheckGRI();
    for (i=0; i<ChatLines; i++)
    {
        if (ChatMessage[i].Mess == "")
        {
            ChatMessage[i].PPRI = PR;
            ChatMessage[i].Mess = Mesg;
            if (UTGRI != None && UTGRI.bAdminDuration)
                ChatTime = UTGRI.ChatDelayTime;
            else
                ChatTime = ChatDuration;
            return;
        }
    }

    ScrollChatMessages();
    ChatMessage[ChatLines-1].PPRI = PR;
    ChatMessage[ChatLines-1].Mess = Mesg;
    if (UTGRI != None && UTGRI.bAdminDuration)
        ChatTime = UTGRI.ChatDelayTime;
    else
        ChatTime = ChatDuration;
}

simulated function bool CheckForMessages()
{
    local int i;

    for (i=0; i<ChatLines; i++)
    {
        if (ChatMessage[i].Mess != "")
            return True;
    }

    return False;
}

simulated function DrawChatArea( Canvas Canvas, int CX )
{
    local float XL, YL, SC, X1, X2, StatScale;
    local Color ThisColor, MyColor;

    CheckGRI();
    CheckChatFonts(Canvas);
	Canvas.Font = ChatFont;
	Canvas.StrLen("M", XL, YL);

    if (PlayerOwner == None)
        return;

    if (PlayerOwner.PlayerReplicationInfo == None)
        return;

    ThisColor = Canvas.DrawColor;
	Canvas.Style = ERenderStyle.STY_Translucent;

	Canvas.SetPos(0, 0);
    SC = ShadeColor;
    SC = SC/128;

    if (UTGRI != None && UTGRI.bNoChatShading)
        SC = 0;

    if (PlayerOwner.PlayerReplicationInfo.bIsSpectator && UTGRI != None && UTGRI.bTeamGame)
        MyColor = SpecHudColor;
    else
        MyColor = ChatHudColor;

    Canvas.DrawColor = MyColor * SC;

    StatScale = ChallengeHUD(Player.myHUD).Scale * ChallengeHUD(Player.myHUD).StatusScale;

	X1 = CX - 128 * StatScale - 140 * ChallengeHUD(Player.myHUD).Scale;
	if (ChallengeHUD(PlayerOwner.myHUD).bHideStatus)
	    X1 = CX - 140 * ChallengeHUD(Player.myHUD).Scale;
    if (ChallengeHUD(PlayerOwner.myHUD).bHideAllWeapons)
        X1 = CX - 10 * ChallengeHUD(Player.myHUD).Scale;
    if (PlayerOwner.PlayerReplicationInfo.bWaitingPlayer)
        X1 = CX - 270 * ChallengeHUD(Player.myHUD).Scale;
    if (PlayerOwner.PlayerReplicationInfo.bIsSpectator)
        X1 = X1 - 182;
    X1 -= 4;

    if (ChatBoxSize > 0 && ChatBoxSize < 11)               //
        X1 -= ChatBoxSize * 50;

    X2 = X1 - 100;

    ChatWidth = int(X1 - 20);

    if (bSolidChat && !UTGRI.bNoChatShading)
    {
        if (ShadeColor == 0)
	        Canvas.Style = ERenderStyle.STY_Normal;
	    else
            Canvas.Style = ERenderStyle.STY_Modulated;
        Canvas.SetPos(0, 0);
        if (ShadeColor > 10)
            Canvas.DrawRect( Texture'HudBak032', X1, ChatBoxHeight );
        else
            Canvas.DrawRect( Texture'HudBak016', X1, ChatBoxHeight );
        Canvas.Style = ERenderStyle.STY_Translucent;
    }

    if (bChatBorder && !UTGRI.bNoChatBorders)
    {
        if (ShadeColor > 95)
	        Canvas.Style = ERenderStyle.STY_Normal;
        Canvas.SetPos(0, 0);
        Canvas.DrawRect( Texture'HudBak192', X1, ChatBoxHeight );
        Canvas.DrawColor = MyColor * 0.4;
        Canvas.SetPos(0, 0);
        Canvas.Style = ERenderStyle.STY_Translucent;
        Canvas.DrawRect( Texture'HudBak000', X1, ChatBoxHeight );
    }
    else
    {
        if (ShadeColor > 95)
	        Canvas.Style = ERenderStyle.STY_Normal;
        Canvas.SetPos(0, 0);
        Canvas.DrawRect( Texture'HudBak192', X1, ChatBoxHeight );
    }

    if (bChatBorder && !UTGRI.bNoChatBorders)
    {
        if (UTGRI.bReady)
        {
            Canvas.SetPos(X1, 1);
            Canvas.Style = ERenderStyle.STY_Translucent;
            Canvas.DrawColor = MyColor * 0.5;
            Canvas.DrawRect( Texture'HudReady1', 100, YL * 1.60 );
        }

        if (UTGRI.bStart)
        {
            Canvas.SetPos(X1, 1);
            Canvas.Style = ERenderStyle.STY_Translucent;
            Canvas.DrawColor = MyColor * 0.5;
            Canvas.DrawRect( Texture'HudStart1', 100, YL * 1.60 );
        }
    }

    if ( Player.Player.Console.bTyping )
    {
	    Canvas.Style = ERenderStyle.STY_Translucent;
        Canvas.DrawColor = MyColor * SC;

        if (bSolidChat)
        {
            if (ShadeColor == 0)
		        Canvas.Style = ERenderStyle.STY_Normal;
		    else
                Canvas.Style = ERenderStyle.STY_Modulated;
            Canvas.SetPos(0, ChatBoxHeight);
            if (ShadeColor > 10)
                Canvas.DrawRect( Texture'HudBak032', X2, YL * 1.60);
            else
                Canvas.DrawRect( Texture'HudBak016', X2, YL * 1.60 );
            Canvas.Style = ERenderStyle.STY_Translucent;
        }

	    if (bChatBorder && !UTGRI.bNoChatBorders)
	    {
            if (ShadeColor > 95)
	            Canvas.Style = ERenderStyle.STY_Normal;
            Canvas.SetPos(0, ChatBoxHeight);
            Canvas.DrawRect( Texture'HudBak192', X2, YL * 1.60 );
            Canvas.DrawColor = MyColor * 0.4;
            Canvas.SetPos(0, ChatBoxHeight);
            Canvas.Style = ERenderStyle.STY_Translucent;
            Canvas.DrawRect( Texture'HudBak001', X2, YL * 1.60 );
       }
       else
	   {
            if (ShadeColor > 95)
	            Canvas.Style = ERenderStyle.STY_Normal;
            Canvas.SetPos(0, ChatBoxHeight);
            Canvas.DrawRect(Texture'HudBak192', X2, YL * 1.60);
       }

       Canvas.Style = ERenderStyle.STY_Normal;
       DrawTypingPrompt(Canvas, Player.Player.Console);
    }

    Canvas.DrawColor = ThisColor;
    Canvas.Style = ERenderStyle.STY_Normal;
}

simulated function DrawChatMessages(Canvas Canvas)
{
   	local float MyOldClipX, OldClipY, OldOrgX, OldOrgY;
    local string sName, sMesg, sTemp;
    local float XL, YH, YM, YL, TX, XL2, F;
    local Color ThisColor;
    local int i, j;

    ThisColor = Canvas.DrawColor;
    Canvas.Style = ERenderStyle.STY_Normal;

	Canvas.StrLen("M", XL, YL);
    TX = ChatBoxHeight + XL * xScale;

	MyOldClipX = Canvas.ClipX;
	OldClipY = Canvas.ClipY;
	OldOrgX = Canvas.OrgX;
	OldOrgY = Canvas.OrgY;

    Smiley = None;
    for (i=0; i<ChatLines; i++)
    {
        if (ChatMessage[i].Mess != "" && ChatMessage[i].PPRI != None)
        {
            sName = ChatMessage[i].PPRI.PlayerName$": ";
            sMesg = ChatMessage[i].Mess;
            YH = ChatFontHeight * i + 4;         // line spacing

            sTemp = Right(sMesg, 2);
            Smiley = CheckForEmoji(sTemp);
            j = Len(sMesg);

            if (Smiley != None)
                sMesg = Mid(sMesg, 0, j-2);
            else
            {
                if (Right(sMesg, 1) == "!")
                {
                    sTemp = Right(sMesg, 3);
                    Smiley = CheckForWords(sTemp);
                    if (Smiley != None)
                    {
                        if (j < 4)
                            sMesg = "";
                        else
                            sMesg = Mid(sMesg, 0, j-4);
                    }
                }
            }
Mesz:
            Canvas.StrLen(sName$"i", XL, YL);
            Canvas.SetPos(TX, YH);
            if ((ChatMessage[i].PPRI.Team > 3) || (!UTGRI.bTeamGame && bStdColor))
                Canvas.DrawColor = SilverColor;
            else
                Canvas.DrawColor = class'ChallengeTeamHUD'.default.TeamColor[ChatMessage[i].PPRI.Team];
            Canvas.DrawText(sName);
            Canvas.SetPos(TX + XL, YH);
            Canvas.DrawColor = ChatColor;

            if (ChatMessage[i].PPRI.bIsSpectator)
                Canvas.DrawColor = GrayColor;

		    Canvas.SetClip( ChatWidth, Canvas.ClipY );
		    Canvas.DrawTextClipped( sMesg, false );

            if (Smiley != None)
            {
                Canvas.StrLen(sMesg$" ", XL2, YL);
                F = GetEmojiSize();
                YM = YH + (ChatFontHeight * 0.5) - ((Smiley.VSize * F) * 0.788);
                if (Canvas.ClipX < 1300)
                    YM += 3;
                Canvas.SetPos(TX + XL + XL2, YM);
                Canvas.DrawColor = WhiteColor;
                Canvas.Style = ERenderStyle.STY_Translucent;
                Canvas.DrawIcon( Smiley, F);
                if (sName ~= "Emojis: ")
                    Smiley = None;
            }
        }
    }

	Canvas.SetOrigin( OldOrgX, OldOrgY );
	Canvas.SetClip( MyOldClipX, OldClipY );
	Canvas.DrawColor = ThisColor;
}

simulated function float GetEmojiSize()
{
    local float F;
    local int xx;

    xx = ThisFont;

    switch xx
    {
        case 24:
             F = 0.900;
             break;
        case 22:
             F = 0.850;
             break;
        case 20:
             F = 0.800;
             break;
        case 18:
             F = 0.725;
             break;
        case 16:
             F = 0.650;
             break;
        case 14:
             F = 0.600;
             break;
        case 12:
             F = 0.550;
             break;
        case 10:
             F = 0.500;
             break;
        default:
             break;
    }

    if (EmojiTrim > 0)
        F += EmojiTrim / 50;
    return F;
}

simulated function DrawOtherMessages(Canvas C)
{
	local int index;
	local float cx;
	local float cy;

	// Other messages.
	cx = 1.0;
	cy = ChatBoxHeight + 6.0;
	if (!bUseUTChat)
	    cy = 1.0;

	if (player.player.console.bTyping)
	{
		cy += msgBoxLineHeight + 3;
	}

	for (index = 0; index < msgCount; index++)
	{
	    DrawMessage(C, cx, cy, OtherMesses[index]);
	    cy += baseFontHeight;
	}
}

// xScale: 1280=1 / 1600=1.25 / 1920=1.50
simulated function DrawTalkFace(Canvas C)
{
    local Color ThisColor;

    ThisColor = C.DrawColor;

    C.DrawColor = WhiteColor;
    C.Style = ERenderStyle.STY_Translucent;
    C.SetPos(0,1);

    if (CheckForMessages())
    {
		C.style = ERenderStyle.STY_Normal;
        if (bSwapFaces && FaceEmoji != None && faceImg != None)
        {
            C.style = ERenderStyle.STY_Translucent;
            faceImg = FaceEmoji;
        }

		C.drawColor = WhiteColor;
		C.setPos(0, 0);
		if (faceImg != None)
		    C.DrawTile(faceImg, ChatBoxHeight - 2.0, ChatBoxHeight - 2.0, 0.0, 0.0, faceImg.uSize, faceImg.vSize);
		else
		    C.DrawTile(Texture'Faceless', ChatBoxHeight - 2.0, ChatBoxHeight - 2.0, 0.0, 0.0, Texture'Faceless'.uSize, Texture'Faceless'.vSize);

		if (bSwapFaces && FaceEmoji != None)
		    return;

     	C.style = ERenderStyle.STY_Translucent;
        C.DrawColor = ChatHudColor * 0.25;
        C.setPos(0, 0);
        C.drawTile(Texture'LadrStatic.Static_a00', ChatBoxHeight - 2.0, ChatBoxHeight - 2.0, 0.0, 0.0,
                   Texture'LadrStatic.Static_a00'.uSize, Texture'LadrStatic.Static_a00'.vSize);
        C.style = ERenderStyle.STY_Normal;
    }
    C.DrawColor = ThisColor;
}

simulated function DrawMessageBox(Canvas C)
{
	Setup(C);

	C.style = ERenderStyle.STY_Translucent;
	if ( (ChallengeHUD(player.myHUD).Opacity == 16) || !Level.bHighDetailMode )
		C.Style = ERenderStyle.STY_Normal;

	CheckChatFonts(C);

    if (bUseUTChat && UTGRI.bShowChatMessages)
    {
        DrawChatArea( C, C.ClipX );
        DrawChatMessages(C);
        DrawTalkFace(C);
    }
    DrawOtherMessages(C);

	C.Style = ERenderStyle.STY_Normal;
}

simulated function GetSvrAddsColor(string sMesg)
{
    local string sTemp, sSym;
    local int j;

    if (Level.TimeSeconds < 15)
        return;

    sSym = UTGRI.ServerAddsSymbol;
    j = Len(sSym);
    sTemp = Left(sMesg, j);
    if (sTemp == sSym)
        SvrAddColr = UTGRI.ServerAddsColor;
}

simulated function Color CheckForBlack(Color Colr, bool bCht)
{
    if (Colr.R < 10 && Colr.G < 10 && Colr.B < 10)
    {
        if (bCht)
            return YellColor;
        else
            return CyanColor;
    }
    else
        return Colr;
}

simulated function DrawMessage(Canvas C, float X, float Y, MessageInfo Msg)
{
    local Color ThisColor;
    local float CX;
    local float mH;
    local float mW;
    local int i;

    ThisColor = C.DrawColor;

    CX = X;
    C.Font = ChatFont;
    C.Style = ERenderStyle.STY_Normal;
    i = 0;

    for (i=0; i<5; i++)
	{
        if ( i < 5 )
        {
            C.SetPos(CX, Y);
            SvrAddColr = Colors[Msg.col[i]];
            if (i == 0)
            {
                GetSvrAddsColor(Msg.Text[i]);
                SvrAddColr = CheckForBlack(SvrAddColr, False);
            }
            C.DrawColor = SvrAddColr;
            C.DrawText(Msg.Text[i],False);
            C.StrLen(Msg.Text[i], mW, mH);
            CX += mW;
        }
    }

    C.DrawColor = ThisColor;
}

defaultproperties
{
    bUseUTChat=True
    bUseEmojis=True
    bSwapFaces=True

    ChatLines=4
    OtherLines=4
    EmojiTrim=0
    MyFontSize=14
    ChatBoxSize=0
    ChatDuration=7
    OtherDuration=10

    GreenColor=(G=192)
    ChatColor=(R=255,G=180,B=10,A=0)
    WhiteColor=(R=255,G=255,B=255)
    SilverColor=(R=192,G=192,B=192)
    CyanColor=(R=50,G=250,B=250,A=0)
    YellColor=(R=250,G=180,B=10,A=0)
    GrayColor=(R=150,G=150,B=150)


    Colors(0)=(R=250,G=64,B=64)
    Colors(1)=(R=60,G=60,B=255)
    Colors(2)=(R=90,G=255,B=90)
    Colors(3)=(R=250,G=250,B=10)
    Colors(4)=(R=255,G=255,B=255)
    Colors(5)=(R=255,G=0,B=0)
    Colors(6)=(R=10,G=190,B=190)
    Colors(7)=(R=10,G=250,B=250)
    Colors(8)=(R=150,G=150,B=250)
    Colors(9)=(R=255,G=192,B=50)
    Colors(10)=(R=165,G=10,B=250)

    bAlwaysRelevant=True
    RemoteRole=ROLE_SimulatedProxy
    NetPriority=2.000000
}


