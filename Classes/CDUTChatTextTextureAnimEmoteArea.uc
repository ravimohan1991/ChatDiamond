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
 */

class CDUTChatTextTextureAnimEmoteArea extends UWindowDynamicTextArea;

 // Style for rendering sprites, meshes.
 var(Display) enum ERenderStyle
 {
 	STY_None,
 	STY_Normal,
 	STY_Masked,
 	STY_Translucent,
 	STY_Modulated,
 } Style;

 var int MyPos;
 var bool bChat;
 var bool bShowFaces, bCountryFlags;
 var bool bCol;
 var Color ChatColor, GrnColor, YelColor, BluColor, RedColor, WhiteColor, TxtColor, FaceColor;
 var texture StaticTransparencyTexture;

 struct SkinStore
 {
 	var texture ChatFace;
 	var string FaceName;
 };

 var SkinStore CachedFaces[50];

 // The maximum height inclusive of FaceTexture, text, and emote when displayed in a line
 // Height(FaceTexture) < Height(emote) type assumption (also obvious)
 var float DefaultTextTextureLineHeight;

 // The horizontal padding between two TextTextureLines
 var() config float UniformHorizontalPadding;

 // The vertical padding between Date and Chatface in single TextTextureLine
 var() config float ChatFaceVerticalPadding;

 function Created()
 {
 	Super.Created();

 	// Powers of two, I presume!
 	StaticTransparencyTexture = texture'LadrStatic.Static_a00'; // 256 by 256 pixels
 }

 function FindCategoryDeliminator(string EncodedText, out int Position, out string Deliminator)
 {
 	local int TempoPosition;

 	//Log("Decoding string: " $ EncodedText);

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

 // The Mid(coerce string S, int i, optional int j) function generates a substring of S by starting at character i and
 // copying j characters. If j is omitted, the rest of the string is copied. i
 // is clamped between 0 and the length of the string. j is clamped between i
 // and the length of the string. If S is not a string, its value will attempt
 // to be converted to a string value.

 // Saturday.22.January.2022.<.16:19..somasup:.hey blaze (a dot represents single space padding)

 function float DrawTextTextureLine(Canvas C, UWindowDynamicTextRow L, float Y)
 {
 	local float X, X1, X2, Y1;
 	local string sDate, sName, sMesg, sTm, CategoryDeliminator;
 	local string FaceName, SkinName;
 	local string FaceSkinNoText;
 	local int i, CategoryDeliminatorPosition;
 	local float TextureXOccupied, TextureYOccupied;

 	if(L.Text == "")
 	{
 		return 0;
 	}

 	X = 2;
 	sTm = "-";// The date time delimiter
 	FaceSkinNoText = StripFaceNameAndSkinName(L.Text, FaceName, SkinName);

 	if (bChat)
 	{
 		FindCategoryDeliminator(FaceSkinNoText, CategoryDeliminatorPosition, CategoryDeliminator);

 		sTm = CategoryDeliminator;             // <
 		sDate = Left(FaceSkinNoText, CategoryDeliminatorPosition) $ "-" $ Mid(FaceSkinNoText, CategoryDeliminatorPosition + 1, 8);// Saturday 22.January.2022.-.16:19..
 		sMesg = Mid(FaceSkinNoText, CategoryDeliminatorPosition + 8); // somasup:.hey blaze

 		i = InStr(sMesg, ": ");

 		if (i > 0)
 		{
 			sName = Left(sMesg, i+1); // somasup:.
 			sMesg = Mid(sMesg, i+2);  // hey blaze

 			TextSize(C, sDate, X1, Y1);

 			C.DrawColor = ChatColor;
 			C.SetPos(X, Y);

 			TextAreaClipText(C, X, Y, sDate);

 			X = X1 + 2 + ChatFaceVerticalPadding;

 			DrawChatFace(C, X, Y, LocateChatFaceTexture(FaceName, SkinName), Y1, TextureXOccupied, TextureYOccupied);

 			if (bChat)
 			{
 				if (sTm == "<")
 				{
 					C.DrawColor = RedColor;
 				}
 				else if (sTm == ">")
 				{
 					C.DrawColor = BluColor;
 				}
 				else if (sTm == "=")
 				{
 					C.DrawColor = GrnColor;
 				}
 				else if (sTm == "+")
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

 				TextAreaClipText(C, X, Y, sMesg);
 			}
 			return DefaultTextTextureLineHeight;
 		}

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
 	local int i;

 	if(FaceNameString == "faceless" || FaceNameString == "")
 	{
 	  return texture'faceless';
 	}

 	for(i = 0; i< 50; i++)
 	{
 		if(CachedFaces[i].ChatFace == none)
 		{
 			break;
 		}
 		else if(CachedFaces[i].FaceName == FaceNameString)
 		{
 			return CachedFaces[i].ChatFace;
 		}
 	}

 	SkinItem = Root.GetPlayerOwner().GetItemName(SkinNameString);
 	FaceItem = Root.GetPlayerOwner().GetItemName(FaceNameString);
 	FacePackage = Left(FaceNameString, Len(FaceNameString) - Len(FaceItem));

 	if(FacePackage == "")
 	{
 		FacePackage = TournamentPlayer(Root.GetPlayerOwner()).default.DefaultPackage;
 		FaceNameString = FacePackage $ FaceNameString;
 	}

 	if(IsSandhiNeeded(FaceNameString, NonSandhiFaceNameString))
 	{
 		ChatFaceTexture = Texture(DynamicLoadObject(FacePackage $ SkinItem $ "5" $ FaceItem, class'Texture'));
 	}
 	else
 	{
 		ChatFaceTexture = Texture(DynamicLoadObject(NonSandhiFaceNameString, class'Texture'));
 	}

 	if(ChatFaceTexture == none)
 	{
 		Log("ChatDiamond: Couldn't find ChatFace: " $ FaceNameString);
 		ChatFaceTexture = texture'faceless';
 	}

 	CachedFaces[i].ChatFace = ChatFaceTexture;
 	CachedFaces[i].FaceName = FaceNameString;

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

 	Log("SomeString: " $ SomeString);

 	StringAndDigitJunction =  mid(SomeString, 4, 1);
 	Log("Junction is " $ StringAndDigitJunction);

 	TextureIdentifier = int(StringAndDigitJunction);
 	Log("TextureIdentifier: " $ TextureIdentifier);

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
 * @PARAM YOccupied         Height of total chat face area
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
 	else
 	if(bDirty)
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
 		Count = List.Count();
 		VertSB.SetRange(0, Count, VisibleRows);

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
