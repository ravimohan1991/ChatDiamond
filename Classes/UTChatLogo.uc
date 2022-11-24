//================================================================================
// UTChatLogo - spawned from UTChatHudDM/TM
//================================================================================

class UTChatLogo extends Info;

#exec TEXTURE IMPORT File=Textures\utclogo.pcx   NAME=UTCLogo Mips=off

var UTChatGRI  UTGRI;

var int   DrawLogo;
var int   LogoCounter;
var bool  bInitialized;
var float FF;

var PlayerPawn PlayerOwner;
var Color      WhiteColor;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    if ( !bInitialized )
    {
       bInitialized = true;
       DrawLogo = 1;
       SetTimer(0.10 , True);
    }
}

simulated function CheckGRI()
{
    if ( UTGRI == None )
    {
        foreach AllActors( class'UTChatGRI', UTGRI )
        break;
    }
}

simulated function Timer()
{
    Super.Timer();

    if ( Level.NetMode != NM_DedicatedServer )
    {
        if (DrawLogo > 0)
        {
            LogoCounter++;
            if ( DrawLogo == 510 )
            {
                DrawLogo = 0;
                SetTimer( 0.0, False );
                Disable('Tick');          // to allow click fire in tick
            }
            else
            if ( LogoCounter > 20 )
            {
                DrawLogo += 8;
                if ( DrawLogo > 510 )
                   DrawLogo = 510;
            }
            else
            if ( LogoCounter == 20 )
            {
                DrawLogo = 5;
            }
        }

        if (UTGRI == None)
            CheckGRI();

        if (UTGRI != None && UTGRI.bGameStarted)
        {
            SetTimer(0.0, False);
            Destroy();
        }
    }
}

simulated event PostRender(Canvas C)
{
    local float F, XL, YL, ScaleX;

    CheckGRI();

    if (UTGRI == None)
        return;

    if (UTGRI.bGameStarted)
        return;

    C.Style = ERenderStyle.STY_Translucent;

    if (PlayerOwner == None)
        PlayerOwner = C.Viewport.Actor;

    if (PlayerOwner == none)
        return;

    ScaleX = (1 * C.Clipx) / 1280.0;

    YL = 10  * ScaleX;
    XL = 150 * ScaleX;
    F  = 1.0 * ScaleX;

    if ( DrawLogo > 1 )
    {
       C.DrawColor.R = 255 - DrawLogo/2;
       C.DrawColor.G = 255 - DrawLogo/2;
       C.DrawColor.B = 255 - DrawLogo/2;
    }
    else
    {
       C.Style = ERenderStyle.STY_Translucent;
       C.DrawColor = WhiteColor;
    }

    if (DrawLogo != 0)
    {
        if (!UTGRI.bGameStarted)
        {
            if (DrawLogo < 350)
                FF += 0.008;
            else
                FF -= 0.008;
            if (FF > 1.100)
                FF = 1.100;

            C.SetPos( C.ClipX - Texture'UTCLogo'.Usize*F - XL, YL );
            C.DrawIcon( Texture'UTCLogo', FF );
        }
    }

    C.Style = ERenderStyle.STY_Normal;
}

defaultproperties
{
    WhiteColor=(R=255,G=255,B=255)
    RemoteRole=ROLE_None
}
