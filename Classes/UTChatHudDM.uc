//===============================================================================
//             UTChatHudDM - by ProAsm and No0ne - 2021/22
//              Thanks to ZeroPoint (Defrost) of Nexgen
//===============================================================================
//

class UTChatHudDM expands ChallengeHUD;

var ChallengeHUD OriginalHUD;

var UTChatGRI  UTGRI;
var UTChatHud  UTHUD;
var ServerInfo UTSI;
var UTChatLogo UTCL;

var float iTick;

exec function ShowServerInfo()
{
	if (bShowInfo)
	    bShowInfo = False;
    else
    {
		bShowInfo = True;
		PlayerPawn(Owner).bShowScores = False;
	}
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    SetTimer(0.0, false);
}

simulated function CheckGRI()
{
    if ( UTGRI == None )
    {
        foreach AllActors( class'UTChatGRI', UTGRI )
        break;
    }

    if (UTHUD == None)
    {
        UTHUD = Spawn(class'UTChatHud');
    }

    if (UTGRI != None && UTGRI.bDrawChatLogo && UTCL == None)
    {
        UTCL = Spawn(class'UTChatLogo');
    }
}

simulated event PreRender(Canvas c)
{
    if (OriginalHUD != None)
	    OriginalHUD.PreRender(c);
}

simulated event PostRender( Canvas C )
{
    local Color MyColor;

    CheckGRI();

    if (UTHUD == None)
        return;

    if (UTGRI != None && OriginalHUD == None)
    {
        OriginalHUD = ChallengeHUD(spawn(UTGRI.OriginalHUDClass, self.Owner));
    }

    if (!UTHUD.bUseUTChat)                       // new
    {
        Super.PostRender(c);
    }

    if (PlayerOwner == None)
        PlayerOwner = C.Viewport.Actor;

    if (PlayerOwner == None)
        return;

    if (UTGRI != None && UTGRI.bDrawChatLogo && UTCL != None)
    {
        UTCL.PlayerOwner = PlayerOwner;
        UTCL.PostRender(C);
    }

	if (UTHUD != None && UTHUD.bUseUTChat)
	{
        UTHUD.PlayerOwner = PlayerOwner;
        UTHUD.PreRenderHUD(C);

	    // Display Frag count
	    if (!bAlwaysHideFrags && !bHideFrags && PlayerOwner.PlayerReplicationInfo != None && !PlayerOwner.PlayerReplicationInfo.bWaitingPlayer && PawnOwner != None && !PlayerOwner.bShowScores && !PlayerOwner.IsA('Spectator'))
	    {
	        if (PlayerOwner != None)
	        {
		        HudColor = HudColor * 0.1;
		        MyColor = WhiteColor;
		        WhiteColor = WhiteColor * 0.7;
		        DrawFragCount(C);
		        WhiteColor = MyColor;
		        HUDSetup(C);
		    }
		}
    }

	if (OriginalHUD == None)
	{
		Super.PostRender(C);
	}
	else
	{
        OriginalPostRender(C);
	}

	if (UTHUD != None)
	{
	    HUDSetup(C);
		UTHUD.PostRenderHUD(C);
	}

	if ( bShowInfo )
	{
	    if (UTSI == None)
	        UTSI = Spawn(ServerInfoClass, Owner);
	    UTSI.RenderInfo(c);
	}

    PlayerOwner.Player.Console.ClearMessages();
}

simulated function OriginalPostRender( Canvas C )
{
	local Console Cons;
	local bool bWasTyping;

	copyVarsToOriginalHUD();                     // Copy HUD settings to original HUD.

	if (UTHUD != None && PlayerOwner != None && UTHUD.bUseUTChat) // Save data & fool the original HUD.
	{
		Cons = PlayerOwner.Player.Console;
		bWasTyping = Cons.bTyping;
		Cons.bTyping = false;
	}

	if (InStr(OriginalHUD, ".UTChatHudDM") == -1)
	    OriginalHUD.postRender(C);               // Let the original HUD render it's stuff.

	if (PlayerOwner != None && UTHUD.bUseUTChat) // Restore data.
	{
		Cons.bTyping = bWasTyping;
	}

	copyVarsFromOriginalHUD();                   // Copy HUD settings from original HUD.
}

simulated function copyVarsToOriginalHUD()
{
	// Copy variables.
	OriginalHUD.bHideHUD         = bHideHUD;
	OriginalHUD.bHideAllWeapons  = bHideAllWeapons;
	OriginalHUD.bHideStatus      = bHideStatus;
	OriginalHUD.bHideAmmo        = bHideAmmo;
	OriginalHUD.bHideTeamInfo    = bHideTeamInfo;
	OriginalHUD.bHideFrags       = bHideFrags;
	OriginalHUD.bHideFaces       = bHideFaces;
	OriginalHUD.bUseTeamColor    = bUseTeamColor;
	OriginalHUD.opacity          = opacity;
	OriginalHUD.hudScale         = hudScale;
	OriginalHUD.weaponScale      = weaponScale;
	OriginalHUD.statusScale      = statusScale;
	OriginalHUD.favoriteHUDColor = favoriteHUDColor;
	OriginalHUD.crosshairColor   = CrosshairColor;
	OriginalHUD.hudMutator       = hudMutator;
	OriginalHUD.bForceScores     = bForceScores;
	OriginalHUD.HUDColor         = HUDColor;
	OriginalHUD.Scale            = scale;
}

