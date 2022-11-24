class UTChatGRI expands ReplicationInfo;

var class<HUD> OriginalHUDClass;
var bool bShowChatMessages, bNoEmoticons, bNoEmojiFace, bNoBotsInChat, bTeamGame, bGameStarted;
var bool bLocal, bGameEnded, bStdDMPlayerColor, bStartControl, bDrawChatLogo, bReady, bStart;
var bool bNoAntiSpam, bFontOverRide, bPlayerJoinLeave, bNoChatBorders, bNoChatLog, bNoChatShading;
var bool bAdminDuration, bDisBotInfo, bNexgen;
var int  RepeatDelay, ChatDelayTime, ChatFontSize;

var Color ChatsTextColor, OtherTextColor;
var string ChatLog[201];
var PlayerReplicationInfo BotPRI[32];
var string BotNames[32];
var string Players[32];

var string ServerAddsSymbol;
var Color  ServerAddsColor;

var string Word1[25];
var string Word2[25];
var int WordsPerMesg;

var string Version, sCode;

replication
{
    reliable if ( Role == ROLE_Authority )
                 OriginalHUDClass, ChatLog, bShowChatMessages, ChatsTextColor, OtherTextColor, bTeamGame,
                 Players, BotNames, BotPRI, bLocal, bNoEmoticons, Version, ChatDelayTime, bGameStarted,
                 ServerAddsSymbol, ServerAddsColor, bGameEnded, bNoEmojiFace, bNoBotsInChat, bStdDMPlayerColor,
                 Word1, Word2, WordsPerMesg, RepeatDelay, bStartControl, bDrawChatLogo, bReady, bStart,
                 bNoAntiSpam, bFontOverRide, ChatFontSize, bPlayerJoinLeave, bNoChatBorders, bNoChatLog,
                 bNoChatShading, bAdminDuration, bDisBotInfo, bNexgen, sCode;
}

defaultproperties
{
      RemoteRole=ROLE_SimulatedProxy
      NetPriority=2.000000
      NetUpdateFrequency=2.000000
}
