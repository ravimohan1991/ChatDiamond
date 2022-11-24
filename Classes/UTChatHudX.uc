//===============================================================================
//               UTChatHudX - by ProAsm and No0ne - 2021
//===============================================================================
//
class UTChatHudX expands Info;

#exec OBJ LOAD FILE=..\Textures\LadrStatic.utx PACKAGE=Botpack.LadrStatic

#exec Texture Import File=Textures\1faceless.pcx    Name=Faceless    Mips=off

#exec Texture Import File=Textures\smile.bmp        Name=Smile       Mips=off
#exec Texture Import File=Textures\sad.bmp          Name=Sad         Mips=off
#exec Texture Import File=Textures\eyes.bmp         Name=Eyes        Mips=off
#exec Texture Import File=Textures\tup.bmp          Name=ThumbUp     Mips=off
#exec Texture Import File=Textures\tdown.bmp        Name=ThumbDown   Mips=off
#exec Texture Import File=Textures\happy.bmp        Name=Happy       Mips=off
#exec Texture Import File=Textures\bomb.bmp         Name=Bomb        Mips=off
#exec Texture Import File=Textures\fist.bmp         Name=Fist        Mips=off
#exec Texture Import File=Textures\hand.bmp         Name=Hand        Mips=off
#exec Texture Import File=Textures\hundreds.bmp     Name=Hundreds    Mips=off
#exec Texture Import File=Textures\grin.bmp         Name=Grin        Mips=off
#exec Texture Import File=Textures\ok.bmp           Name=Okey        Mips=off
#exec Texture Import File=Textures\pointup.bmp      Name=PointUp     Mips=off
#exec Texture Import File=Textures\question.bmp     Name=Question    Mips=off
#exec Texture Import File=Textures\rofl.bmp         Name=ROFL        Mips=off
#exec Texture Import File=Textures\sunglasses.bmp   Name=Sunglass    Mips=off
#exec Texture Import File=Textures\think.bmp        Name=Think       Mips=off
#exec Texture Import File=Textures\tongue.bmp       Name=Tongue      Mips=off
#exec Texture Import File=Textures\zzz.bmp          Name=Zzz         Mips=off
#exec Texture Import File=Textures\wink.bmp         Name=Wink        Mips=off
#exec Texture Import File=Textures\silly.bmp        Name=Silly       Mips=off
#exec Texture Import File=Textures\heart.bmp        Name=Heart       Mips=off
#exec Texture Import File=Textures\peace.bmp        Name=Peace       Mips=off
#exec Texture Import File=Textures\rockon.bmp       Name=Rockon      Mips=off
#exec Texture Import File=Textures\mask.bmp         Name=Mask        Mips=off
#exec Texture Import File=Textures\squint.bmp       Name=Squint      Mips=off
#exec Texture Import File=Textures\facepalm.bmp     Name=FacePalm    Mips=off
#exec Texture Import File=Textures\shrug.bmp        Name=Shrug       Mips=off

#exec Texture Import File=Textures\xsmile.bmp       Name=XSmile      Mips=off
#exec Texture Import File=Textures\xsad.bmp         Name=XSad        Mips=off
#exec Texture Import File=Textures\xeyes.bmp        Name=XEyes       Mips=off
#exec Texture Import File=Textures\xtup.bmp         Name=XThumbUp    Mips=off
#exec Texture Import File=Textures\xtdown.bmp       Name=XThumbDown  Mips=off
#exec Texture Import File=Textures\xhappy.bmp       Name=XHappy      Mips=off
#exec Texture Import File=Textures\xbomb.bmp        Name=XBomb       Mips=off
#exec Texture Import File=Textures\xfist.bmp        Name=XFist       Mips=off
#exec Texture Import File=Textures\xhand.bmp        Name=XHand       Mips=off
#exec Texture Import File=Textures\xhundreds.bmp    Name=XHundreds   Mips=off
#exec Texture Import File=Textures\xgrin.bmp        Name=XGrin       Mips=off
#exec Texture Import File=Textures\xok.bmp          Name=XOkey       Mips=off
#exec Texture Import File=Textures\xpointup.bmp     Name=XPointUp    Mips=off
#exec Texture Import File=Textures\xquestion.bmp    Name=XQuestion   Mips=off
#exec Texture Import File=Textures\xrofl.bmp        Name=XROFL       Mips=off
#exec Texture Import File=Textures\xsunglasses.bmp  Name=XSunglass   Mips=off
#exec Texture Import File=Textures\xthink.bmp       Name=XThink      Mips=off
#exec Texture Import File=Textures\xtongue.bmp      Name=XTongue     Mips=off
#exec Texture Import File=Textures\xzzz.bmp         Name=XZzz        Mips=off
#exec Texture Import File=Textures\xwink.bmp        Name=XWink       Mips=off
#exec Texture Import File=Textures\xsilly.bmp       Name=XSilly      Mips=off
#exec Texture Import File=Textures\xheart.bmp       Name=XHeart      Mips=off
#exec Texture Import File=Textures\xpeace.bmp       Name=XPeace      Mips=off
#exec Texture Import File=Textures\xrockon.bmp      Name=XRockon     Mips=off
#exec Texture Import File=Textures\xmask.bmp        Name=XMask       Mips=off
#exec Texture Import File=Textures\xsquint.bmp      Name=XSquint     Mips=off
#exec Texture Import File=Textures\xfacepalm.bmp    Name=XFacePalm   Mips=off
#exec Texture Import File=Textures\xshrug.bmp       Name=XShrug      Mips=off

