//================================================================================
// UTChatWindowConfig
//================================================================================
//
class UTChatWindowConfig extends UWindowPageWindow;

var UTChatGRI UTGRI;
var UTChatHud UTHUD;

var UWindowSmallButton ButClose;

var UMenuLabelControl  lblKeyBind2;
var UMenuLabelControl  lblKeyBind1;
var UMenuRaisedButton  ButChatKey;

var UTChatWinCheck     ClientChat;
var UTChatWinCheck     ClientEmoji;
var UTChatWinCheck     StdDMPlayer;
var UTChatWinCheck     SolidChat;
var UTChatWinCheck     BotsInChat;
var UTChatWinCheck     ChatBorder;
var UTChatWinCheck     EmojiFace;

var UMenuLabelControl  lblChatPos;
var UWindowHSliderControl LineSlider;

var UMenuLabelControl  lblOtherPos;
var UWindowHSliderControl OtherSlider;

var UMenuLabelControl  lblEmojiTrim;
var UWindowHSliderControl EmojiSlider;

var UMenuLabelControl  lblFontSize;
var UWindowHSliderControl FontSlider;

var UMenuLabelControl  lblShadeCol;
var UWindowHSliderControl ShadeSlider;

var UMenuLabelControl  lblWidthSize;
var UWindowHSliderControl WidthSlider;

var UMenuLabelControl  lblChatDur;
var UWindowHSliderControl ChatDurSlider;

var UMenuLabelControl  lblGameDur;
var UWindowHSliderControl GameDurSlider;

var UMenuLabelControl  LabHelping;
var UWindowComboControl MutedCombo;

var string RealKeyName[255];

var color TxtColor, DarkColor;
var bool bAdmin, bCheckFonts, bChat;
var string OldHelpKey;
var int iTick;

var UWindowFramedWindow FW;

var float PrevWinWidth, PrevWinHeight;

