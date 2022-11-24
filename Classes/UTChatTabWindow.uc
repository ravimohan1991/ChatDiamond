//=============================================================================
// UTChatTabWindow - TabWindow
//=============================================================================

class UTChatTabWindow extends UWindowDialogClientWindow;

#exec texture IMPORT NAME=Emojis1 File=Textures\emojis1.pcx GROUP=Commands Mips=on
#exec texture IMPORT NAME=Emojis2 File=Textures\emojis2.pcx GROUP=Commands Mips=off

var UTChatGRI UTGRI;
var UTChatWRI UTWRI;

var UMenuPageControl    Pages;
var UTChatWindowChat    ChatWindow;
var UTChatWindowAdmin   AdminWindow;
var UTChatWindowConfig  ConfigWindow;
var UTChatWindowEmojis  EmojiWindow;

function Created()
{
    local UWindowPageControlPage PageControl;

    Super.Created();

    if ( UTGRI == none )
    {
       foreach GetPlayerOwner().AllActors(class'UTChatGRI', UTGRI)
       break;
    }

    if ( UTWRI == none )
    {
        foreach GetPlayerOwner().AllActors(class'UTChatWRI', UTWRI)
        break;
    }

    WinLeft = int(Root.WinWidth - WinWidth) / 2;
    WinTop = int(Root.WinHeight - WinHeight) / 2;

    Pages = UMenuPageControl(CreateWindow(class'UMenuPageControl', 0, 0, WinWidth, WinHeight));
    Pages.SetMultiLine(false);

    if (UTWRI.bEmojis)
    {
        PageControl = Pages.AddPage( "Emojis", class'UTChatWindowEmojis');
        EmojiWindow = UTChatWindowEmojis(PageControl.Page);
        return;
    }

    if (GetPlayerOwner().PlayerReplicationInfo.bAdmin || GetPlayerOwner().bAdmin)
    {
        PageControl = Pages.AddPage( "Admin", class'UTChatWindowAdmin');
        AdminWindow = UTChatWindowAdmin(PageControl.Page);

        PageControl = Pages.AddPage( "Public Chats", class'UTChatWindowChat');
        ChatWindow = UTChatWindowChat(PageControl.Page);
    }
    else
    {
        if (!UTGRI.bNoChatLog)
        {
            PageControl = Pages.AddPage( "Public Chats", class'UTChatWindowChat');
            ChatWindow = UTChatWindowChat(PageControl.Page);
        }

        PageControl = Pages.AddPage( "Configs", class'UTChatWindowConfig');
        ConfigWindow = UTChatWindowConfig(PageControl.Page);

        PageControl = Pages.AddPage( "Emojis", class'UTChatWindowEmojis');
        EmojiWindow = UTChatWindowEmojis(PageControl.Page);
    }
}

function AddChatMessage(string sMesg)
{
    if (!UTGRI.bNoChatLog && ChatWindow != None)
        ChatWindow.LoadMessages(sMesg);
}

function Resized()
{
	Super.Resized();
	Pages.SetSize(WinWidth, WinHeight);
}

function Close(optional bool bByParent)
{
    Super.Close(bByParent);
}

defaultproperties
{
}
