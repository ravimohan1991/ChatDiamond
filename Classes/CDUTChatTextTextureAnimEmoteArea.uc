/*
 *   --------------------------------------
 *  |  CDUTChatTextTextureAnimEmoteArea.uc
 *   --------------------------------------
 *   This file is part of ChatDiamond for UT99.
 *
 *   ChatDiamond is free software: you can redistribute and/or modify
 *   it under the terms of the Open Unreal Mod License version 1.1.
 *
 *   ChatDiamond is distributed in the hope and belief that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 *   You should have received a copy of the Open Unreal Mod License
 *   along with ChatDiamond.  If not, see
 *   <https://beyondunrealwiki.github.io/pages/openunrealmodlicense.html>.
 *
 *   Timeline:
 *   Before November, 2022: ProAsm and No0ne developed UTChat
 *                         (https://ut99.org/viewtopic.php?f=7&t=14356)
 *   November, 2022: Transitioning from UTChat to ChatDiamond
 *                 (https://ut99.org/viewtopic.php?f=7&t=14356&start=30#p139510)
 *   December, 2022: Native experiments
 *   April, 2023: Native - scripting hybrid progress
 */

class CDUTChatTextTextureAnimEmoteArea extends UWindowDynamicTextArea;

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

 // Shock Rifle Emote
 #exec Texture Import File=Textures\04_SHOCK01.pcx  Name=ANEShock0    Mips=off
 #exec Texture Import File=Textures\04_SHOCK02.pcx  Name=ANEShock1    Mips=off
 #exec Texture Import File=Textures\04_SHOCK03.pcx  Name=ANEShock2    Mips=off
 #exec Texture Import File=Textures\04_SHOCK04.pcx  Name=ANEShock3    Mips=off
 #exec Texture Import File=Textures\04_SHOCK05.pcx  Name=ANEShock4    Mips=off
 #exec Texture Import File=Textures\04_SHOCK06.pcx  Name=ANEShock5    Mips=off
 #exec Texture Import File=Textures\04_SHOCK07.pcx  Name=ANEShock6    Mips=off
 #exec Texture Import File=Textures\04_SHOCK08.pcx  Name=ANEShock7    Mips=off
 #exec Texture Import File=Textures\04_SHOCK09.pcx  Name=ANEShock8    Mips=off
 #exec Texture Import File=Textures\04_SHOCK010.pcx  Name=ANEShock9    Mips=off

 // Trash-talk Emote
 #exec Texture Import File=Textures\ARGUE01.pcx  Name=ANEArgue0    Mips=off
 #exec Texture Import File=Textures\ARGUE02.pcx  Name=ANEArgue1    Mips=off
 #exec Texture Import File=Textures\ARGUE03.pcx  Name=ANEArgue2    Mips=off
 #exec Texture Import File=Textures\ARGUE04.pcx  Name=ANEArgue3    Mips=off
 #exec Texture Import File=Textures\ARGUE05.pcx  Name=ANEArgue4    Mips=off
 #exec Texture Import File=Textures\ARGUE06.pcx  Name=ANEArgue5    Mips=off
 #exec Texture Import File=Textures\ARGUE07.pcx  Name=ANEArgue6    Mips=off
 #exec Texture Import File=Textures\ARGUE08.pcx  Name=ANEArgue7    Mips=off
 #exec Texture Import File=Textures\ARGUE09.pcx  Name=ANEArgue8    Mips=off
 #exec Texture Import File=Textures\ARGUE10.pcx  Name=ANEArgue9    Mips=off
 #exec Texture Import File=Textures\ARGUE11.pcx  Name=ANEArgue10    Mips=off
 #exec Texture Import File=Textures\ARGUE12.pcx  Name=ANEArgue11    Mips=off
 #exec Texture Import File=Textures\ARGUE13.pcx  Name=ANEArgue12    Mips=off
 #exec Texture Import File=Textures\ARGUE14.pcx  Name=ANEArgue13    Mips=off
 #exec Texture Import File=Textures\ARGUE15.pcx  Name=ANEArgue14    Mips=off
 #exec Texture Import File=Textures\ARGUE16.pcx  Name=ANEArgue15    Mips=off
 #exec Texture Import File=Textures\ARGUE17.pcx  Name=ANEArgue16    Mips=off
 #exec Texture Import File=Textures\ARGUE18.pcx  Name=ANEArgue17    Mips=off
 #exec Texture Import File=Textures\ARGUE19.pcx  Name=ANEArgue18    Mips=off
 #exec Texture Import File=Textures\ARGUE20.pcx  Name=ANEArgue19    Mips=off
 #exec Texture Import File=Textures\ARGUE21.pcx  Name=ANEArgue20    Mips=off

 // Banana Emote
 #exec Texture Import File=Textures\BANANA1.pcx Name=ANEBanana0    Mips=off
 #exec Texture Import File=Textures\BANANA2.pcx Name=ANEBanana1    Mips=off
 #exec Texture Import File=Textures\BANANA3.pcx Name=ANEBanana2    Mips=off
 #exec Texture Import File=Textures\BANANA4.pcx Name=ANEBanana3    Mips=off
 #exec Texture Import File=Textures\BANANA5.pcx Name=ANEBanana4    Mips=off
 #exec Texture Import File=Textures\BANANA6.pcx Name=ANEBanana5    Mips=off
 #exec Texture Import File=Textures\BANANA7.pcx Name=ANEBanana6    Mips=off
 #exec Texture Import File=Textures\BANANA8.pcx Name=ANEBanana7    Mips=off

 // Barf Emote
 #exec Texture Import File=Textures\BARF01.pcx Name=ANEBarf0    Mips=off
 #exec Texture Import File=Textures\BARF02.pcx Name=ANEBarf1    Mips=off
 #exec Texture Import File=Textures\BARF03.pcx Name=ANEBarf2    Mips=off
 #exec Texture Import File=Textures\BARF04.pcx Name=ANEBarf3    Mips=off
 #exec Texture Import File=Textures\BARF05.pcx Name=ANEBarf4    Mips=off
 #exec Texture Import File=Textures\BARF06.pcx Name=ANEBarf5    Mips=off
 #exec Texture Import File=Textures\BARF07.pcx Name=ANEBarf6    Mips=off
 #exec Texture Import File=Textures\BARF08.pcx Name=ANEBarf7    Mips=off
 #exec Texture Import File=Textures\BARF09.pcx Name=ANEBarf8    Mips=off
 #exec Texture Import File=Textures\BARF10.pcx Name=ANEBarf9    Mips=off
 #exec Texture Import File=Textures\BARF11.pcx Name=ANEBarf10    Mips=off
 #exec Texture Import File=Textures\BARF12.pcx Name=ANEBarf11    Mips=off
 #exec Texture Import File=Textures\BARF13.pcx Name=ANEBarf12    Mips=off
 #exec Texture Import File=Textures\BARF14.pcx Name=ANEBarf13    Mips=off
 #exec Texture Import File=Textures\BARF15.pcx Name=ANEBarf14    Mips=off
 #exec Texture Import File=Textures\BARF16.pcx Name=ANEBarf15    Mips=off
 #exec Texture Import File=Textures\BARF17.pcx Name=ANEBarf16    Mips=off
 #exec Texture Import File=Textures\BARF18.pcx Name=ANEBarf17    Mips=off
 #exec Texture Import File=Textures\BARF19.pcx Name=ANEBarf18    Mips=off
 #exec Texture Import File=Textures\BARF20.pcx Name=ANEBarf19    Mips=off
 #exec Texture Import File=Textures\BARF21.pcx Name=ANEBarf20    Mips=off
 #exec Texture Import File=Textures\BARF22.pcx Name=ANEBarf21    Mips=off
 #exec Texture Import File=Textures\BARF23.pcx Name=ANEBarf22    Mips=off
 #exec Texture Import File=Textures\BARF24.pcx Name=ANEBarf23    Mips=off
 #exec Texture Import File=Textures\BARF25.pcx Name=ANEBarf24    Mips=off
 #exec Texture Import File=Textures\BARF26.pcx Name=ANEBarf25    Mips=off
 #exec Texture Import File=Textures\BARF27.pcx Name=ANEBarf26    Mips=off
 #exec Texture Import File=Textures\BARF28.pcx Name=ANEBarf27    Mips=off
 #exec Texture Import File=Textures\BARF29.pcx Name=ANEBarf28    Mips=off

 // Style for rendering sprites, meshes.
 var(Display) enum ERenderStyle
 {
 	STY_None,
 	STY_Normal,
 	STY_Masked,
 	STY_Translucent,
 	STY_Modulated,
 } Style;

 struct CustEmoji
 {
 	var string  Symbol;
 	var Texture Image1;
 	var Texture Image2;
 	var string StatusBarText;
 };

 struct AnEmote
 {
 	var Texture Atlas[35];
 	var float TexChatSizeFraction;

 	var int CurrentAnimFrame;
 	var int TotalElements;
 	var string TextSymbol;
 	var string StatusBarText;
 };

 struct EmoStatus
 {
 	var string TextSymbol;
 	var int Location;
 	var int Identifier;
 };

 var AnEmote AnimShockEmote;
 var AnEmote AnimTrashTalkEmote;
 var AnEmote AnimBananaEmote;
 var AnEmote AnimBarfEmote;

 var CustEmoji   ChatEmojis[28];
 var CustEmoji   WordEmojis[10];

 var CDLoadedTextureList ChatFaces;

 var() config string RecognizableEmoTextSymbols[100];

 var int MyPos;
 var bool bChat;
 var bool bShowFaces, bCountryFlags;
 var bool bCol;
 var Color ChatColor, GrnColor, YelColor, BluColor, RedColor, WhiteColor, TxtColor, FaceColor;
 var texture StaticTransparencyTexture;

 var float FrameRate;
 var float EmoSizeMultiplier;
 var int TickCounter;
 var int TickCounterWarpNumber;
 var int DesiredAnimationFrameRate;
 var float MouseMoveY;

 var CDChatWindowHelperContextMenu HelperContextMenu;
 var CDChatWindowChat CDChatWindow;

 var bool bIsMouseOverChatText;
 var bool bIsStatusSetByChatMessage;

 var string ChatTextCache;
 var string TextUrlCurrent;

 var CDLoadedTextureList TextureList;
 var UWindowHScrollBar HorizontalSB;
 var bool bScrollHorizontal;
 var int VisibleColumns;
 // Calibrator
 var int NumberOfLettersPerLine;

 struct SkinStore
 {
 	var texture ChatFace;
 	var string FaceName;
 };

 // The maximum height inclusive of FaceTexture, text, and emote when displayed in a line
 // Height(FaceTexture) < Height(emote) type assumption (also obvious)
 var float DefaultTextTextureLineHeight;

 // The horizontal padding between two TextTextureLines
 var() config float UniformHorizontalPadding;

 // The vertical padding between Date and Chatface in single TextTextureLine
 var() config float ChatFaceVerticalPadding;

 // Getters
 function string GetEmojiTextSymbol(int EmoCounter)
 {
 	return ChatEmojis[EmoCounter].Symbol;
 }

 function string GetEmoteTextSymbol(int EmoCounter)
 {
 	switch(EmoCounter)
 	{
 		case  28: return  AnimShockEmote.TextSymbol;
 		case  29: return  AnimTrashTalkEmote.TextSymbol;
 		case  30: return  AnimBananaEmote.TextSymbol;
 		case  31: return  AnimBarfEmote.TextSymbol;

 		default: return "";
 	}

 	 return "";
 }

 function string GetEmoteStatusBarText(int EmoCounter)
 {
 	switch(EmoCounter)
 	{
 		case  28: return  AnimShockEmote.StatusBarText;
 		case  29: return  AnimTrashTalkEmote.StatusBarText;
 		case  30: return  AnimBananaEmote.StatusBarText;
 		case  31: return  AnimBarfEmote.StatusBarText;

 		default: return "";
 	}

 	return "";
 }

 function texture GetEmojiTexture(int EmoCounter)
 {
 	return ChatEmojis[EmoCounter].Image1;
 }

 function string GetEmojiStatusBarText(int EmoCounter)
 {
 	return ChatEmojis[EmoCounter].StatusBarText;
 }

 function texture GetEmoteTexture(int EmoCounter)
 {
 	// Continuation from ChatEmojis end
 	switch(EmoCounter)
 	{
 		case  28: return  AnimShockEmote.Atlas[AnimShockEmote.CurrentAnimFrame];
 		case  29: return  AnimTrashTalkEmote.Atlas[AnimTrashTalkEmote.CurrentAnimFrame];
 		case  30: return  AnimBananaEmote.Atlas[AnimBananaEmote.CurrentAnimFrame];
 		case  31: return  AnimBarfEmote.Atlas[AnimBarfEmote.CurrentAnimFrame];

 		default: return texture'faceless';
 	}

 	return texture'faceless';
 }

 function HideHorizontalSB()
 {
 	// This may need more looking into
 	HorizontalSB.Close();
 }

 function Created()
 {
 	Super.Created();

 	// Powers of two, I presume!
 	StaticTransparencyTexture = texture'LadrStatic.Static_a00'; // 256 by 256 pixels

 	FrameRate = 60;
 	TickCounter = 0;

 	DesiredAnimationFrameRate = 24;
 	TickCounterWarpNumber = (int(FrameRate) / 24);

 	bIsStatusSetByChatMessage = false;
 	TextUrlCurrent = "";

 	HelperContextMenu = CDChatWindowHelperContextMenu(Root.CreateWindow(class'CDChatWindowHelperContextMenu', 0, 0, 100, 100, Self));
 	HelperContextMenu.HideWindow();

 	HorizontalSB = UWindowHScrollbar(CreateWindow(class'UWindowHScrollbar', 0, WinHeight - 12, WinWidth, 12));
	HorizontalSB.bAlwaysOnTop = True;

 	AnimShockEmote.CurrentAnimFrame = 0;
 	AnimShockEmote.TextSymbol = ":4";
 	AnimShockEmote.Atlas[0] = texture'ANEShock0';
 	AnimShockEmote.Atlas[1] = texture'ANEShock1';
 	AnimShockEmote.Atlas[2] = texture'ANEShock2';
 	AnimShockEmote.Atlas[3] = texture'ANEShock3';
 	AnimShockEmote.Atlas[4] = texture'ANEShock4';
 	AnimShockEmote.Atlas[5] = texture'ANEShock5';
 	AnimShockEmote.Atlas[6] = texture'ANEShock6';
 	AnimShockEmote.Atlas[7] = texture'ANEShock7';
 	AnimShockEmote.Atlas[8] = texture'ANEShock8';
 	AnimShockEmote.Atlas[9] = texture'ANEShock9';
 	AnimShockEmote.TexChatSizeFraction = 0.5;
 	AnimShockEmote.StatusBarText = "Shock Combo!";

 	AnimTrashTalkEmote.CurrentAnimFrame = 0;
 	AnimTrashTalkEmote.TextSymbol = ":3";
 	AnimTrashTalkEmote.Atlas[0] = texture'ANEArgue0';
 	AnimTrashTalkEmote.Atlas[1] = texture'ANEArgue1';
 	AnimTrashTalkEmote.Atlas[2] = texture'ANEArgue2';
 	AnimTrashTalkEmote.Atlas[3] = texture'ANEArgue3';
 	AnimTrashTalkEmote.Atlas[4] = texture'ANEArgue4';
 	AnimTrashTalkEmote.Atlas[5] = texture'ANEArgue5';
 	AnimTrashTalkEmote.Atlas[6] = texture'ANEArgue6';
 	AnimTrashTalkEmote.Atlas[7] = texture'ANEArgue7';
 	AnimTrashTalkEmote.Atlas[8] = texture'ANEArgue8';
 	AnimTrashTalkEmote.Atlas[9] = texture'ANEArgue9';
 	AnimTrashTalkEmote.Atlas[10] = texture'ANEArgue10';
 	AnimTrashTalkEmote.Atlas[11] = texture'ANEArgue11';
 	AnimTrashTalkEmote.Atlas[12] = texture'ANEArgue12';
 	AnimTrashTalkEmote.Atlas[13] = texture'ANEArgue13';
 	AnimTrashTalkEmote.Atlas[14] = texture'ANEArgue14';
 	AnimTrashTalkEmote.Atlas[15] = texture'ANEArgue15';
 	AnimTrashTalkEmote.Atlas[16] = texture'ANEArgue16';
 	AnimTrashTalkEmote.Atlas[17] = texture'ANEArgue17';
 	AnimTrashTalkEmote.Atlas[18] = texture'ANEArgue18';
 	AnimTrashTalkEmote.Atlas[19] = texture'ANEArgue19';
 	AnimTrashTalkEmote.Atlas[20] = texture'ANEArgue20';
 	AnimTrashTalkEmote.TexChatSizeFraction = 0.60;
 	AnimTrashTalkEmote.StatusBarText = "Trashy Talk!";

 	AnimBananaEmote.CurrentAnimFrame = 0;
 	AnimBananaEmote.TextSymbol = "/b";
 	AnimBananaEmote.Atlas[0] = texture'ANEBanana0';
 	AnimBananaEmote.Atlas[1] = texture'ANEBanana1';
 	AnimBananaEmote.Atlas[2] = texture'ANEBanana2';
 	AnimBananaEmote.Atlas[3] = texture'ANEBanana3';
 	AnimBananaEmote.Atlas[4] = texture'ANEBanana4';
 	AnimBananaEmote.Atlas[5] = texture'ANEBanana5';
 	AnimBananaEmote.Atlas[6] = texture'ANEBanana6';
 	AnimBananaEmote.Atlas[7] = texture'ANEBanana7';
 	AnimBananaEmote.TexChatSizeFraction = 0.80;
 	AnimBananaEmote.StatusBarText = "Animated Banana!";

 	AnimBarfEmote.CurrentAnimFrame = 0;
 	AnimBarfEmote.TextSymbol = "/p";
 	AnimBarfEmote.Atlas[0] = texture'ANEBarf0';
 	AnimBarfEmote.Atlas[1] = texture'ANEBarf1';
 	AnimBarfEmote.Atlas[2] = texture'ANEBarf2';
 	AnimBarfEmote.Atlas[3] = texture'ANEBarf3';
 	AnimBarfEmote.Atlas[4] = texture'ANEBarf4';
 	AnimBarfEmote.Atlas[5] = texture'ANEBarf5';
 	AnimBarfEmote.Atlas[6] = texture'ANEBarf6';
 	AnimBarfEmote.Atlas[7] = texture'ANEBarf7';
 	AnimBarfEmote.Atlas[8] = texture'ANEBarf8';
 	AnimBarfEmote.Atlas[9] = texture'ANEBarf9';
 	AnimBarfEmote.Atlas[10] = texture'ANEBarf10';
 	AnimBarfEmote.Atlas[11] = texture'ANEBarf11';
 	AnimBarfEmote.Atlas[12] = texture'ANEBarf12';
 	AnimBarfEmote.Atlas[13] = texture'ANEBarf13';
 	AnimBarfEmote.Atlas[14] = texture'ANEBarf14';
 	AnimBarfEmote.Atlas[15] = texture'ANEBarf15';
 	AnimBarfEmote.Atlas[16] = texture'ANEBarf16';
 	AnimBarfEmote.Atlas[17] = texture'ANEBarf17';
 	AnimBarfEmote.Atlas[18] = texture'ANEBarf18';
 	AnimBarfEmote.Atlas[19] = texture'ANEBarf19';
 	AnimBarfEmote.Atlas[20] = texture'ANEBarf20';
 	AnimBarfEmote.Atlas[21] = texture'ANEBarf21';
 	AnimBarfEmote.Atlas[22] = texture'ANEBarf22';
 	AnimBarfEmote.Atlas[23] = texture'ANEBarf23';
 	AnimBarfEmote.Atlas[24] = texture'ANEBarf24';
 	AnimBarfEmote.Atlas[25] = texture'ANEBarf25';
 	AnimBarfEmote.Atlas[26] = texture'ANEBarf26';
 	AnimBarfEmote.Atlas[27] = texture'ANEBarf27';
 	AnimBarfEmote.Atlas[28] = texture'ANEBarf28';
 	AnimBarfEmote.TexChatSizeFraction = 0.80;
 	AnimBarfEmote.StatusBarText = "Barf!";

 	RecognizableEmoTextSymbols[0] = ":)";
 	RecognizableEmoTextSymbols[1] = ":(";
 	RecognizableEmoTextSymbols[2] = ":^";
 	RecognizableEmoTextSymbols[3] = ":+";
 	RecognizableEmoTextSymbols[4] = ":_";
 	RecognizableEmoTextSymbols[5] = ":d";
 	RecognizableEmoTextSymbols[6] = ":b";
 	RecognizableEmoTextSymbols[7] = ":f";
 	RecognizableEmoTextSymbols[8] = ":w";
 	RecognizableEmoTextSymbols[9] = ":1";
 	RecognizableEmoTextSymbols[10] = ":/";
 	RecognizableEmoTextSymbols[11] = ":k";
 	RecognizableEmoTextSymbols[12] = ":u";
 	RecognizableEmoTextSymbols[13] = ":q";
 	RecognizableEmoTextSymbols[14] = ":r";
 	RecognizableEmoTextSymbols[15] = ":c";
 	RecognizableEmoTextSymbols[16] = ":t";
 	RecognizableEmoTextSymbols[17] = ":p";
 	RecognizableEmoTextSymbols[18] = ":;";
 	RecognizableEmoTextSymbols[19] = ":s";
 	RecognizableEmoTextSymbols[20] = ":z";
 	RecognizableEmoTextSymbols[21] = ":h";
 	RecognizableEmoTextSymbols[22] = ":v";
 	RecognizableEmoTextSymbols[23] = ":#";
 	RecognizableEmoTextSymbols[24] = ":m";
 	RecognizableEmoTextSymbols[25] = ":>";
 	RecognizableEmoTextSymbols[26] = ":o";
 	RecognizableEmoTextSymbols[27] = ":y";
 	RecognizableEmoTextSymbols[28] = ":4";
 	RecognizableEmoTextSymbols[29] = ":3";
 	RecognizableEmoTextSymbols[30] = "/b";
 	RecognizableEmoTextSymbols[31] = "/p";

 	ClearChatFaces();
 }

 function ClearChatFaces()
 {
 	if(ChatFaces != None)
 	{
 		if(ChatFaces.Next == None)
 		{
 			return;
 		}

		ChatFaces.DestroyList();
	}

	ChatFaces = new class'CDLoadedTextureList';
	ChatFaces.SetupSentinel();
 }

 function FindCategoryDeliminator(string EncodedText, out int Position, out string Deliminator)
 {
 	local int TempoPosition;

 	TempoPosition = Instr(EncodedText, "-");

 	if(TempoPosition != -1)
 	{
 		Deliminator = "-";
 		Position = TempoPosition;
 		return;
 	}

 	TempoPosition = Instr(EncodedText, "<");

 	if(TempoPosition != -1)
 	{
 		Deliminator = "<";
 		Position = TempoPosition;
 		return;
 	}

 	TempoPosition = Instr(EncodedText, ">");

 	if(TempoPosition != -1)
 	{
 		Deliminator = ">";
 		Position = TempoPosition;
 		return;
 	}

 	TempoPosition = Instr(EncodedText, "+");

 	if(TempoPosition != -1)
 	{
 		Deliminator = "+";
 		Position = TempoPosition;
 		return;
 	}

 	Log("ChatDiamond: Text - " $ EncodedText $ " has no identifiable category deliminator");
 }

 function float DrawTextTextureLine(Canvas C, UWindowDynamicTextRow L, float Y)
 {
 	local float X, X1, X2, Y1, XIncrementor;
 	local string sDate, sName, sMesg, sTm;
 	local string FaceName, SkinName;
 	local string FaceSkinNoText;
 	local float TextureXOccupied, TextureYOccupied;
 	local string TempServerString, SJTimeString, SJAddressString, SJNameString;

 	if(L.Text == "")
 	{
 		return 0;
 	}

 	class'CDDiscordActor'.static.DeSerializeJson(L.Text);

 	SJNameString = class'CDDiscordActor'.static.FetchValue("ServerName");

 	if(SJNameString != "")
 	{
 		C.Font = Root.Fonts[F_Normal];

 		SJTimeString = class'CDDiscordActor'.static.FetchValue("LocalTime");
 		SJAddressString = class'CDDiscordActor'.static.FetchValue("ServerAddress");

 		TempServerString = SJTimeString $": joined " @
 			SJAddressString @ SJNameString;

 		// Estimate the total string size
 		TextSize(C, TempServerString, X1, Y1);

 		// Start with middle alignment
 		C.DrawColor = class'CDChatWindowEmojis'.default.WhiteColor;
 		XIncrementor = X + WinWidth / 2 - X1 / 2;
 		// Paint the time text
 		TextAreaClipText(C, XIncrementor, Y, SJTimeString);

 		// Proceed with 'joined' phrase
 		C.DrawColor = class'CDChatWindowEmojis'.default.GrayColor;
 		// Estimate the offset for 'joined'
 		TextSize(C, SJTimeString, X1, Y1);
 		XIncrementor += X1;
 		TextAreaClipText(C, XIncrementor, Y, ": joined ");

 		// Proceed with address string
 		C.DrawColor = class'CDChatWindowEmojis'.default.SageGreenColor;
 		// Estimate the offset for server address
 		TextSize(C, ": joined ", X1, Y1);
 		XIncrementor += X1;
 		TextAreaClipText(C, XIncrementor, Y, SJAddressString);

 		// Proceed with the name string
 		C.DrawColor = class'CDChatWindowEmojis'.default.OrangeColor;
 		// Estimate the offset for server name
 		TextSize(C, SJAddressString, X1, Y1);
 		XIncrementor += X1;
 		TextAreaClipText(C, XIncrementor, Y, SJNameString);

 		return DefaultTextTextureLineHeight;
 	}

 	X = 2;

 	FaceName = class'CDDiscordActor'.static.FetchValue("FaceName");
 	SkinName = class'CDDiscordActor'.static.FetchValue("SkinName");

 	if (bChat)
 	{
 		sTm = class'CDDiscordActor'.static.FetchValue("Team");
 		sDate = class'CDDiscordActor'.static.FetchValue("LocalTime");
 		sMesg = class'CDDiscordActor'.static.FetchValue("ChatMessage");
 		sName = class'CDDiscordActor'.static.FetchValue("PlayerName");

 		C.Font = Root.Fonts[F_Normal];

 		TextSize(C, sDate, X1, Y1);

 		C.DrawColor = ChatColor;
 		C.SetPos(X, Y);

 		TextAreaClipText(C, X, Y, sDate);

 		X = X1 + 2 + ChatFaceVerticalPadding;

 		DrawChatFace(C, X, Y, LocateChatFaceTexture(FaceName, SkinName), Y1, TextureXOccupied, TextureYOccupied);

 		if (bChat)
 		{
 			if (sTm == "Red")
 			{
 				C.DrawColor = RedColor;
 			}
 			else if (sTm == "Blue")
 			{
 				C.DrawColor = BluColor;
 			}
 			else if (sTm == "Green")
 			{
 				C.DrawColor = GrnColor;
 			}
 			else if (sTm == "Yellow")
 			{
 				C.DrawColor = YelColor;
 			}
 			else
 			{
 				C.DrawColor = WhiteColor;
 			}

 			X = X1 + 2 + ChatFaceVerticalPadding + TextureXOccupied + 2;
 			C.SetPos(X, Y);

 			TextAreaClipText(C, X, Y, sName);

 			C.DrawColor = TxtColor;
 			TextSize(C, sName $ "  ", X2, Y1);
 			X = X1 + 2 + ChatFaceVerticalPadding + TextureXOccupied + 2 + X2;

 			MessagePass(C, X, Y, sMesg);
 		}

 		return DefaultTextTextureLineHeight;


 		if (Mid(FaceSkinNoText, 2, 1) != "/")
 		{
 			TextSize(C, "07/28 - 12:34   ", X1, X2);
 			X = X1;
 		}

 		C.DrawColor = TxtColor;
 		TextAreaClipText(C, X, Y, FaceSkinNoText);
 	}
 	else
 	{
 		TextAreaClipText(C, X, Y, Mid(FaceSkinNoText, MyPos/4));
 	}

 	return DefaultTextTextureLineHeight;
 }