simulated function copyVarsFromOriginalHUD()
{
	PlayerOwner         = OriginalHUD.PlayerOwner;
	MOTDFadeOutTime     = OriginalHUD.MOTDFadeOutTime;
	identifyFadeTime    = OriginalHUD.identifyFadeTime;
	identifyTarget      = OriginalHUD.identifyTarget;
	pawnOwner           = OriginalHUD.pawnOwner;
	myFonts             = OriginalHUD.myFonts;
	faceTexture         = OriginalHUD.faceTexture;
	faceTime            = OriginalHUD.faceTime;
	faceTeam            = OriginalHUD.faceTeam;
	playerCount         = OriginalHUD.playerCount;
	bTiedScore          = OriginalHUD.bTiedScore;
	lastReportedTime    = OriginalHUD.lastReportedTime;
	bStartUpMessage     = OriginalHUD.bStartUpMessage;
	bTimeValid          = OriginalHUD.bTimeValid;
	bLowRes             = OriginalHUD.bLowRes;
	bResChanged         = OriginalHUD.bResChanged;
	bAlwaysHideFrags    = OriginalHUD.bAlwaysHideFrags;
	bHideCenterMessages = OriginalHUD.bHideCenterMessages;
	scale               = OriginalHUD.scale;
	style               = OriginalHUD.style;
	baseColor           = OriginalHUD.baseColor;
	HUDColor            = OriginalHUD.HUDColor;
	solidHUDColor       = OriginalHUD.solidHUDColor;
	rank                = OriginalHUD.rank;
	lead                = OriginalHUD.lead;
	pickupTime          = OriginalHUD.pickupTime;
	weaponNameFade      = OriginalHUD.weaponNameFade;
	messageFadeTime     = OriginalHUD.messageFadeTime;
	messageFadeCount    = OriginalHUD.messageFadeCount;
	bDrawMessageArea    = OriginalHUD.bDrawMessageArea;
	bDrawFaceArea       = OriginalHUD.bDrawFaceArea;
	faceAreaOffset      = OriginalHUD.faceAreaOffset;
	minFaceAreaOffset   = OriginalHUD.minFaceAreaOffset;
	serverInfoClass     = OriginalHUD.serverInfoClass;
}

simulated function inputNumber(byte f)
{
	if (originalHUD != none)
	   originalHUD.inputNumber(f);
}

simulated function changeHud(int d)
{
	if (originalHUD != none)
	    originalHUD.changeHud(d);
}

simulated function changeCrosshair(int d)
{
	if (originalHUD != none)
	    originalHUD.changeCrosshair(d);
}

simulated function drawCrossHair(Canvas c, int startX, int startY)
{
	if (originalHUD != none)
	    originalHUD.drawCrossHair(c, startX, startY);
}

simulated function Message(PlayerReplicationInfo Pri, coerce string Msg, name msgType)
{
	local bool bHandleByOriginalHUD;

    if (UTHUD == None)
        CheckGRI();

	// Check for spamming and class responsible for this message.
    if (UTHUD != None)
    {
    	bHandleByOriginalHUD = msgType == 'CriticalEvent' || msgType == 'MonsterCriticalEvent' || !UTHUD.bUseUTChat;
    }

	// Handle message.
	if (bHandleByOriginalHUD)
	{
		if (OriginalHUD != None)
		    OriginalHUD.Message(Pri, Msg, msgType);
	}
	else
	{
		AddMessage(Msg, msgType, Pri, None);
	}
}

simulated function LocalizedMessage(class<LocalMessage> message, optional int switch, optional PlayerReplicationInfo relatedPRI_1,
                                    optional PlayerReplicationInfo relatedPRI_2, optional Object optionalObject, optional string criticalString)
{
	local bool bHandleByOriginalHUD;
	local string msgStr;

	bHandleByOriginalHUD = Message.default.bIsSpecial || !UTHUD.bUseUTChat;

	// Handle message.
	if (bHandleByOriginalHUD)
	{
		if (OriginalHUD != None)
		    OriginalHUD.localizedMessage(message, switch, relatedPRI_1, relatedPRI_2, optionalObject, criticalString);
	}
	else
	{
		// Get message string.
        if (message.default.bComplexString)
        {
            msgStr = criticalString;
        }
        else
        {
            msgStr = message.static.getString(switch, relatedPRI_1, relatedPRI_2, optionalObject);
        }

		// Add the message.
		AddMessage(msgStr, '', relatedPRI_1, relatedPRI_2);
	}
}

simulated function playReceivedMessage(string s, string pName, ZoneInfo pZone)
{
	if (OriginalHUD != None)
	    OriginalHUD.playReceivedMessage(s, pName, pZone);
}

simulated function bool displayMessages(Canvas c)
{
    return true;
}

function bool processKeyEvent(int key, int action, float delta)
{
	if (OriginalHUD != None)
	    return OriginalHUD.processKeyEvent(key, action, delta);
    return false;
}

function setDamage(vector hitLoc, float damage)
{
	if (OriginalHUD != None)
	    OriginalHUD.setDamage(hitLoc, damage);
}

simulated function AddMessage(string Msg, name msgType, PlayerReplicationInfo Pri1, PlayerReplicationInfo Pri2)
{
	if (UTHUD != None)
	    UTHUD.Message(Msg, msgType, Pri1, Pri2);
}

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

    CheckGRI();

    if (UTGRI == None)
        return;

    if (!UTGRI.bGameStarted && UTGRI.bStartControl)
    {
        if ((Level.TimeSeconds > iTick) && (PlayerOwner.bFire != 0 || PlayerPawn(Owner).bFire != 0))
        {
            iTick = Level.TimeSeconds + 0.2;
            PlayerOwner.ConsoleCommand("Mutate "$UTGRI.sCode$" UTChatFired");
        }
    }
    else
    if (UTGRI.bGameStarted)
        Disable('Tick');
}

defaultproperties
{
    bAlwaysRelevant=True
    RemoteRole=ROLE_SimulatedProxy
}