function Created ()
{
	Super.Created();

    bCheckFonts = false;

    FW = UWindowFramedWindow(GetParent(class'UWindowFramedWindow'));

    if ( UTGRI == none )
    {
       foreach GetPlayerOwner().AllActors(class'UTChatGRI', UTGRI)
       break;
    }

    if ( UTHUD == none )
    {
       foreach GetPlayerOwner().AllActors(class'UTChatHud', UTHUD)
           break;
    }

    lblKeyBind1 = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 287, 10, 115, 16));
    lblKeyBind1.TextColor = TxtColor;
    lblKeyBind1.SetText("Bind Chat Window");

    ButChatKey = UMenuRaisedButton(CreateControl(class'UMenuRaisedButton', 282, 26, 95, 18));
    ButChatKey.bAcceptsFocus = False;
    ButChatKey.Align = TA_Center;
    ButChatKey.bIgnoreLDoubleClick = True;
    ButChatKey.bIgnoreMDoubleClick = True;
    ButChatKey.bIgnoreRDoubleClick = True;

    lblKeyBind2 = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 303, 50, 100, 16));
    lblKeyBind2.SetText("");
    lblKeyBind2.TextColor = TxtColor;

    MutedCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', 282, 67, 95, 16));
    MutedCombo.SetFont(F_Normal);
    MutedCombo.EditBoxWidth = 95;
    MutedCombo.SetEditable(False);
    MutedCombo.List.MaxVisible = 6;

    if (UTGRI.bShowChatMessages == True)
    {
        ClientChat = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 10.0, 10.0, 125, 16));
        ClientChat.TextColor = TxtColor;
        ClientChat.SetText("Enable Client Chat");
        ClientChat.bChecked = UTHUD.default.bUseUTChat;
        ClientChat.UTWC = self;

        SolidChat = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 10.0, 30.0, 125, 16));
        SolidChat.TextColor = TxtColor;
        SolidChat.SetText("Enable Dark Shading");
        SolidChat.bChecked = UTHUD.default.bSolidChat;
        SolidChat.UTWC = self;
        SolidChat.bDisabled = UTGRI.bNoChatShading;

        ChatBorder = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 10.0, 50.0, 125, 16));
        ChatBorder.TextColor = TxtColor;
        ChatBorder.SetText("Enable Chat Borders");
        ChatBorder.bChecked = UTHUD.default.bChatBorder;
        ChatBorder.UTWC = self;
        ChatBorder.bDisabled = UTGRI.bNoChatBorders;

        ClientEmoji = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 145.0, 70.0, 125, 16)); //10.0, 70.0, 125, 16));
        ClientEmoji.TextColor = TxtColor;
        ClientEmoji.SetText("Enable Chat Emojis");
        ClientEmoji.bChecked = UTHUD.default.bUseEmojis;
        ClientEmoji.UTWC = self;
        ClientEmoji.bDisabled = UTGRI.bNoEmoticons;

        StdDMPlayer = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 145.0, 10.0, 125, 16));
        StdDMPlayer.TextColor = TxtColor;
        StdDMPlayer.SetText("Std DM Player Color");
        StdDMPlayer.bChecked = UTHUD.default.bStdColor;
        StdDMPlayer.UTWC = self;
        StdDMPlayer.bDisabled = UTGRI.bNoEmoticons;

        BotsInChat = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 145.0, 30.0, 125, 16));
        BotsInChat.TextColor = TxtColor;
        BotsInChat.SetText("Enable Bots in Chat");
        BotsInChat.bChecked = UTHUD.default.bBotsInChat;
        BotsInChat.UTWC = self;
        BotsInChat.bDisabled = UTGRI.bNoBotsInChat;

        EmojiFace = UTChatWinCheck(CreateControl(class'UTChatWinCheck', 145.0, 50.0, 125, 16));
        EmojiFace.TextColor = TxtColor;
        EmojiFace.SetText("Enable Emoji in Face");
        EmojiFace.bChecked = UTHUD.default.bSwapFaces;
        EmojiFace.UTWC = self;
        EmojiFace.bDisabled = UTGRI.bNoEmojiFace;

        lblChatPos = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 10, 95, 120, 16));
        lblChatPos.TextColor = TxtColor;
        lblChatPos.Align = TA_Center;
        lblChatPos.SetText("");

        LineSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl',10, 110, 120, 30));
        LineSlider.SliderWidth = 120;
        LineSlider.bAcceptsFocus = False;
        LineSlider.MinValue = 2;
        LineSlider.MaxValue = 6;
        LineSlider.Step = 1;
        LineSlider.SetText("  ");
        LineSlider.SetValue(UTHUD.default.ChatLines);
        LineSlider.TextColor = TxtColor;
        lblChatPos.SetText("Chat Text Lines = "$int(LineSlider.GetValue()));

        lblOtherPos = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 10, 130, 120, 16));
        lblOtherPos.TextColor = TxtColor;
        lblOtherPos.Align = TA_Center;
        lblOtherPos.SetText("");

        OtherSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl',10, 145, 120, 30));
        OtherSlider.SliderWidth = 120;
        OtherSlider.bAcceptsFocus = False;
        OtherSlider.MinValue = 0;
        OtherSlider.MaxValue = 8;
        OtherSlider.Step = 1;
        OtherSlider.SetText("  ");
        OtherSlider.SetValue(UTHUD.default.OtherLines);
        OtherSlider.TextColor = TxtColor;
        lblOtherPos.SetText("Other Text Lines = "$int(OtherSlider.GetValue()));

        lblFontSize = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 145, 95, 120, 16));
        lblFontSize.TextColor = TxtColor;
        lblFontSize.Align = TA_Center;
        lblFontSize.SetText("");

        FontSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', 145, 110, 120, 30));
        FontSlider.SliderWidth = 120;
        FontSlider.bAcceptsFocus = False;
        FontSlider.MinValue = 10;
        FontSlider.MaxValue = 26;
        FontSlider.Step = 2;
        FontSlider.SetText("  ");
        FontSlider.SetValue(UTHUD.default.MyFontSize);
        FontSlider.TextColor = TxtColor;
        if (UTHUD.default.MyFontSize > 24)
            lblFontSize.SetText("Font Size = Auto");
        else
            lblFontSize.SetText("Font Size = "$int(FontSlider.GetValue()));

        if (UTGRI.bFontOverRide)
        {
            lblFontSize.SetText("Disabled by Admin");
            FontSlider.MinValue = 0;
            FontSlider.MaxValue = 0;
            FontSlider.Step = 0;
        }

        lblShadeCol = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 145, 130, 120, 16));
        lblShadeCol.TextColor = TxtColor;
        lblShadeCol.Align = TA_Center;
        lblShadeCol.SetText("");

        ShadeSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', 145, 145, 120, 30));
        ShadeSlider.SliderWidth = 120;
        ShadeSlider.bAcceptsFocus = False;
        ShadeSlider.MinValue = 0;
        ShadeSlider.MaxValue = 100;
        ShadeSlider.Step = 5;
        ShadeSlider.SetText("  ");
        ShadeSlider.SetValue(UTHUD.default.ShadeColor);
        ShadeSlider.TextColor = TxtColor;
        if (UTGRI.bNoChatShading)
        {
            lblShadeCol.SetText("Disabled by Admin");
            ShadeSlider.MaxValue = 0;
        }
        else
            lblShadeCol.SetText("Shade Value = "$int(ShadeSlider.GetValue())$"%");

        lblWidthSize = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 145, 165, 120, 16));
        lblWidthSize.TextColor = TxtColor;
        lblWidthSize.Align = TA_Center;
        lblWidthSize.SetText("");

        WidthSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', 145, 180, 120, 30));
        WidthSlider.SliderWidth = 120;
        WidthSlider.bAcceptsFocus = False;
        WidthSlider.MinValue = 0;
        WidthSlider.MaxValue = 10;
        WidthSlider.Step = 1;
        WidthSlider.SetText("  ");
        WidthSlider.SetValue(UTHUD.default.ChatBoxSize);
        WidthSlider.TextColor = TxtColor;
        if (UTGRI.bNoChatShading && UTGRI.bNoChatBorders)
        {
            lblWidthSize.SetText("Disabled by Admin");
            WidthSlider.MaxValue = 0;
        }
        else
            lblWidthSize.SetText("ChatBox Adjust = "$int(WidthSlider.GetValue()));

        lblEmojiTrim = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 10, 165, 120, 16));
        lblEmojiTrim.TextColor = TxtColor;
        lblEmojiTrim.Align = TA_Center;
        lblEmojiTrim.SetText("");

        EmojiSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl',10, 180, 120, 30));
        EmojiSlider.SliderWidth = 120;
        EmojiSlider.bAcceptsFocus = False;
        EmojiSlider.MinValue = 0;
        EmojiSlider.MaxValue = 9;
        EmojiSlider.Step = 1;
        EmojiSlider.SetText("  ");
        EmojiSlider.TextColor = TxtColor;
        EmojiSlider.SetValue(int(UTHUD.default.EmojiTrim));
        lblEmojiTrim.SetText("Emoji Size Trim = "$int(EmojiSlider.GetValue()));

        //if (!UTGRI.bAdminDuration)
        //{
            lblChatDur = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 10, 200, 120, 16));
            lblChatDur.TextColor = TxtColor;
            lblChatDur.Align = TA_Center;
            lblChatDur.SetText("");

            ChatDurSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl',10, 215, 120, 30));
            ChatDurSlider.SliderWidth = 120;
            ChatDurSlider.bAcceptsFocus = False;
            ChatDurSlider.MinValue = 0;
            ChatDurSlider.MaxValue = 20;
            ChatDurSlider.Step = 1;
            ChatDurSlider.SetText("  ");
            ChatDurSlider.TextColor = TxtColor;
            ChatDurSlider.SetValue(UTHUD.default.ChatDuration);
            lblChatDur.SetText("Chat Duration = "$int(ChatDurSlider.GetValue())$" secs");

            lblGameDur = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 145, 200, 120, 16));
            lblGameDur.TextColor = TxtColor;
            lblGameDur.Align = TA_Center;
            lblGameDur.SetText("");

            GameDurSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl',145, 215, 120, 30));
            GameDurSlider.SliderWidth = 120;
            GameDurSlider.bAcceptsFocus = False;
            GameDurSlider.MinValue = 0;
            GameDurSlider.MaxValue = 20;
            GameDurSlider.Step = 1;
            GameDurSlider.SetText("  ");
            GameDurSlider.TextColor = TxtColor;
            GameDurSlider.SetValue(UTHUD.default.OtherDuration);
            lblGameDur.SetText("Other Duration = "$int(GameDurSlider.GetValue())$" secs");
        //}

        if (UTGRI.bAdminDuration)
        {
            ChatDurSlider.MaxValue = 0;
            GameDurSlider.MaxValue = 0;
            lblChatDur.SetText("Disabled by Admin");
            lblGameDur.SetText("Disabled by Admin");
        }

        if (UTGRI.bNoEmoticons)
        {
            EmojiSlider.MaxValue = 0;
            lblEmojiTrim.SetText("Disabled by Admin");
        }
        else
        {
            LabHelping = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 10, 230, 260, 16));
            LabHelping.TextColor = TxtColor;
            LabHelping.SetText("Type  :?  or  !emojis  for Emoji and Banner Help ");
        }
    }

    ButClose = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 333, 230, 50, 25));
    ButClose.SetText("Close");
    ButClose.DownSound = sound'UnrealShare.FSHLITE2';

    iTick = 30;  // load mute playernames
    CheckDisabled();

    LoadExistingKeys();
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
        case ChatDurSlider:
             if (!UTGRI.bAdminDuration)
             {
                 lblChatDur.SetText("Chat Duration = "$int(ChatDurSlider.GetValue())$" secs");
                 SaveHUD();
             }
             else lblChatDur.SetText("Disabled by Admin");
             break;
        case GameDurSlider:
             if (!UTGRI.bAdminDuration)
             {
                 lblGameDur.SetText("Other Duration = "$int(GameDurSlider.GetValue())$" secs");
                 SaveHUD();
             }
             else lblGameDur.SetText("Disabled by Admin");
             break;
        case EmojiSlider:
             if (!UTGRI.bNoEmoticons)
             {
                 lblEmojiTrim.SetText("Emoji Size Trim = "$int(EmojiSlider.GetValue()));
                 SaveHUD();
             }
             else lblEmojiTrim.SetText("Disabled by Admin");
             break;
        case OtherSlider:
             lblOtherPos.SetText("Other Text Lines: "$int(OtherSlider.GetValue()));
             SaveHUD();
             break;
        case LineSlider:
             lblChatPos.SetText("Chat  Text Lines: "$int(LineSlider.GetValue()));
             SaveHUD();
             break;
        case FontSlider:
             if (int(FontSlider.GetValue()) > 24)
                 lblFontSize.SetText("Font Size = Auto");
             else
                 lblFontSize.SetText("Font Size = "$int(FontSlider.GetValue()));
             if (UTGRI.bFontOverRide)
             {
                 lblFontSize.SetText("Font Size = "$UTGRI.ChatFontSize);
                 break;
             }
             SaveHUD();
             break;
        case ShadeSlider:
             if (UTGRI.bNoChatShading)
                 lblShadeCol.SetText("Disabled by Admin");
             else
                 lblShadeCol.SetText("Shade Value = "$int(ShadeSlider.GetValue())$"%");
             SaveHUD();
             break;
        case WidthSlider:
             lblWidthSize.SetText("ChatBox Adjust = "$int(WidthSlider.GetValue()));
             SaveHUD();
             break;
        case MutedCombo:
             if (MutedCombo.GetValue() != " Mute a Player")
                 SaveMute();
             break;
	  }
	  break;
	  case DE_Click:
	  switch(C)
      {
        case ButClose:
             ParentWindow.ParentWindow.Close();
             break;
        case ClientEmoji:
             SaveHUD();
             break;
        case EmojiFace:
             SaveHUD();
             break;
        case ClientChat:
             SaveHUD();
             break;
        case SolidChat:
             SaveHUD();
             break;
        case StdDMPlayer:
             SaveHUD();
             break;
        case BotsInChat:
             SaveHUD();
             break;
        case ChatBorder:
             SaveHUD();
             break;
        case ButChatKey:
             bChat = True;
             ButChatKey.bDisabled = True;
             DisplayInfo();
             break;
      }
      break;
 	  case DE_MouseLeave:
		     FW.StatusBarText = "";
			 break;
      default:
        break;
    }
}