/********************************************************************************
 * A message pass between DrawTextTextureLine and DrawChatMessageWithEmoji
 * for performing operations like copying of relevant text or right translation!!
 *
 * @PARAM C       The canvas being painted upon
 * @PARAM X       The begining of text message absissa
 * @PARAM Y       Ordinate above which(?) text is written
 * @PARAM Message The actual human readable (hopefully!) message (after decoding)
 *
 ********************************************************************************
 */

 function MessagePass(Canvas C, float DrawX, float DrawY, coerce string Message)
 {
 	local string URLStringExtract;

 	if(MouseMoveY >= DrawY - (DefaultTextTextureLineHeight- UniformHorizontalPadding) && MouseMoveY < DrawY + UniformHorizontalPadding)
 	{
 		ChatTextCache = Message;
 		bIsMouseOverChatText = true;

 		URLStringExtract = ParseAndMakeURL(Message);

 		if(URLStringExtract != "")
 		{
 			CDChatWindow.SetChatTextStatus(URLStringExtract);
 			TextUrlCurrent = URLStringExtract;

 			CDChatWindow.SetCursor(Root.HandCursor);
 			Log("Setting the cursor to Handcursor");
 		}
 		else
 		{
 			CDChatWindow.SetCursor(Root.NormalCursor);
 		}
 	}

 	DrawChatMessageWithEmoji(C, DrawX, DrawY, Message);
 }

 // Try to use the function for DrawChatMessageWithEmoji stuff
 // assuming only either ip or http(s) itself is in the Message
 function string ParseAndMakeURL(string Message, optional out string BareString)
 {
 	local string DecoratedURLString;
 	local int ICategory, HttpPosition;

 	DecoratedURLString = class'CDDiscordActor'.static.SpitIpFromChatString(Message, ICategory);
 	BareString = DecoratedURLString;

 	if(ICategory == 0)
 	{
 		DecoratedURLString = "unreal://" $ DecoratedURLString;
 		return DecoratedURLString;
 	}
 	else if(ICategory == 1)
 	{
 		DecoratedURLString = "http://" $ DecoratedURLString;
 		return DecoratedURLString;
 	}
 	else if(ICategory == 2)// No ip of either kind is present in the message
 	{
 		DecoratedURLString = "";
 	}

 	// Now look for http(s):// stuff
 	HttpPosition = instr(Message, "http://");

 	if(HttpPosition == -1)
 	{
 		HttpPosition = instr(Message, "https://");
 	}

 	// Smuggle? www. with http
 	if(HttpPosition == -1)
 	{
 		HttpPosition = instr(Message, "www.");
 	}

 	if(HttpPosition != -1)
 	{
 		DecoratedURLString = mid(Message, HttpPosition);

 		HttpPosition = Instr(DecoratedURLString, " ");
 		if(HttpPosition != -1)
 		{
 			DecoratedURLString = left(DecoratedURLString, HttpPosition);
 		}
 	}
 	BareString = DecoratedURLString;
 	return DecoratedURLString;
 }


 function DrawChatMessageWithEmoji(Canvas C, float DrawX, float DrawY, coerce string Message, optional out float LateralDisplacement, optional bool bCheckHotkey)
 {
 	local string TempoString;
 	local int EmojiLocation, Identifier, EmojiYDrawCoordinate, EmoteYDrawCoordinate, URLYDrawCoordinate;
 	local float SomeHeight, TextWidth;
 	local float EmojiMultiplier;
 	local string URLString, BareURLSTring;

 	EmojiMultiplier = 0.05 * EmoSizeMultiplier;

 	// Could be loation of URL too
 	EmojiLocation = LookForEmojiTextRepresentation(Message, Identifier, URLString, BareURLString);

 	while(EmojiLocation != -1)
 	{
 		TempoString = Left(Message, EmojiLocation);
 		TextAreaClipText(C, DrawX, DrawY, TempoString);

 		if(TempoString != "")
 		{
 			TextSize(C, TempoString, TextWidth, SomeHeight);
 		}
 		else
 		{
 			TextSize(C, "Pika", TextWidth, SomeHeight);
 			TextWidth = 0;
 		}

 		LateralDisplacement += TextWidth;
 		DrawX += TextWidth;

 		C.DrawColor = WhiteColor;
 		C.Style = ERenderStyle.STY_Translucent;

 		if(Identifier < 28)
 		{
 			EmojiYDrawCoordinate =  DrawY - ChatEmojis[Identifier].Image1.VSize * EmojiMultiplier + SomeHeight;

 			DrawStretchedTexture(C, DrawX, EmojiYDrawCoordinate, ChatEmojis[Identifier].Image1.USize * EmojiMultiplier,
 				ChatEmojis[Identifier].Image1.VSize * EmojiMultiplier, ChatEmojis[Identifier].Image1);

 			LateralDisplacement +=  ChatEmojis[Identifier].Image1.USize * EmojiMultiplier;
 			DrawX += ChatEmojis[Identifier].Image1.USize * EmojiMultiplier;

 			Message = Mid(Message, EmojiLocation + 2);
 		}

 		else if(Identifier == 51)
 		{
 			EmoteYDrawCoordinate =  DrawY - AnimShockEmote.Atlas[AnimShockEmote.CurrentAnimFrame].VSize * AnimShockEmote.TexChatSizeFraction / 2 + SomeHeight / 2;

 			DrawStretchedTexture(C, DrawX, EmoteYDrawCoordinate, AnimShockEmote.Atlas[AnimShockEmote.CurrentAnimFrame].USize * AnimShockEmote.TexChatSizeFraction,
 			AnimShockEmote.Atlas[AnimShockEmote.CurrentAnimFrame].USize * AnimShockEmote.TexChatSizeFraction, AnimShockEmote.Atlas[AnimShockEmote.CurrentAnimFrame]);

 			LateralDisplacement +=  AnimShockEmote.Atlas[0].USize * AnimShockEmote.TexChatSizeFraction;
 			DrawX += AnimShockEmote.Atlas[0].USize * AnimShockEmote.TexChatSizeFraction;

 			Message = Mid(Message, EmojiLocation + 2);
 		}

 		else if(Identifier == 52)
 		{
 			EmoteYDrawCoordinate =  DrawY - AnimTrashTalkEmote.Atlas[AnimTrashTalkEmote.CurrentAnimFrame].VSize * AnimTrashTalkEmote.TexChatSizeFraction / 2 + SomeHeight / 2;

 			DrawStretchedTexture(C, DrawX, EmoteYDrawCoordinate, AnimTrashTalkEmote.Atlas[AnimTrashTalkEmote.CurrentAnimFrame].USize * AnimTrashTalkEmote.TexChatSizeFraction,
 			AnimTrashTalkEmote.Atlas[AnimTrashTalkEmote.CurrentAnimFrame].USize * AnimTrashTalkEmote.TexChatSizeFraction, AnimTrashTalkEmote.Atlas[AnimTrashTalkEmote.CurrentAnimFrame]);

 			LateralDisplacement +=  AnimTrashTalkEmote.Atlas[0].USize * AnimTrashTalkEmote.TexChatSizeFraction;
 			DrawX += AnimTrashTalkEmote.Atlas[0].USize * AnimTrashTalkEmote.TexChatSizeFraction;

 			Message = Mid(Message, EmojiLocation + 2);
 		}

 		else if(Identifier == 53)
 		{
 			EmoteYDrawCoordinate =  DrawY - AnimBananaEmote.Atlas[AnimBananaEmote.CurrentAnimFrame].VSize * AnimBananaEmote.TexChatSizeFraction / 2 + SomeHeight / 2;

 			DrawStretchedTexture(C, DrawX, EmoteYDrawCoordinate, AnimBananaEmote.Atlas[AnimBananaEmote.CurrentAnimFrame].USize * AnimBananaEmote.TexChatSizeFraction,
 			AnimBananaEmote.Atlas[AnimBananaEmote.CurrentAnimFrame].USize * AnimBananaEmote.TexChatSizeFraction, AnimBananaEmote.Atlas[AnimBananaEmote.CurrentAnimFrame]);

 			LateralDisplacement +=  AnimBananaEmote.Atlas[0].USize * AnimBananaEmote.TexChatSizeFraction;
 			DrawX += AnimBananaEmote.Atlas[0].USize * AnimBananaEmote.TexChatSizeFraction;

 			Message = Mid(Message, EmojiLocation + 2);
 		}

 		else if(Identifier == 54)
 		{
 			EmoteYDrawCoordinate =  DrawY - AnimBarfEmote.Atlas[AnimTrashTalkEmote.CurrentAnimFrame].VSize * AnimBarfEmote.TexChatSizeFraction / 2 + SomeHeight / 2;

 			DrawStretchedTexture(C, DrawX, EmoteYDrawCoordinate, AnimBarfEmote.Atlas[AnimTrashTalkEmote.CurrentAnimFrame].USize * AnimBarfEmote.TexChatSizeFraction,
 			AnimBarfEmote.Atlas[AnimBarfEmote.CurrentAnimFrame].USize * AnimBarfEmote.TexChatSizeFraction, AnimBarfEmote.Atlas[AnimBarfEmote.CurrentAnimFrame]);

 			LateralDisplacement +=  AnimBarfEmote.Atlas[0].USize * AnimBarfEmote.TexChatSizeFraction;
 			DrawX += AnimBarfEmote.Atlas[0].USize * AnimBarfEmote.TexChatSizeFraction;

 			Message = Mid(Message, EmojiLocation + 2);
 		}

 		else if(Identifier == 101)
 		{
 			TextSize(C, URLString, TextWidth, SomeHeight);

 			URLYDrawCoordinate = DrawY + SomeHeight + 1;

 			DrawStretchedTexture(C, DrawX, URLYDrawCoordinate, TextWidth, 1, Texture 'UWindow.WhiteTexture');

 			URLYDrawCoordinate = DrawY;

 			C.DrawColor = BluColor;
 			TextAreaClipText(C, DrawX, URLYDrawCoordinate, URLString);
 			DrawX += TextWidth;
 			C.DrawColor = WhiteColor;

 			Message = Mid(Message, EmojiLocation + len(BareURLString));
 		}

 		EmojiLocation = LookForEmojiTextRepresentation(Message, Identifier, URLString, BareURLString);
 	}

 	TextAreaClipText(C, DrawX, DrawY, Message);
 	TextSize(C, Message, TextWidth, SomeHeight);

 	LateralDisplacement += TextWidth;
 }

 function Tick(float DeltaTime)
 {
 	if(TickCounter > TickCounterWarpNumber)
 	{
 		AnimShockEmote.CurrentAnimFrame++;
 		AnimTrashTalkEmote.CurrentAnimFrame++;
 		AnimBananaEmote.CurrentAnimFrame++;
 		AnimBarfEmote.CurrentAnimFrame++;

 		if(AnimShockEmote.CurrentAnimFrame > 9)
 		{
 			AnimShockEmote.CurrentAnimFrame = 0;
 		}

 		if(AnimTrashTalkEmote.CurrentAnimFrame > 20)
 		{
 			AnimTrashTalkEmote.CurrentAnimFrame = 0;
 		}

 		if(AnimBananaEmote.CurrentAnimFrame > 7)
 		{
 			AnimBananaEmote.CurrentAnimFrame = 0;
 		}

 		if(AnimBarfEmote.CurrentAnimFrame > 28)
 		{
 			AnimBarfEmote.CurrentAnimFrame = 0;
 		}

 		TickCounter = 0;
 	}

 	TickCounter++;

 	if(!bIsMouseOverChatText)
 	{
 		ChatTextCache = "";
 		HelperContextMenu.TextToCopyFromChatCache = "";
 		HelperContextMenu.CopyChatMessage.bDisabled = true;
 		HelperContextMenu.CopyIP.bDisabled = true;

 		if(bIsStatusSetByChatMessage)
 		{
 			CDChatWindow.SetChatTextStatus("");
 			bIsStatusSetByChatMessage = false;

 			CDChatWindow.SetCursor(Root.NormalCursor);
 		}
 	}

 	bIsMouseOverChatText = false;

 	super.Tick(DeltaTime);
 }

