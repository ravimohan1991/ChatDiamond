class UTChatStartUp extends Mutator;

var UTChatGRI  UTGRI;

var PlayerPawn PlayerOwner;

var string PlayerDone[64];

var int StartUp, ReadyTime, StartTime;

const UT_Waiting = 0;                            // Waiting for players.
const UT_Ready = 1;                              // Waiting to press fire.
const UT_Starting = 2;                           // Ready to start Game.
const UT_Playing = 3;                            // Game has started.

var bool bGameRunning;

function PreBeginPlay()
{
	if (!DeathMatchPlus(Level.Game).bTournament && Level.Netmode != NM_StandAlone)
	{
		DeathMatchPlus(Level.Game).bNetReady = False;
		StartUp = UT_Waiting;
		CheckGRI();
		ReadyTime = -1;
		StartTime = -1;
		SetTimer(1.0, True);
    }
}

function CheckGRI()
{
    if ( UTGRI == None )
    {
        foreach AllActors( class'UTChatGRI', UTGRI )
        break;
    }
}

function ClientLogin(PlayerPawn Sender)
{
    CheckGRI();

    if (DeathMatchPlus(level.game).bTournament)
        return;

    if (StartUp == UT_Waiting || StartUp == UT_Ready)
        ReadyTime = 5;                           // set or reset timer

    if (StartUp != UT_Playing)
        SetTimer(1.0, True);
}

function Timer()
{
	local Pawn Pn;

    CheckGRI();

	if (ReadyTime > 0)
	{
		ReadyTime--;
    }

	if (StartTime > 0)
	{
		StartTime--;
 	    if (StartTime == 0)
		    StartGame(False);
	}

	// Check if the game is ready to start
	if ((ReadyTime == 0) && (StartUp == UT_Waiting || StartUp == UT_Ready))
	{
	    for (Pn = Level.PawnList; Pn != None; Pn = Pn.NextPawn)
	    {
	        if (Pn.IsA('PlayerPawn') && Pn.bIsPlayer && !Pn.IsA('Bot'))
	        {
                if (!SavePlayer(PlayerPawn(Pn)))
	                Pn.ClientMessage("<<< Press [Fire] to start the Game >>>", 'Event', True);
	        }
	    }
        ReadyTime = 7;
        StartUp = UT_Ready;
        UTGRI.bReady = True;
	}

	if (UTGRI.bGameStarted && !bGameRunning)
	    StartGame(True);
}

function bool SavePlayer(PlayerPawn PP)
{
    local string sNick;
    local int i;

    sNick = PP.PlayerReplicationInfo.PlayerName;

    for (i=0; i<64; i++)
    {
        if (PlayerDone[i] == sNick)
            return True;
    }

    for (i=0; i<64; i++)
    {
        if (PlayerDone[i] == "")
        {
            PlayerDone[i] = sNick;
            break;
        }
    }
    return False;
}

function StartGame(bool bForce)
{
	if ((StartTime == 0 && StartUp == UT_Starting) || (bForce))
	{
		StartUp = UT_Playing;
		DeathMatchPlus(level.game).bRequireReady = False;
		DeathMatchPlus(level.game).startMatch();
		SetTimer(1.0, False);
		UTGRI.bStart = False;
		bGameRunning = True;
	}
	else
	if (ReadyTime == 0 && StartUp == UT_Ready)
	{
		StartUp = UT_Starting;
		StartTime = 7;
		UTGRI.bStart = True;
    }
    UTGRI.bReady = False;
}

function PlayerPressedFire(PlayerPawn Sender)
{
    local string sTemp;

    CheckGRI();

    if (StartUp == UT_Ready)
    {
        if (!DeathMatchPlus(level.game).bTournament)
        {
            sTemp = Sender.PlayerReplicationInfo.PlayerName$" has started the game!";
            BroadcastMessage(sTemp, False, 'Event');
            ReadyTime = 0;
            StartGame(False);
        }
    }
}

defaultproperties
{
}