function CheckDisabled()
{
    if (SolidChat.bDisabled)
        SolidChat.TextColor = DarkColor;

    if (ChatBorder.bDisabled)
        ChatBorder.TextColor = DarkColor;

    if (ClientEmoji.bDisabled)
        ClientEmoji.TextColor = DarkColor;

    if (EmojiFace.bDisabled)
        EmojiFace.TextColor = DarkColor;

    if (StdDMPlayer.bDisabled)
        StdDMPlayer.TextColor = DarkColor;

    if (BotsInChat.bDisabled)
        BotsInChat.TextColor = DarkColor;
}

function SaveMute()
{
    local string sTemp;
    local int i;

    if ( UTHUD == none )
    {
        foreach Root.GetPlayerOwner().AllActors(class'UTChatHud', UTHUD)
        break;
    }

    sTemp = MutedCombo.GetValue();
    if (sTemp == "" || sTemp ==  " Mute a Player")
        return;

    if (Left(sTemp, 1) == "*")
    {
        sTemp = Mid(sTemp, 1);
        for (i=0; i<10; i++)
        {
            if (UTHUD.Mutes[i] == sTemp)        // already done
            {
                UTHUD.Mutes[i] = "";
                GetPlayerOwner().ClientMessage(sTemp$" has been un-muted.");
                LoadMutedList();
                return;
            }
        }
    }

    for (i=0; i<10; i++)
    {
        if (UTHUD.Mutes[i] == "")
        {
            UTHUD.Mutes[i] = sTemp;
            GetPlayerOwner().ClientMessage(sTemp$" has been muted.");
            LoadMutedList();
            return;
        }
    }
    GetPlayerOwner().ClientMessage("Max 10 Players already muted!");
}