// May contain ip stuff (pun intended!)
// Focus on order!!

 function int LookForEmojiTextRepresentation(string MessageStringPart, out int IdentifyingIndex, optional out string URLString, optional out string BareURLSTring)
 {
 	local int EmoLocation, Counter;
 	local EmoStatus EmoArray[100];
 	local int EmoCount, SmallestRegister;
 	local bool bNoEmoTextSymbol;
 	local int URLLocation;
 	//local string BareURLString;
 	//local int ICategory;

 	EmoCount = 0;
 	bNoEmoTextSymbol = true;

 	//URLString = class'CDDiscordActor'.static.SpitIpFromChatString(MessageStringPart, ICategory);

 	// The decorated URL string
 	URLString = ParseAndMakeURL(MessageStringPart, BareURLString);

 	if(BareURLString != "" && URLString != "")
 	{
 		URLLocation = Instr(MessageStringPart, BareURLString);
 	}

 	for(Counter = 0; Counter <= 31; Counter++)
 	{
 		EmoLocation = Instr(MessageStringPart, RecognizableEmoTextSymbols[Counter]);

 		if(EmoLocation != -1)
 		{
 			EmoArray[EmoCount].TextSymbol = RecognizableEmoTextSymbols[Counter];
 			EmoArray[EmoCount].Location = EmoLocation;

 			switch(Counter)
 			{
 				case  28: EmoArray[EmoCount].Identifier = 51; break;
 				case  29: EmoArray[EmoCount].Identifier = 52; break;
 				case  30: EmoArray[EmoCount].Identifier = 53; break;
 				case  31: EmoArray[EmoCount].Identifier = 54; break;

 				default: EmoArray[EmoCount].Identifier = Counter; break;
 			}

 			EmoCount++;
 			bNoEmoTextSymbol = false;
 		}
 	}

 	if(bNoEmoTextSymbol && URLString == "")
 	{
 		return -1;
 	}

 	SmallestRegister = 100;

 	for(Counter = 0; Counter < 100; Counter++)
 	{
 		if(EmoArray[Counter].TextSymbol == "")
 		{
 			break;
 		}

 		if(EmoArray[Counter].Location <= SmallestRegister)
 		{
 			SmallestRegister = EmoArray[Counter].Location;
 			EmoCount = Counter;
 		}
 	}

 	// Ok the assumption must be maintained
 	// Reading from left to right there can be 2 scenrios
 	// 1. Either URLString is present
 	//    If present check the ordering with respect to emoji
 	//         If emoji is present and before URLSTring, return with emoji information
 	//         Else return URL information
 	// 2. URLSTring not present
 	//    Heh, return emoji if present and should never be even here if even emoji is not present
 	if(URLString == "")
 	{
 		IdentifyingIndex = EmoArray[EmoCount].Identifier;
 		return EmoArray[EmoCount].Location;
 	}
 	else
 	{
 		if(EmoArray[EmoCount].Location < URLLocation && !bNoEmoTextSymbol)
 		{
 			IdentifyingIndex = EmoArray[EmoCount].Identifier;
 			return EmoArray[EmoCount].Location;
 		}
 		else
 		{
 			IdentifyingIndex = 101;
 			return URLLocation;
 		}
 	}
 }

 function string StripFaceNameAndSkinName(string EncodedString, out string FaceName, out string SkinName)
 {
 	local int i, j;
 	local string FaceAndSkinNames;

 	i = Instr(EncodedString, "::");

 	if(i != -1)
 	{
 		FaceAndSkinNames = left(EncodedString, i);

 		j = Instr(FaceAndSkinNames, ":");

 		SkinName = mid(FaceAndSkinNames, j + 1);
 		FaceName = left(FaceAndSkinNames, j);

 		return mid(EncodedString, i + 2);
 	}
 	else
 	{
 		return EncodedString;
 	}
 }

