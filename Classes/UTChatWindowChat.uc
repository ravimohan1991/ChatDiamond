//================================================================================
// UTChatWindowChat
//================================================================================
//
class UTChatWindowChat extends UWindowPageWindow config (UTChatLog);

var UTChatGRI UTGRI;

var UMenuLabelControl  lblHeading;
var UTChatTextArea     TheTextArea;
var UTChatWinControl   EditMesg;

var UWindowSmallButton ButSend;
var UWindowSmallButton ButSave;
var UWindowSmallButton ButClose;

var config string Chat[200];

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

    if ( UTGRI == none )
    {
       foreach Root.GetPlayerOwner().AllActors(class'UTChatGRI', UTGRI)
       break;
    }

	lblHeading=UMenuLabelControl(CreateControl(Class'UMenuLabelControl', 0, 0, 200, 16));
	lblHeading.Font = F_Bold;
	lblHeading.SetText(" Date    Time   Nickname / Message ");
	lblHeading.Align=TA_Left;
	lblHeading.SetTextColor(GrnColor);

	TheTextArea = UTChatTextArea(CreateControl(Class'UTChatTextArea',1, 16, 385, 212));
	TheTextArea.AbsoluteFont = Font(DynamicLoadObject("UWindowFonts.TahomaB12", class'Font'));
	TheTextArea.bAutoScrollbar = False;
	TheTextArea.SetTextColor(SilColor);
	TheTextArea.Clear();
	TheTextArea.bChat = True;

    ButSave = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 3, 230, 50, 25));
    ButSave.SetText("Save");
    ButSave.DownSound = sound'UnrealShare.FSHLITE2';

    ButSend = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 278, 230, 50, 25));
    ButSend.SetText("Send");
    ButSend.DownSound = sound'UnrealShare.FSHLITE2';

    ButClose = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 333, 230, 50, 25));
    ButClose.SetText("Close");
    ButClose.DownSound = sound'UnrealShare.FSHLITE2';

    // must go here to get 1st focus
  	EditMesg=UTChatWinControl(CreateControl(Class'UTChatWinControl', 56, 230, 217, 16));      //188
	EditMesg.EditBoxWidth = 217;
	EditMesg.SetNumericOnly(False);
	EditMesg.SetFont(0);
	EditMesg.SetHistory(True);
	EditMesg.SetValue("");
	EditMesg.Align=TA_Left;
	EditMesg.UTWC = self;

    SetAcceptsFocus();
    iTick = 50;               // LoadMessages();
	PrevWinWidth  = WinWidth;
	PrevWinHeight = WinHeight;
}

function LoadMessages(optional string sMesg)
{
    local string sTemp;
    local int i;

    if (sMesg != "")
    {
        TheTextArea.AddText(sMesg);
    }
    else
    {
        TheTextArea.Clear();
        for (i=0; i<200; i++)
        {
             sTemp = UTGRI.ChatLog[i];
             if (i > 0 && sTemp == "")
                 break;
             TheTextArea.AddText(sTemp);
             sTemp = Left(sTemp, 6)$"-"$Mid(sTemp, 7);
             Chat[i] = sTemp;              // for saving
        }
    }
}

function Notify (UWindowDialogControl C, byte E)
{
    Super.Notify(C,E);

    Switch(E)
    {
      case DE_Change:
      switch(C)
      {
	  }
	  break;
	  case DE_Click:
	  switch(C)
      {
        case ButSave:
             SaveConfig();
             ButSave.bDisabled = True;
             GetPlayerOwner().ClientMessage("All Messages have been saved to UTChatlog.ini");
             break;
        case ButSend:
             SendMessage();
             break;
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

function Tick( float delta )
{

    if (iTick > 0)
    {
        iTick--;
        if (iTick == 0)
            LoadMessages();
    }

    Super.Tick(delta);
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
		TheTextArea.SetSize(TheTextArea.WinWidth + DiffX, TheTextArea.WinHeight + DiffY);
        TheTextArea.WrapWidth = WinWidth - 80;;

		ButSave.WinTop += DiffY;

		ButSend.WinLeft += DiffX;
		ButSend.WinTop += DiffY;

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

function Paint(Canvas C, float MouseX, float MouseY)
{
	Super.Paint(C,MouseX,MouseY);

    DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BlackTexture');
    C.Style = GetPlayerOwner().ERenderStyle.STY_Normal;
}

function Close(optional bool bByParent)
{
	Super.Close(bByParent);
}

defaultproperties
{
    SilColor=(R=180,G=180,B=180)
    GrnColor=(R=0,G=255,B=32)
    TxtColor=(R=255,G=255,B=255,A=0)
    YelColor=(R=192,G=192,B=1)
}
