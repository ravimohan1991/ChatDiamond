//=======================================================
// UTChatWinControl - Collects key stroke for keybind
//=======================================================
class UTChatWinControl extends UWindowEditControl;

var UTChatWindowChat    UTWC;
var UTChatWindowConfig  UTWG;

function KeyDown(int Key, float X, float Y)
{
    if (UTWC != None)
    {
        UTWC.KeyDown(Key, X, Y);
    }
    else
    if (UTWG != None)
    {
        UTWG.KeyDown(Key, X, Y);
    }
    else
        Super.KeyDown(Key, X, Y);
}

defaultproperties
{
}