/*********************************************************************************************
 * Bit tricky way to locate the Texture of chatting player. Please see
 * https://github.com/ravimohan1991/ChatDiamond/wiki/Level-of-Detail-in-Server-Client-Context
 *
 * TODO: Need an algorithm to cache the textures (being rendered each tick) Done
 *
 * We also try and cache the dynamically loaded textures because common sense is common again?
 * @PARAM FaceNameString             The complete string name for face identification
 *                                   (Server) SoldierSkins.Brock
 *                                   (Client) SoldierSkins.Sldr4Brock
 * @PARAM SkinNameString             The complete string name for skin identification
 *                                   (Server) SoldierSkins.sldr
 *                                   (Client) SoldierSkins.sldr3
 *
 *********************************************************************************************
 */

 function texture LocateChatFaceTexture(optional string FaceNameString, optional string SkinNameString)
 {
 	local texture ChatFaceTexture;
 	local string FacePackage, SkinItem, FaceItem, NonSandhiFaceNameString;
 	local CDLoadedTextureList LoadedTexture, LTextureIterator;

 	if(FaceNameString == "faceless" || FaceNameString == "")
 	{
 		return texture'faceless';
 	}

 	for(LTextureIterator = ChatFaces; LTextureIterator.Next != none; LTextureIterator = CDLoadedTextureList(LTextureIterator.Next))
 	{
 		if(LTextureIterator.FaceNameString == FaceNameString && LTextureIterator.SkinNameString == SkinNameString)
 		{
 			return LTextureIterator.LTexture;
 		}
 	}

 	if(Root.GetPlayerOwner() == none)
 	{
 		return texture'faceless';
 	}

 	SkinItem = Root.GetPlayerOwner().GetItemName(SkinNameString);
 	FaceItem = Root.GetPlayerOwner().GetItemName(FaceNameString);
 	FacePackage = Left(FaceNameString, Len(FaceNameString) - Len(FaceItem));

 	if(SkinItem == "None" || FaceItem == "Dummy" || SkinItem == "Dummy" || FaceItem == "None")
 	{
 		return texture'faceless';
 	}

 	if(FacePackage == "")
 	{
 		FacePackage = TournamentPlayer(Root.GetPlayerOwner()).default.DefaultPackage;
 		FaceNameString = FacePackage $ FaceNameString;
 	}

 	if(IsSandhiNeeded(FaceNameString, NonSandhiFaceNameString))
 	{
 		ChatFaceTexture = Texture(DynamicLoadObject(FacePackage $ SkinItem $ "5" $ FaceItem, class'Texture'));
 		Log("[ChatDiamond] Dynamically loading new chat face texture");
 	}
 	else
 	{
 		// First we see case by case, then we may find a general pattern to deal with these exceptions
 		// See the dump file for pplarehell's metadata for boss's credentials
 		// 1. pplarehell boss
 		// 2. surrei SoldierSkins.Blkt5
 		if(SkinItem == "boss1T_0" || SkinItem == "boss1T_1")
 		{
 			ChatFaceTexture = Texture(DynamicLoadObject("BossSkins.Boss5Xan", class'Texture'));
 			Log("[ChatDiamond] Dynamically loading new chat face texture");
 		}
 		else if(SkinItem == "Blkt3")
 		{
 			ChatFaceTexture = Texture(DynamicLoadObject("SoldierSkins.Blkt5Othello", class'Texture'));
 			Log("[ChatDiamond] Dynamically loading new chat face texture");
 		}
 		else
 		{
 	 		ChatFaceTexture = Texture(DynamicLoadObject(NonSandhiFaceNameString, class'Texture'));
 	 		Log("[ChatDiamond] Dynamically loading new chat face texture");
 		}
 	}

 	if(ChatFaceTexture == none)
 	{
 		Log(FacePackage @ SkinItem @ FaceItem @ FaceNameString);
 		return texture'faceless';
 	}

 	LoadedTexture = CDLoadedTextureList(ChatFaces.Append(class'CDLoadedTextureList'));
 	LoadedTexture.LTexture = ChatFaceTexture;
 	LoadedTexture.FaceNameString = FaceNameString;
 	LoadedTexture.SkinNameString = SkinNameString;

 	return ChatFaceTexture;
 }

