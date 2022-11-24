//================================================================================
// UTChatWindowAdmin
//================================================================================
//
class UTChatWindowAdmin extends UWindowPageWindow;

var UTChatGRI UTGRI;

var UWindowSmallButton ButClose;

var UMenuLabelControl lblRepTime;
var UWindowHSliderControl RepeatSlider;

var UMenuLabelControl  lblChatTime;
var UWindowHSliderControl DelaySlider;

var UMenuLabelControl lblFontSize;
var UWindowHSliderControl FontSlider;
var UTChatWinCheck    EnableFont;

var UTChatWinCheck    EnableChat;
var UTChatWinCheck    ClearChats;
var UTChatWinCheck    ClearBots;
var UTChatWinCheck    NoChatLog;
var UTChatWinCheck    NoBorders;
var UTChatWinCheck    NoShading;
var UTChatWinCheck    DisEmojis;
var UTChatWinCheck    DisEmoFac;
var UTChatWinCheck    AntiSpam;
var UTChatWinCheck    DMStdPlay;
var UTChatWinCheck    StartCont;
var UTChatWinCheck    Duration;

var UWindowSmallButton ButSubmit;

var UTChatWinControl   AdminMesg;
var UMenuLabelControl  LabelMesg;
var UWindowSmallButton ButSend;

var color TxtColor, DarkColor;

var UWindowFramedWindow FW;

var float PrevWinWidth, PrevWinHeight;