function SaveHUD()
{
    if ( UTHUD == none )
    {
        foreach Root.GetPlayerOwner().AllActors(class'UTChatHud', UTHUD)
        break;
    }

    UTHUD.bSolidChat   = SolidChat.bChecked;
    UTHUD.bUseUTChat   = ClientChat.bChecked;
    UTHUD.bBotsInChat  = BotsInChat.bChecked;
    UTHUD.bStdColor    = StdDMPlayer.bChecked;
    UTHUD.bChatBorder  = ChatBorder.bChecked;

    if (!UTGRI.bNoEmoticons)
    {
        UTHUD.bUseEmojis = ClientEmoji.bChecked;
        UTHUD.bSwapFaces = EmojiFace.bChecked;
        if (EmojiSlider != None)
            UTHUD.EmojiTrim = int(EmojiSlider.GetValue());
    }

    if (LineSlider != None)
        UTHUD.ChatLines  = int(LineSlider.GetValue());
    if (OtherSlider != None)
        UTHUD.OtherLines  = int(OtherSlider.GetValue());
    if (FontSlider != None)
        UTHUD.MyFontSize = int(FontSlider.GetValue());
    if (ShadeSlider != None)
        UTHUD.ShadeColor = int(ShadeSlider.GetValue());
    if (WidthSlider != None)
        UTHUD.ChatBoxSize = int(WidthSlider.GetValue());
    if (ChatDurSlider != None)
        UTHUD.ChatDuration = int(ChatDurSlider.GetValue());
    if (GameDurSlider != None)
        UTHUD.OtherDuration = int(GameDurSlider.GetValue());

    UTHUD.SaveConfig();
    bCheckFonts = true;
    CheckDisabled();
}

