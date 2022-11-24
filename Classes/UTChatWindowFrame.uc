//================================================================================
// UTChatWindowFrame - Client
//================================================================================

class UTChatWindowFrame extends UMenuFramedWindow Config(UTChat);

var UTChatGRI UTGRI;
var UTChatWRI UTWRI;

var() config int Xpos;
var() config int Ypos;
var() config int Wpos;
var() config int Hpos;

function created()
{
	super.created();

    if ( UTGRI == none )
    {
       foreach Root.GetPlayerOwner().AllActors(class'UTChatGRI', UTGRI)
       break;
    }

    if ( UTWRI == none )
    {
       foreach Root.GetPlayerOwner().AllActors(class'UTChatWRI', UTWRI)
       break;
    }

	bLeaveOnScreen = true;
	bStatusBar = true;
	//if (UTWRI.bEmojis)
	//{
	//    bSizable = False;
	//    bMoving = False;
	//}
	//else
	//{
	    bSizable = True;
	    bMoving = true;
        MinWinWidth  = 395;
        MinWinHeight = 322;
	//}

	SetSizePos();

    WindowTitle = "UTChat - "$UTGRI.Version;
}

function ResolutionChanged(float W, float H)
{
	SetSizePos();
	Super.ResolutionChanged(W, H);
}

function SetSizePos()
{
    CheckXY();

    if (WPos > 0 && HPos > 0)
        SetSize(WPos, HPos);
    else
        SetSize(WinWidth, WinHeight);
    WinLeft = ((Root.WinWidth  - WinWidth)  / 100) * (Xpos);
    WinTop  = ((Root.WinHeight - WinHeight) / 100) * (Ypos);
}

function Resized()
{
	if (ClientArea == None)
	    return;

	if (!bLeaveOnscreen) // hackish way for detect first resize
		SetSizePos();

	Super.Resized();
}

function CheckXY()
{
    if (Xpos < 0 || Xpos > 99)
        Xpos = 50;
    if (Ypos < 0 || Ypos > 99)
        Ypos = 60;
}

function Tick(float DeltaTime)
{
    local int x, y;

    WPos = WinWidth;
    HPos = WinHeight;

    x = self.WinLeft / ((Root.WinWidth - WinWidth) / 100);
    y = self.WinTop / ((Root.WinHeight - WinHeight) / 100);

    if (Xpos != x || Ypos != y)
    {
        Xpos = x;
        Ypos = y;
    }

    Super.Tick(DeltaTime);
}


function Close(optional bool bByParent)
{
    CheckXY();
    SaveConfig();
    Root.Console.CloseUWindow();
	Super.Close(bByParent);
}

defaultproperties
{
      XPos=50
      YPos=40
      ClientClass=Class'UTChatTabWindow'