#exec Texture Import File=Textures\welldone.bmp     Name=WellDone    Mips=off
#exec Texture Import File=Textures\wtf.bmp          Name=WTF         Mips=off
#exec Texture Import File=Textures\womg.bmp         Name=OMG         Mips=off
#exec Texture Import File=Textures\wlol.bmp         Name=LOL         Mips=off
#exec Texture Import File=Textures\wthankyou.bmp    Name=ThankYou    Mips=off
#exec Texture Import File=Textures\wniceshot.bmp    Name=NiceShot    Mips=off
#exec Texture Import File=Textures\wgoodgame.bmp    Name=GoodGame    Mips=off
#exec Texture Import File=Textures\wniceone.bmp     Name=NiceOne     Mips=off

struct CustEmoji
{
	var string  Symbol;
	var Texture Image1;
	var Texture Image2;
};

var CustEmoji   ChatEmojis[28];
var CustEmoji   WordEmojis[10];

function string GetEmojiSym(int iNum)
{
    return ChatEmojis[iNum].Symbol;
}

function Texture GetEmojiTex(int iNum, bool bTex1)
{
    if (bTex1)
        return ChatEmojis[iNum].Image1;
    else
        return ChatEmojis[iNum].Image2;
}

defaultproperties
{
    ChatEmojis(0)=(Symbol=":)",Image1=Texture'Smile',Image2=Texture'XSmile')
    ChatEmojis(1)=(Symbol=":(",Image1=Texture'Sad',Image2=Texture'XSad')
    ChatEmojis(2)=(Symbol=":^",Image1=Texture'Eyes',Image2=Texture'XEyes')
    ChatEmojis(3)=(Symbol=":+",Image1=Texture'ThumbUp',Image2=Texture'XThumbUp')
    ChatEmojis(4)=(Symbol=":-",Image1=Texture'ThumbDown',Image2=Texture'XThumbDown')
    ChatEmojis(5)=(Symbol=":d",Image1=Texture'Happy',Image2=Texture'XHappy')
    ChatEmojis(6)=(Symbol=":b",Image1=Texture'Bomb',Image2=Texture'XBomb')
    ChatEmojis(7)=(Symbol=":f",Image1=Texture'Fist',Image2=Texture'XFist')
    ChatEmojis(8)=(Symbol=":w",Image1=Texture'Hand',Image2=Texture'XHand')
    ChatEmojis(9)=(Symbol=":1",Image1=Texture'Hundreds',Image2=Texture'XHundreds')
    ChatEmojis(10)=(Symbol=":/",Image1=Texture'Grin',Image2=Texture'XGrin')
    ChatEmojis(11)=(Symbol=":k",Image1=Texture'Okey',Image2=Texture'XOkey')
    ChatEmojis(12)=(Symbol=":u",Image1=Texture'PointUp',Image2=Texture'XPointUp')
    ChatEmojis(13)=(Symbol=":q",Image1=Texture'Question',Image2=Texture'XQuestion')
    ChatEmojis(14)=(Symbol=":r",Image1=Texture'ROFL',Image2=Texture'XROFL')
    ChatEmojis(15)=(Symbol=":c",Image1=Texture'Sunglass',Image2=Texture'XSunglass')
    ChatEmojis(16)=(Symbol=":t",Image1=Texture'Think',Image2=Texture'XThink')
    ChatEmojis(17)=(Symbol=":p",Image1=Texture'Tongue',Image2=Texture'XTongue')
    ChatEmojis(18)=(Symbol=":;",Image1=Texture'Wink',Image2=Texture'XWink')
    ChatEmojis(19)=(Symbol=":s",Image1=Texture'Silly',Image2=Texture'XSilly')
    ChatEmojis(20)=(Symbol=":z",Image1=Texture'Zzz',Image2=Texture'XZzz')
    ChatEmojis(21)=(Symbol=":h",Image1=Texture'Heart',Image2=Texture'XHeart')
    ChatEmojis(22)=(Symbol=":v",Image1=Texture'Peace',Image2=Texture'XPeace')
    ChatEmojis(23)=(Symbol=":#",Image1=Texture'Rockon',Image2=Texture'XRockon')
    ChatEmojis(24)=(Symbol=":m",Image1=Texture'Mask',Image2=Texture'XMask')
    ChatEmojis(25)=(Symbol=":>",Image1=Texture'Squint',Image2=Texture'XSquint')
    ChatEmojis(26)=(Symbol=":o",Image1=Texture'FacePalm',Image2=Texture'XFacePalm')
    ChatEmojis(27)=(Symbol=":y",Image1=Texture'Shrug',Image2=Texture'XShrug')

    WordEmojis(0)=(Symbol="WD!",Image1=Texture'WellDone',Image2=None)
    WordEmojis(1)=(Symbol="TF!",Image1=Texture'WTF',Image2=None)
    WordEmojis(2)=(Symbol="MG!",Image1=Texture'OMG',Image2=None)
    WordEmojis(3)=(Symbol="OL!",Image1=Texture'LOL',Image2=None)
    WordEmojis(4)=(Symbol="TY!",Image1=Texture'ThankYou',Image2=None)
    WordEmojis(5)=(Symbol="NS!",Image1=Texture'NiceShot',Image2=None)
    WordEmojis(6)=(Symbol="GG!",Image1=Texture'GoodGame',Image2=None)
    WordEmojis(7)=(Symbol="N1!",Image1=Texture'NiceOne',Image2=None)
}