function LoadExistingKeys()
{
    local int i;
    local string KeyName;
    local string Alias;

    if (bAdmin)
        return;

    for (i=0; i<255; i++)
    {
         KeyName = GetPlayerOwner().ConsoleCommand( "KEYNAME "$i );
         RealKeyName[i] = KeyName;
         if ( KeyName != "" )
         {
              Alias = GetPlayerOwner().ConsoleCommand( "KEYBINDING "$KeyName );
              if ( Caps(Alias) == "MUTATE UTCHAT SHOWCHATLOG")
              {
                 ButChatKey.SetText(KeyName);
                 OldHelpKey = KeyName;
              }
         }
    }
}

function KeyDown( int Key, float X, float Y )
{
    ParentWindow.KeyDown(Key,X,Y);

    if (bChat)
    {
        ProcessKey(Key, RealKeyName[Key]);
        bChat = False;
        ButChatKey.bDisabled = False;
        lblKeyBind2.SetText("");
    }
}

function ProcessKey( int KeyNo, string KeyName )
{
     if ( (KeyName == "") || (KeyName == "Escape")
          || ((KeyNo >= 0x70 ) && (KeyNo <= 0x75)) // function keys f1 - f6
          || ((KeyNo >= 0x78 ) && (KeyNo <= 0x7b)) // function keys f9 - f12
          || ((KeyNo >= 0x30 ) && (KeyNo <= 0x39))) // number keys  0 - 9
          return;

     if (bChat)
     {
        SetMenuKey(KeyNo, KeyName);
        return;
     }
}

