//================================================================================
// UTChatWRI
//================================================================================

class UTChatWRI expands ReplicationInfo;

var UTChatTabWindow TabWindow, WTab;
var UWindowWindow   TheWindow;

var() Class<UWindowWindow> WindowClass;

var() int  WinLeft;
var() int  WinTop;
var() int  WinWidth;
var() int  WinHeight;
var() bool DestroyOnClose;

var bool   bOpenWindowDispatched;
var bool   bSetupWindowDelayDone;
var bool   bDestroyRequested;
var bool   bNoChatLog;
var bool   bEmojis;

var string PrevChatMesg, NewChatMesg, MyName;

var bool   bInitialized;
var int    TicksPassed;

replication
{
    reliable if ( Role == ROLE_Authority )
        OpenWindow, CloseWindow, PrevChatMesg, NewChatMesg, bEmojis;

    reliable if ( Role < ROLE_Authority )
        DestroyWRI;
}

event PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( !bInitialized )
	{
	    OpenIfNecessary();
	    bInitialized = true;
	}
}

simulated event PostNetBeginPlay()
{
	PostBeginPlay();
	OpenIfNecessary();
}

simulated function OpenIfNecessary()
{
	local PlayerPawn P;

	if ( Owner != None )
	{
		P = PlayerPawn(Owner);
		if ( (P != None) && (P.Player != None) && (P.Player.Console != None) )
		{
			OpenWindow();
		}
	}
}

simulated function bool OpenWindow()
{
	local PlayerPawn P;
	local WindowConsole C;

	P = PlayerPawn(Owner);
	if ( P == None )
	{
		DestroyWRI();
		return False;
	}

	if ( P.Player.Console.bTyping )
	{
		SetTimer(0.50,False);
		return False;
	}

	bOpenWindowDispatched = True;

	C = WindowConsole(P.Player.Console);

	if ( C == None )
	{
		DestroyWRI();
		return False;
	}

	if ( !C.bCreatedRoot || (C.Root == None) )
	{
		C.CreateRootWindow(None);
	}

	C.bQuickKeyEnable = True;
	C.LaunchUWindow();
	TicksPassed = 1;
	return True;
}

simulated function Tick (float DeltaTime)
{
	if ( TicksPassed != 0 )
	{
		if ( TicksPassed++  == 5 )
		{
			SetupWindow();
			TicksPassed=0;
		}
	}

	// 1st port of call
	if ( DestroyOnClose && (TheWindow != None) &&  !TheWindow.bWindowVisible &&  !bDestroyRequested )
	{
		bDestroyRequested=True;
		DestroyWRI();
	}

	if (!bNoChatLog && NewChatMesg != PrevChatMesg)
	{
	    if (WTab != None)
	    {
	        WTab.AddChatMessage(NewChatMesg);
	        PrevChatMesg = NewChatMesg;
	    }
	}
}

simulated function bool SetupWindow()
{
	if ( !bSetupWindowDelayDone )
	{
		SetTimer(1.00,False);
		return False;
	}

	if ( SetWindow() )
	{
		TabWindow = UTChatTabWindow(UTChatWindowFrame(TheWindow).ClientArea);
		WTab = TabWindow;
		SetTimer(1.00,False);
	}
}

simulated function bool SetWindow()
{
	local WindowConsole C;

	C = WindowConsole(PlayerPawn(Owner).Player.Console);
	TheWindow = C.Root.CreateWindow(WindowClass,WinLeft,WinTop,WinWidth,WinHeight);

	if ( TheWindow == None )
	{
		DestroyWRI();
		return False;
	}

	if ( C.bShowConsole )
	{
		C.HideConsole();
	}

    TheWindow.bLeaveOnscreen=false;
    TheWindow.SetSize(Max(550, TheWindow.WinWidth), Max(400, TheWindow.WinHeight));

	TheWindow.bLeaveOnscreen=True;
	TheWindow.ShowWindow();
	return True;
}

simulated function Timer ()
{
	if ( !bOpenWindowDispatched )
	{
		OpenWindow();
		return;
	}

	if ( !bSetupWindowDelayDone )
	{
		bSetupWindowDelayDone=True;
		SetupWindow();
	}
}

simulated function CloseWindow ()
{
	local WindowConsole C;

    if (PlayerPawn(Owner) != None)     // solves access none's if player leaves
    {
	   C = WindowConsole(PlayerPawn(Owner).Player.Console);
	   C.bQuickKeyEnable = False;
    }

	if ( TheWindow != None )
	{
		TheWindow.Close();
		TabWindow.Close();
	}
}

function DestroyWRI()
{
	Destroy();
}

defaultproperties
{
      WindowClass=Class'UTChatWindowFrame'
      WinWidth=395
      WinHeight=283
      DestroyOnClose=True
      RemoteRole=ROLE_SimulatedProxy
      NetPriority=2.000000
      NetUpdateFrequency=2.000000
}

