class UTChatTextArea expands UWindowDynamicTextArea;

var int MyPos;
var bool bChat;
var bool bCol;
var Color ChtColor, GrnColor, YelColor, BluColor, RedColor, WhtColor, TxtColor;

function Created()
{
	Super.Created();
}

function float DrawTextLine(Canvas C, UWindowDynamicTextRow L, float Y)
{
    local float X, X1, X2;
    local string sDate, sName, sMesg, sTm;
    local int i;

    X = 2;
    sTm = "-";
    if (bChat)
    {
        if (Mid(L.Text, 2, 1) == "/")            // 07/28 > 22:59  Jojoza: This is a test message to check whatever.
        {
            sTm = Mid(L.Text, 6, 1);             // Teams 0,1,2,3,255 < > = + -
            sDate = Left(L.Text, 6)$"-"$Mid(L.Text, 7, 8);
            sMesg = Mid(L.Text, 15);
            i = InStr(sMesg, ": ");
            if (i > 0)
            {
                sName = Left(sMesg, i+1);
                sMesg = Mid(sMesg, i+2);
                TextSize(C, sDate, X1, X2);
                C.DrawColor = ChtColor;
                C.SetPos(X, Y);
                TextAreaClipText(C, X, Y, sDate);
                if (bChat)
                {
                    if (sTm == "<")
                        C.DrawColor = RedColor;
                    else
                    if (sTm == ">")
                        C.DrawColor = BluColor;
                    else
                    if (sTm == "=")
                        C.DrawColor = GrnColor;
                    else
                    if (sTm == "+")
                        C.DrawColor = YelColor;
                    else
                        C.DrawColor = WhtColor;

                    X = X1+2;
                    C.SetPos(X, Y);
                    TextAreaClipText(C, X, Y, sName);

                    C.DrawColor = TxtColor;
                    TextSize(C, sDate$sName$"  ", X1, X2);
                    X = X1+2;
                    TextAreaClipText(C, X, Y, sMesg);
                }
                return DefaultTextHeight;
            }
        }

        if (Mid(L.Text, 2, 1) != "/")
        {
            TextSize(C, "07/28 - 12:34   ", X1, X2);
            X = X1;
        }

        C.DrawColor = TxtColor;
        TextAreaClipText(C, X, Y, L.Text);
    }
    else
    {
        TextAreaClipText(C, X, Y, Mid(L.Text, MyPos/4));
    }

	return DefaultTextHeight;
}

defaultproperties
{
     bScrollOnResize=True
     bNoKeyboard=True
     ChtColor=(R=25,G=225,B=225)
     RedColor=(R=255)
     BluColor=(G=84,B=255)
     GrnColor=(G=255)
     YelColor=(R=160,G=160)
     WhtColor=(R=250,G=250,B=250)
     TxtColor=(R=160,G=160,B=160)
}