function Created ()
{
	Super.Created();

    FW = UWindowFramedWindow(GetParent(class'UWindowFramedWindow'));

    if ( UTGRI == none )
    {
       foreach GetPlayerOwner().AllActors(class'UTChatGRI', UTGRI)
       break;
    }

    lblRepTime = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 15, 15, 120, 16));
    lblRepTime.TextColor = TxtColor;
    lblRepTime.Align = TA_Center;
    lblRepTime.SetText("");

    RepeatSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl',15, 30, 110, 30));
    RepeatSlider.SliderWidth = 110;
    RepeatSlider.bAcceptsFocus = False;
    RepeatSlider.MinValue = 0;
    RepeatSlider.MaxValue = 10;
    RepeatSlider.Step = 1;
    RepeatSlider.SetText("  ");
    RepeatSlider.SetValue(UTGRI.RepeatDelay);
    RepeatSlider.TextColor = TxtColor;
    if (int(RepeatSlider.GetValue()) == 0)
        lblRepTime.SetText("Repeat Delay: 0.1 secs");
    else
        lblRepTime.SetText("Repeat Delay: "$int(RepeatSlider.GetValue())$" secs");

    lblChatTime = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 15, 53, 120, 16));
    lblChatTime.TextColor = TxtColor;
    lblChatTime.Align = TA_Center;
    lblChatTime.SetText("");

    DelaySlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl',15, 68, 110, 30));
    DelaySlider.SliderWidth = 110;
    DelaySlider.bAcceptsFocus = False;
    DelaySlider.MinValue = 2;
    DelaySlider.MaxValue = 20;
    DelaySlider.Step = 2;
    DelaySlider.SetText("  ");
    DelaySlider.TextColor = TxtColor;
    DelaySlider.SetValue(UTGRI.ChatDelayTime);
    lblChatTime.SetText("Chat Delay = "$int(DelaySlider.GetValue())$" secs");

    lblFontSize = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 190, 15, 127, 16));
    lblFontSize.TextColor = TxtColor;
    lblFontSize.Align = TA_Center;
    lblFontSize.SetText("");

    FontSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl',190, 30, 127, 30));
    FontSlider.SliderWidth = 127;
    FontSlider.bAcceptsFocus = False;
    FontSlider.MinValue = 10;
    FontSlider.MaxValue = 24;
    FontSlider.Step = 2;
    FontSlider.SetText("  ");
    FontSlider.SetValue(UTGRI.ChatFontSize);
    FontSlider.TextColor = TxtColor;
    lblFontSize.SetText("Over-Ride Font: "$int(FontSlider.GetValue()));

    // Bottom Left
    EnableChat = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 10, 95, 150, 16));
    EnableChat.TextColor = TxtColor;
    EnableChat.SetText("Enable UTChat");
    EnableChat.bChecked = UTGRI.bShowChatMessages;

    DisEmojis = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 10, 115, 150, 16));
    DisEmojis.TextColor = TxtColor;
    DisEmojis.SetText("No Chat Emojis");
    DisEmojis.bChecked = UTGRI.bNoEmoticons;

    DisEmoFac = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 10, 135.0, 150, 16));
    DisEmoFac.TextColor = TxtColor;
    DisEmoFac.SetText("No Emoji Faces");
    DisEmoFac.bChecked = UTGRI.bNoEmojiFace;

    StartCont = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 10, 155.0, 150, 16));
    StartCont.TextColor = TxtColor;
    StartCont.SetText("Enable Start Control");
    StartCont.bChecked = UTGRI.bStartControl;

    NoBorders = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 10, 175.0, 150, 16));
    NoBorders.TextColor = TxtColor;
    NoBorders.SetText("Disable Chatbox Borders");
    NoBorders.bChecked = UTGRI.bNoChatBorders;

    NoShading = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 10, 195.0, 150, 16));
    NoShading.TextColor = TxtColor;
    NoShading.SetText("Disable Chatbox Shading");
    NoShading.bChecked = UTGRI.bNoChatShading;

    // Bottom Right
    EnableFont = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 190, 95, 150, 16));
    EnableFont.TextColor = TxtColor;
    EnableFont.SetText("Enable Font Override");
    EnableFont.bChecked = UTGRI.bFontOverRide;

    Duration = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 190, 115.0, 150, 16));
    Duration.TextColor = TxtColor;
    Duration.SetText("Enable Delay Override");
    Duration.bChecked = UTGRI.bAdminDuration;

    AntiSpam = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 190.0, 135.0, 150, 16));
    AntiSpam.TextColor = TxtColor;
    AntiSpam.SetText("Disable Anti-Spam Control");
    AntiSpam.bChecked = UTGRI.bNoAntiSpam;

    ClearBots = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 190.0, 155.0, 150, 16));
    ClearBots.TextColor = TxtColor;
    ClearBots.SetText("No Bots in Chatbox");
    ClearBots.bChecked = UTGRI.bNoBotsInChat;

    NoChatLog = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 190.0, 175.0, 150, 16));
    NoChatLog.TextColor = TxtColor;
    NoChatLog.SetText("Disable Chat Log");
    NoChatLog.bChecked = UTGRI.bNoChatLog;

    DMStdPlay = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 190.0, 195.0, 150, 16));
    DMStdPlay.TextColor = TxtColor;
    DMStdPlay.SetText("Std DM Player Color");
    DMStdPlay.bChecked = UTGRI.bStdDMPlayerColor;

    ClearChats = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 190, 215.0, 150, 16));
    ClearChats.TextColor = TxtColor;
    ClearChats.SetText("Clear Chat Log");
    ClearChats.bChecked = False;

    ButSubmit = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 5, 230, 102, 16));
    ButSubmit.Font = F_Bold;
    ButSubmit.SetText("< Submit All >");
    ButSubmit.DownSound = sound'UnrealShare.FSHLITE2';

    ButSend = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 278, 230, 50, 25));
    ButSend.SetText("Send");
    ButSend.DownSound = sound'UnrealShare.FSHLITE2';

    ButClose = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 333, 230, 50, 25));
    ButClose.SetText("Close");
    ButClose.DownSound = sound'UnrealShare.FSHLITE2';

  	AdminMesg = UTChatWinControl(CreateControl(Class'UTChatWinControl', 112, 230, 161, 16));
	AdminMesg.EditBoxWidth = 161;
	AdminMesg.SetNumericOnly(False);
	AdminMesg.SetFont(0);
	AdminMesg.SetHistory(True);
	AdminMesg.SetValue("");
	AdminMesg.Align=TA_Left;

    LabelMesg = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 112, 232, 160, 16));
    LabelMesg.SetText("Admin Message to all Players");
    LabelMesg.Align = TA_Center;
    LabelMesg.TextColor = DarkColor;

    SetAcceptsFocus();
	PrevWinWidth = WinWidth;
	PrevWinHeight = WinHeight;
}