/*******************************************************************************
 * Decide whether to use the string concatenation (serverside type) or not (heh)
 * @PARAM FaceNameString        The complete string name for face identification
 *                              (Server) SoldierSkins.Brock
 *                              (Client) SoldierSkins.Sldr4Brock
 * @PARAM NotSandhiString       The right string spit if servertype string is
 *                              not provided
 * @RETURN                      True if string concatenation is required, where
 *                              queried. False if not. Then the NotSandhiString
 *                              is used.
 *
 *******************************************************************************
 */

 function bool IsSandhiNeeded(string FaceNameString, optional out string NotSandhiString)
 {
 	local int DotLocation;
 	local string OnlyFaceString;// After the dot
 	local bool bResult;
 	local string PackageName, TFName;// TheFaceName

 	DotLocation = instr(FaceNameString, ".");
 	PackageName = left(FaceNameString, DotLocation);

 	if(DotLocation != -1)
 	{
 		OnlyFaceString = mid(FaceNameString, DotLocation + 1);
 		bResult = DoesStringRequireChatFaceDigitReplacement(OnlyFaceString, TFName);
 		NotSandhiString = PackageName $ "." $ TFName;
 		return bResult;
 	}

 	// Honestly IDK as of now
 	return true;
 }

/*******************************************************************************
 * It seems, as per UT99 convention, in the sub-string after dot, 5th element is
 * the indicator what type (server or client) of texture is provided. So we make
 * arrangements accrodingly.
 * @PARAM SomeString                 The later part of FaceNameString for right
 *                                   identification of the server-client type
 * @PARAM TrueFaceNameString         If client-type identified then appropriate
 *                                   replacement to make server-type string
 * @RETURN                           True if replacement is needed, false if not
 *
 *******************************************************************************
 */

 function bool DoesStringRequireChatFaceDigitReplacement(string SomeString, optional out string TrueFaceNameString)
 {
 	local int TextureIdentifier;
 	local int Counter;
 	local string StringAndDigitJunction;

 	StringAndDigitJunction =  mid(SomeString, 4, 1);
 	TextureIdentifier = int(StringAndDigitJunction);

 	TrueFaceNameString = left(SomeString, 4) $ "5" $ mid(SomeString, 5);

 	for(Counter = 1; Counter < 10; Counter++)
 	{
 		if(TextureIdentifier == Counter && TextureIdentifier != 5)
 		{
 			return false;
 		}
 	}

 	return true;
 }