function SetMenuKey(int KeyNo, string KeyName)
{
   GetPlayerOwner().ConsoleCommand("SET Input "$KeyName$" MUTATE UTCHAT SHOWCHATLOG");
   ButChatKey.SetText(KeyName);
   if(OldHelpKey != "" && OldHelpKey != KeyName) // clear the old key binding
   {
      GetPlayerOwner().ConsoleCommand("SET Input "$OldHelpKey);
   }
}

function DisplayInfo()
{
    lblKeyBind2.SetText("Press a Key");
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
		if (!UTGRI.bNoEmoticons)
		    LabHelping.WinTop += DiffY;

		ButClose.WinLeft += DiffX;
		ButClose.WinTop += DiffY;
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

    if (bCheckFonts)
    {
        UTHUD.Setup(C);
        bCheckFonts = false;
    }
}

function Tick( float delta )
{
    if (iTick > 0)
    {
        iTick--;
        if (iTick == 0)
        {
            LoadMutedList();
        }
    }

    Super.Tick(delta);
}

function bool CheckForMute(string sName)
{
    local int i;

    for (i=0; i<10; i++)
    {
        if (UTHUD.Mutes[i] == sName)
            return True;
    }
    return False;
}

function LoadMutedList()
{
    local string sTemp;
    local int i;

    if (UTHUD == None)
    {
       foreach GetPlayerOwner().AllActors(class'UTChatHud', UTHUD)
       break;
    }

    MutedCombo.Clear();

    for (i=0; i<32; i++)
    {
        sTemp = UTGRI.Players[i];
        if (sTemp == "")
            break;
        if (CheckForMute(sTemp))
            sTemp = "*"$sTemp;
        MutedCombo.AddItem(sTemp);
    }

    if (UTHUD.bBotsInChat || UTGRI.bLocal)
    {
        for (i=0; i<32; i++)
        {
            sTemp = UTGRI.BotNames[i];
            if (sTemp == "")
                break;
            if (CheckForMute(sTemp))
                sTemp = "*"$sTemp;
            MutedCombo.AddItem(sTemp);
        }
    }

    MutedCombo.SetSelectedIndex(-1);
    MutedCombo.EditBox.Value = " Mute a Player";
}

function Close(optional bool bByParent)
{
	Super.Close(bByParent);
}

defaultproperties
{
    DarkColor=(R=84,G=84,B=84,A=0)
    TxtColor=(R=255,G=255,B=255,A=0)
}