function Notify (UWindowDialogControl C, byte E)
{
    Super.Notify(C,E);

    if (FW == None)
        FW = UWindowFramedWindow(GetParent(class'UWindowFramedWindow'));

    Switch(E)
    {
      case DE_Change:
      switch(C)
      {
        case RepeatSlider:
             if (int(RepeatSlider.GetValue()) == 0)
                 lblRepTime.SetText("Repeat Delay: 0.1 secs");
             else
                 lblRepTime.SetText("Repeat Delay: "$int(RepeatSlider.GetValue())$" secs");
             break;
        case FontSlider:
                 lblFontSize.SetText("Over-Ride Font: "$int(FontSlider.GetValue()));
             break;
        case DelaySlider:
             lblChatTime.SetText("Chat Delay: "$int(DelaySlider.GetValue())$" secs");
             break;
	  }
	  break;
	  case DE_Click:
	  switch(C)
      {
        case ButSend:
             SendAdminMessage();
             break;
        case ButClose:
             ParentWindow.ParentWindow.Close();
             break;
        case ButSubmit:
             AdminSave();
             ParentWindow.ParentWindow.Close();
             break;
        Case AntiSpam:
             FW.StatusBarText = "Click Submit to Accept - Set minimum Repeat Delay for best effect";
             if (AntiSpam.bChecked)
                 RepeatSlider.SetValue(0);
             break;
        Case EnableFont:
        Case EnableChat:
        Case DisEmojis:
        Case DisEmoFac:
        Case StartCont:
        Case NoBorders:
        Case NoShading:
        Case ClearBots:
        Case NoChatLog:
        Case DMStdPlay:
        Case ClearChats:
        Case Duration:
             FW.StatusBarText = "Click Submit to Accept.";
             break;
      }
      break;
      case DE_MouseMove:
      switch(C)
      {
        Case RepeatSlider:
             FW.StatusBarText = "The delay time before a duplicate message is displayed.";
             break;
        Case DelaySlider:
             FW.StatusBarText = "The delay time that the chat message takes to scroll up.";
             break;
        Case FontSlider:
             FW.StatusBarText = "Set the Font Size for all Players if Font Override is checked";
             break;
      }
	  break;
		case 7:
		     SendAdminMessage();
 		     break;
 	    case DE_MouseLeave:
		     FW.StatusBarText = "";
			 break;
      default:
        break;
    }
}

function AdminSave()
{
    local string sTemp;

    sTemp = int(EnableChat.bChecked)$","$int(DisEmojis.bChecked)$","$int(DisEmoFac.bChecked);
    sTemp = sTemp$","$int(ClearBots.bChecked)$","$int(DMStdPlay.bChecked)$","$int(RepeatSlider.GetValue());
    sTemp = sTemp$","$int(DelaySlider.GetValue())$","$int(StartCont.bChecked)$","$int(AntiSpam.bChecked);
    sTemp = sTemp$","$int(EnableFont.bChecked)$","$int(FontSlider.GetValue())$","$int(NoBorders.bChecked);
    sTemp = sTemp$","$int(NoChatLog.bChecked)$","$int(NoShading.bChecked)$","$int(Duration.bChecked);
    sTemp = sTemp$","$int(ClearChats.bChecked)$",";

    GetPlayerOwner().ConsoleCommand("Mutate UTChat AdminChat "$sTemp);
}

function KeyDown( int Key, float X, float Y )
{
    ParentWindow.KeyDown(Key,X,Y);
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
        LabelMesg.WinTop += DiffY;

        ButSubmit.WinTop  += DiffY;

        ButSend.WinLeft += DiffX;
        ButSend.WinTop  += DiffY;

		ButClose.WinLeft += DiffX;
		ButClose.WinTop  += DiffY;

        AdminMesg.WinTop += DiffY;
		AdminMesg.SetSize(AdminMesg.WinWidth + DiffX, AdminMesg.WinHeight);
		AdminMesg.EditBoxWidth = AdminMesg.WinWidth;
	}
	PrevWinWidth = WinWidth;
	PrevWinHeight = WinHeight;
}

function BeforePaint( Canvas C, float X, float Y )
{
	Super.BeforePaint(C, X, Y);
}

function Paint(Canvas C, float MouseX, float MouseY)
{
	Super.Paint(C,MouseX,MouseY);

    DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BlackTexture');
    C.Style = GetPlayerOwner().ERenderStyle.STY_Normal;
}

function Tick( float delta )
{
    if (AdminMesg.GetValue() != "")
        LabelMesg.SetText("");

    Super.Tick(delta);
}

function SendAdminMessage()
{
    local string sMesg;

 	if (AdminMesg.GetValue() != "")
	{
	    sMesg = AdminMesg.GetValue();
	    GetPlayerOwner().ConsoleCommand("Mutate UTChat AdminMesg "$sMesg);
	    AdminMesg.SetValue("");
	    LabelMesg.SetText("Admin Message to all Players");
	}
}

function Close(optional bool bByParent)
{
	Super.Close(bByParent);
}

defaultproperties
{
    DarkColor=(R=128,G=128,B=128,A=0)
    TxtColor=(R=255,G=255,B=255,A=0)
}