/*******************************************************************************
 * Routine with twofold purpose
 * 1. Prepare an appropriate area for display of chat face (with static and all
 *    that)
 * 2. Gauge and report the height and width dimensions of the face
 *
 * @PARAM Canvas            The drawing Canvas (literally)
 * @PARAM X                 The leftmost pixel of chat face
 * @PARAM Y                 The topmost pixel of chat face
 * @PARAM FaceTexture       The literal chat face image
 * @PARAM TextHeight        Relevant adjustments to be done while placing chat
 *                          face with respect to text
 * @PARAM XOccupied         Width of total chat face area
 * @PARAM YOccupied         Height of total c hat face area
 * @PARAM bTopText          If the text is to be place at top with respect to
 *                          chat face. Not so by default
 *
 *******************************************************************************
 */

 function DrawChatFace(Canvas Canvas, int X, int Y, Texture FaceTexture, int TextHeight, optional out float XOccupied, optional out float YOccupied,
                      optional bool bTopText)
 {
 	local float ChatFaceMultiplier;
 	local float StaticMultiplier;

 	ChatFaceMultiplier = 0.5;
 	StaticMultiplier = 0.125;

 	XOccupied = (FaceTexture.USize * ChatFaceMultiplier + StaticTransparencyTexture.USize * StaticMultiplier) / 2;
 	YOccupied = (FaceTexture.VSize * ChatFaceMultiplier + StaticTransparencyTexture.VSize * StaticMultiplier) / 2;

 	if(!bTopText)
 	{
 		Y = Y - YOccupied + TextHeight;
 	}

 	Canvas.DrawColor = WhiteColor;
 	Canvas.Style = ERenderStyle.STY_Normal;

 	DrawStretchedTexture(Canvas, X, Y, FaceTexture.USize * ChatFaceMultiplier, FaceTexture.VSize * ChatFaceMultiplier, FaceTexture);

 	Canvas.Style = ERenderStyle.STY_Translucent;
 	Canvas.DrawColor = FaceColor;

 	DrawStretchedTexture(Canvas, X, Y, StaticTransparencyTexture.USize * StaticMultiplier,
 		StaticTransparencyTexture.VSize * StaticMultiplier, StaticTransparencyTexture);

 	Canvas.DrawColor = WhiteColor;
 }

 function Paint2(Canvas C, float MouseX, float MouseY)
 {
 	local UWindowDynamicTextRow L;
 	local int SkipCount, DrawCount;
 	local float TempoTextHeight, TempoTextureHeight;
 	local int i;
 	local float Y, Junk;
 	local bool bWrapped;

 	C.DrawColor = TextColor;
 	TextUrlCurrent = "";

 	if(AbsoluteFont != None)
 		C.Font = AbsoluteFont;
 	else
 		C.Font = Root.Fonts[Font];

 	if(OldW != WinWidth || OldH != WinHeight)
 	{
 		WordWrap(C, True);
 		OldW = WinWidth;
 		OldH = WinHeight;
 		bWrapped = True;
 	}
 	else if(bDirty)
 	{
 		WordWrap(C, False);
 		bWrapped = True;
 	}

 	if(bWrapped)
 	{
 		// Obtain the ChatFace texture height
 		DrawChatFace(C, 0 , 0, LocateChatFaceTexture(), 0, , TempoTextureHeight);

 		// Obtain the text (maybe emote) height
 		TextAreaTextSize(C, "A", Junk, TempoTextHeight);

 		DefaultTextTextureLineHeight = max(TempoTextHeight, TempoTextureHeight);

 		// Some horizontal padding (gap?)
 		DefaultTextTextureLineHeight += UniformHorizontalPadding;

 		VisibleRows = WinHeight / DefaultTextTextureLineHeight;
 		VisibleColumns = WinWidth / (NumberOfLettersPerLine * Junk);

 		Count = List.Count();
 		VertSB.SetRange(0, Count, VisibleRows);

 		if(HorizontalSB != none)
 		{
 			HorizontalSB.SetRange(0, WinWidth, HorizontalSB.WinWidth);
 		}

 		if(bScrollOnResize)
 		{
 			if(bTopCentric)
 			{
 				VertSB.Pos = 0;
 			}
 			else
 			{
 				VertSB.Pos = VertSB.MaxPos;
 			}
 		}

 		if(bAutoScrollbar && !bVariableRowHeight)
 		{
 			if(Count <= VisibleRows)
 			{
 				VertSB.HideWindow();
 			}
 			else
 			{
 				VertSB.ShowWindow();
 			}
 		}
 	}

 	if(bTopCentric)
 	{
 		SkipCount = VertSB.Pos;
 		L = UWindowDynamicTextRow(List.Next);

 		for(i=0; i < SkipCount && (L != None) ; i++)
 		{
 			L = UWindowDynamicTextRow(L.Next);
 		}

 		if(bVCenter && Count <= VisibleRows)
 		{
 			Y = int((WinHeight - (Count * DefaultTextTextureLineHeight)) / 2);
 		}
 		else
 		{
 			Y = 1;
 		}

 		DrawCount = 0;

 		while(Y < WinHeight)
 		{
 			DrawCount++;
 			if(L != None)
 			{
 				Y += DrawTextTextureLine(C, L, Y);
 				L = UWindowDynamicTextRow(L.Next);
 			}
 			else
 			{
 				Y += DefaultTextTextureLineHeight;
 			}
 		}

 		if(bVariableRowHeight)
 		{
 			VisibleRows = DrawCount - 1;

 			while(VertSB.Pos + VisibleRows > Count)
 			{
 				VisibleRows--;
 			}

 			VertSB.SetRange(0, Count, VisibleRows);

 			if(bAutoScrollbar)
 			{
 				if(Count <= VisibleRows)
 				{
 					VertSB.HideWindow();
 				}
 				else
 				{
 					VertSB.ShowWindow();
 				}
 			}
 		}
 	}
 	else
 	{
 		SkipCount = Max(0, Count - (VisibleRows + VertSB.Pos));
 		L = UWindowDynamicTextRow(List.Last);

 		for(i=0; i < SkipCount && (L != List) ; i++)
 		{
 			L = UWindowDynamicTextRow(L.Prev);
 		}

 		Y = WinHeight - DefaultTextTextureLineHeight;

 		while(L != List && L != None && Y > -DefaultTextTextureLineHeight)
 		{
 			DrawTextTextureLine(C, L, Y);
 			Y = Y - DefaultTextTextureLineHeight;

 			L = UWindowDynamicTextRow(L.Prev);
 		}
 	}
 }

 function MouseMove(float X, float Y)
 {
 	Super.MouseMove(X, Y);

 	MouseMoveY = Y;
 }

