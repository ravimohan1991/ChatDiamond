//================================================================================
// UTChatWindowEmojis
//================================================================================

class UTChatWindowEmojis extends UWindowPageWindow;

var UTChatWRI UTWRI;

var UWindowSmallButton ButClose;
var UTChatWinControl   EditMesg;

var color WhiteColor, GrayColor;

var float  PrevWinWidth, PrevWinHeight;
var string DetailMode;

function Created ()
{
	Super.Created();

    if ( UTWRI == none )
    {
       foreach GetPlayerOwner().AllActors(class'UTChatWRI', UTWRI)
       break;
    }

    DetailMode = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager TextureDetail");

    ButClose=UWindowSmallButton(CreateControl(Class'UWindowSmallButton', 320, 229, 60, 25));
	ButClose.Text="Close";

  	EditMesg=UTChatWinControl(CreateControl(Class'UTChatWinControl', 10, 228, 300, 16));
	EditMesg.EditBoxWidth = 300;
	EditMesg.SetNumericOnly(False);
	EditMesg.SetFont(0);
	EditMesg.SetHistory(True);
	EditMesg.SetValue("");
	EditMesg.Align=TA_Left;

    SetAcceptsFocus();

	PrevWinWidth  = WinWidth;
	PrevWinHeight = WinHeight;
}

function Notify (UWindowDialogControl C, byte E)
{
    Super.Notify(C,E);

    Switch(E)
    {
	  case DE_Click:
	  switch(C)
      {
	  case ButClose:
	       ParentWindow.ParentWindow.Close();
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
 	if ( EditMesg.GetValue() != "" )
	{
	    GetPlayerOwner().ConsoleCommand("SAY " $ EditMesg.GetValue());
	    EditMesg.SetValue("");
	}
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
		ButClose.WinLeft += DiffX;
		ButClose.WinTop += DiffY;

		EditMesg.WinTop += DiffY;
		EditMesg.SetSize(EditMesg.WinWidth + DiffX, EditMesg.WinHeight);
		EditMesg.EditBoxWidth = EditMesg.WinWidth;
	}
	PrevWinWidth = WinWidth;
	PrevWinHeight = WinHeight;
}

function BeforePaint( Canvas C, float X, float Y )
{
	Super.BeforePaint(C, X, Y);
   	Resize();
}

function Paint (Canvas C, float MouseX, float MouseY)
{
	Super.Paint(C,MouseX,MouseY);

    C.DrawColor  = WhiteColor;

    if (DetailMode ~= "High")
        DrawStretchedTexture(C,0.00,0.00,WinWidth,WinHeight,Texture'Emojis1');
    else
        DrawStretchedTexture(C,0.00,0.00,WinWidth,WinHeight,Texture'Emojis2');

    C.Style = GetPlayerOwner().ERenderStyle.STY_Normal;
}

function Close (optional bool bByParent)
{
	Super.Close(bByParent);
}

defaultproperties
{
    WhiteColor=(R=255,G=255,B=255)
}
