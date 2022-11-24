//=======================================================
// UTChatWinCheck - Collects key stroke for keybind
//=======================================================
class UTChatWinCheck extends UWindowCheckbox;

var UTChatWindowConfig UTWC;

function KeyDown(int Key, float X, float Y)
{
    if (UTWC != None)
    {
        UTWC.KeyDown(Key, X, Y);
    }
    else
        Super.KeyDown(Key, X, Y);
}

defaultproperties
{
}