function RClick(float X, float Y)
{
	//Log("Context click registered!");
}

function LMouseDown(float X, float Y)
{
 super.LMouseDown(X, Y);
}

function Click(float X, float Y)
 {

 	Super.Click(X, Y);

 	if (Len(TextUrlCurrent) == 0)
 	{
 		return;
 	}

 	if (Left(TextUrlCurrent, 7) ~= "http://")
 	{
 		GetPlayerOwner().ConsoleCommand("start " $ TextUrlCurrent);
 	}
 	else if (Left(TextUrlCurrent, 4) ~= "ftp.")
 	{
 		GetPlayerOwner().ConsoleCommand("start ftp://" $ TextUrlCurrent);
 	}
 	else if (Left(TextUrlCurrent, 9) ~= "unreal://")
 	{
 		GetPlayerOwner().ClientTravel(TextUrlCurrent, TRAVEL_Absolute, false);
 	}
 	else
 	{
 		GetPlayerOwner().ConsoleCommand("start" @ TextUrlCurrent);
 	}
 }

 function RMouseUp(float X, float Y)
 {
 	local float MenuX, MenuY;
 	local int IPCategory;

 	super.RMouseUp(X, Y);

 	if(HelperContextMenu != None)
 	{
 		WindowToGlobal(X, Y, MenuX, MenuY);
 		HelperContextMenu.WinLeft = MenuX;
 		HelperContextMenu.WinTop = MenuY;
 		HelperContextMenu.ShowWindow();

 		if(ChatTextCache != "")
 		{
 			HelperContextMenu.CopyChatMessage.bDisabled = false;
 			HelperContextMenu.TextToCopyFromChatCache = ChatTextCache;

 			if(class'CDDiscordActor'.static.SpitIpFromChatString(ChatTextCache, IPCategory) != "")
 			{
 				HelperContextMenu.CopyIP.bDisabled = false;
 			}
 		}
 	}
 }

 defaultproperties
 {
 	bScrollOnResize=True
 	bNoKeyboard=True
 	ChatColor=(R=25,G=225,B=225)
 	RedColor=(R=255)
 	BluColor=(G=84,B=255)
 	GrnColor=(G=255)
 	YelColor=(R=160,G=160)
 	WhiteColor=(R=250,G=250,B=250)
 	TxtColor=(R=160,G=160,B=160)
 	FaceColor=(R=50,G=50,B=50,A=0)
 	UniformHorizontalPadding=10
 	ChatFaceVerticalPadding=9
 	NumberOfLettersPerLine=35

 	ChatEmojis(0)=(Symbol=":)",Image1=Texture'Smile',Image2=Texture'XSmile',StatusBarText="Smiley!")
 	ChatEmojis(1)=(Symbol=":(",Image1=Texture'Sad',Image2=Texture'XSad',StatusBarText="Sad!")
 	ChatEmojis(2)=(Symbol=":^",Image1=Texture'Eyes',Image2=Texture'XEyes',StatusBarText="Eyes!")
 	ChatEmojis(3)=(Symbol=":+",Image1=Texture'ThumbUp',Image2=Texture'XThumbUp',StatusBarText="ThumbUp!")
 	ChatEmojis(4)=(Symbol=":_",Image1=Texture'ThumbDown',Image2=Texture'XThumbDown',StatusBarText="ThumbDown!")
 	ChatEmojis(5)=(Symbol=":d",Image1=Texture'Happy',Image2=Texture'XHappy',StatusBarText="Happy!")
 	ChatEmojis(6)=(Symbol=":b",Image1=Texture'Bomb',Image2=Texture'XBomb',StatusBarText="Bomb!")
 	ChatEmojis(7)=(Symbol=":f",Image1=Texture'Fist',Image2=Texture'XFist',StatusBarText="Riot Fist!")
 	ChatEmojis(8)=(Symbol=":w",Image1=Texture'Hand',Image2=Texture'XHand',StatusBarText="Hand!")
 	ChatEmojis(9)=(Symbol=":1",Image1=Texture'Hundreds',Image2=Texture'XHundreds',StatusBarText="Hundred!")
 	ChatEmojis(10)=(Symbol=":/",Image1=Texture'Grin',Image2=Texture'XGrin',StatusBarText="Esoteric Grin!")
 	ChatEmojis(11)=(Symbol=":k",Image1=Texture'Okey',Image2=Texture'XOkey',StatusBarText="Okey!")
 	ChatEmojis(12)=(Symbol=":u",Image1=Texture'PointUp',Image2=Texture'XPointUp',StatusBarText="PointUp!")
 	ChatEmojis(13)=(Symbol=":q",Image1=Texture'Question',Image2=Texture'XQuestion',StatusBarText="Question!")
 	ChatEmojis(14)=(Symbol=":r",Image1=Texture'ROFL',Image2=Texture'XROFL',StatusBarText="ROFL!")
 	ChatEmojis(15)=(Symbol=":c",Image1=Texture'Sunglass',Image2=Texture'XSunglass',StatusBarText="Sunglass!")
 	ChatEmojis(16)=(Symbol=":t",Image1=Texture'Think',Image2=Texture'XThink',StatusBarText="Think!")
 	ChatEmojis(17)=(Symbol=":p",Image1=Texture'Tongue',Image2=Texture'XTongue',StatusBarText="Tongue!")
 	ChatEmojis(18)=(Symbol=":;",Image1=Texture'Wink',Image2=Texture'XWink',StatusBarText="Wink!")
 	ChatEmojis(19)=(Symbol=":s",Image1=Texture'Silly',Image2=Texture'XSilly',StatusBarText="Silly!")
 	ChatEmojis(20)=(Symbol=":z",Image1=Texture'Zzz',Image2=Texture'XZzz',StatusBarText="Zzzz!")
 	ChatEmojis(21)=(Symbol=":h",Image1=Texture'Heart',Image2=Texture'XHeart',StatusBarText="Heart!")
 	ChatEmojis(22)=(Symbol=":v",Image1=Texture'Peace',Image2=Texture'XPeace',StatusBarText="Peace!")
 	ChatEmojis(23)=(Symbol=":#",Image1=Texture'Rockon',Image2=Texture'XRockon',StatusBarText="Hook'em!")
 	ChatEmojis(24)=(Symbol=":m",Image1=Texture'Mask',Image2=Texture'XMask',StatusBarText="Mask!")
 	ChatEmojis(25)=(Symbol=":>",Image1=Texture'Squint',Image2=Texture'XSquint',StatusBarText="Squint!")
 	ChatEmojis(26)=(Symbol=":o",Image1=Texture'FacePalm',Image2=Texture'XFacePalm',StatusBarText="FacePalm!")
 	ChatEmojis(27)=(Symbol=":y",Image1=Texture'Shrug',Image2=Texture'XShrug',StatusBarText="Shrug!")

 	WordEmojis(0)=(Symbol="WD!",Image1=Texture'WellDone',Image2=None)
 	WordEmojis(1)=(Symbol="TF!",Image1=Texture'WTF',Image2=None)
 	WordEmojis(2)=(Symbol="MG!",Image1=Texture'OMG',Image2=None)
 	WordEmojis(3)=(Symbol="OL!",Image1=Texture'LOL',Image2=None)
 	WordEmojis(4)=(Symbol="TY!",Image1=Texture'ThankYou',Image2=None)
 	WordEmojis(5)=(Symbol="NS!",Image1=Texture'NiceShot',Image2=None)
 	WordEmojis(6)=(Symbol="GG!",Image1=Texture'GoodGame',Image2=None)
 	WordEmojis(7)=(Symbol="N1!",Image1=Texture'NiceOne',Image2=None)
 }

 /*
 *
 *		                                  /\
 *		                                 / /
 *		                              /\| |
 *		                              | | |/\
 *		                              | | / /
 *		                              | `  /
 *		                              `\  (___
 *		                             _.->  ,-.-.
 *		                          _.'      |  \ \
 *		                         /    _____| 0 |0\
 *		                        |    /`    `^-.\.-'`-._
 *		                        |   |                  `-._
 *		                        |   :                      `.
 *		                        \    `._     `-.__         O.'
 *		 _.--,                   \     `._     __.^--._O_..-'
 *		`---, `.                  `\     /` ` `
 *		     `\ `,                  `\   |
 *		      |   :                   ;  |
 *		      /    `.              ___|__|___
 *		     /       `.           (          )
 *		    /    `---.:____...---' `--------`.
 *		   /        (         `.      __      `.
 *		  |          `---------' _   /  \       \
 *		  |    .-.      _._     (_)  `--'        \
 *		  |   (   )    /   \                       \
 *		   \   `-'     \   /                       ;-._
 *		    \           `-'           \           .'   `.
 *		    /`.                  `\    `\     _.-'`-.    `.___
 *		   |   `-._                `\    `\.-'       `-.   ,--`
 *		    \      `--.___        ___`\    \           ||^\\
 *		     `._        | ``----''     `.   `\         `'  `
 *		        `--;     \  jgs          `.   `.
 *		           //^||^\\               //^||^\\
 *		           '  `'  `               '   '  `
 */
