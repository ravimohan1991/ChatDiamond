/*
 *   -----------------------------
 *  |  CDUWindowCreditsControl.uc
 *   -----------------------------
 *   This file is part of CDUwindowCreditsControl for UT99.
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

// ============================================================================
// This file is taken "as in" or "sic" from some web resource
// Since the author is only concerned with noncommercial part, even laymen can
// see how this is pretty fit for our purpose!
//
// The above said is right in the sense if you want to use this mutator for
// commercial purpose you will have to strip this functionality.
//
// UWindowCreditsControl
// Copyright 2002 by Mychaeel <mychaeel@planetjailbreak.com>
// Free for noncommercial use and modification.
//
// Displays scrolling credits, both text and textures.
// ============================================================================

/*
All AddSomething methods return whether the line or padding was successfully added or not.
The latter can happen if the Lines array isn't large enough; simply change its size in its
declaration.

bool AddLineText(string Text, optional byte Font, optional Color Color, optional bool Underline)
    Adds a line of text to the credits, optionally specifying font, color and underlining.
    If no color is given, the value of ColorDefault is used (at rendering time, so changes of
    ColorDefault after AddLineText are effective).

bool AddLineUrl(string Url, optional byte Font, optional string Text)
    Adds a line of text that is displayed as an underlined clickable link, using the color
    specified in the ColorLink property. The optional Text argument is displayed as the link's
    title if specified; otherwise the given URL is displayed itself. URLs starting with www.,
    ftp. and unreal:// are specifically supported, everything else is directly piped through to
    the start console command.

bool AddLineImage(Texture Image, optional int Width, optional int Height)
    Adds a texture image to the credits in a separate line. Optionally, the size of the displayed
    texture can be specified; otherwise its natural size is used.

bool AddPadding(int Padding)
    Adds a padding of the given amount of pixels between the last added line and the next one.

Clear()
    Clears the credit lines.

Reset()
    Restarts the animation from before the fade-in.

[edit] Properties

You can set the following properties:

ColorDefault, ColorImage, ColorLink
    Colors for default text, images (if set to anything else than the default, colorizes the
    textures that are drawn) and link text.

DelayFade, SpeedFade
    Delay before the text is faded in, and the speed of the fade-in (number of seconds it takes
    to complete). If SpeedFade is set to 0.0 (zero), the fade-in sequence is skipped.

DelayScroll, SpeedScroll
    Delay after the fade-in and before the scrolling starts, and the scroll speed (in pixels per
    second).
       */

class CDUWindowCreditsControl extends UWindowDialogControl;

#exec Texture Import File=Textures\diamondbright1.bmp     Name=diamond1      Mips=off
#exec Texture Import File=Textures\diamondbright2.bmp     Name=diamond2      Mips=off
#exec Texture Import File=Textures\diamondbright3.bmp     Name=diamond3      Mips=off
#exec Texture Import File=Textures\diamondbright4.bmp     Name=diamond4      Mips=off
#exec Texture Import File=Textures\diamondbright5.bmp     Name=diamond5      Mips=off
#exec Texture Import File=Textures\diamondbright6.bmp     Name=diamond6      Mips=off
#exec Texture Import File=Textures\diamondbright7.bmp     Name=diamond7      Mips=off
#exec Texture Import File=Textures\diamondbright8.bmp     Name=diamond8      Mips=off
#exec Texture Import File=Textures\diamondbright9.bmp     Name=diamond9      Mips=off
#exec Texture Import File=Textures\diamondbright10.bmp    Name=diamond10     Mips=off

// ============================================================================
// Structures
// ============================================================================

 struct TLine
 {
 	var string Text;
 	var string Url;
 	var byte Font;
 	var Color LineColor;
 	var bool Underline;

 	var Texture Image;
 	var int Width;
 	var int Height;

 	var int Indent;
 	var int Padding;
 };

 struct ShiningDiamond
 {
 	var Texture Atlas[10];

 	var int CurrentAnimFrame;
 };


// ============================================================================
// Enumerations
// ============================================================================

 enum EAction
 {
 	Action_None,
 	Action_Fading,
 	Action_Scrolling,
 };


// ============================================================================
// Properties
// ============================================================================

 var() Color ColorDefault;
 var() Color ColorImage;
 var() Color ColorLink;

 var() int OffsetStart;
 var() float DelayFade;
 var() float DelayScroll;
 var() float SpeedFade;
 var() float SpeedScroll;
 var() TLine Lines[64];


// ============================================================================
// Variables
// ============================================================================

 var EAction Action;
 var EAction ActionPrev;

 var bool FlagDrag;
 var bool FlagUpdated;

 var float Delay;
 var float Fade;
 var float Offset;
 var float OffsetDrag;
 var float FrameRate;

 var int CountLines;
 var int HeightTotal;
 var int TickCounter;
 var int TickCounterWarpNumber;
 var int DesiredAnimationFrameRate;

 var string TextUrlCurrent;
 var ShiningDiamond AnimDiamond;


// ============================================================================
// AddLineText
//
// Adds a line of text.
// ============================================================================

 function bool AddLineText(string Text, optional byte Font,
                                       optional Color TextColor,
                                       optional bool Underline)
 {

 	if (CountLines == ArrayCount(Lines) || Len(Text) == 0)
 	{
 		return false;
 	}

 	Lines[CountLines].Text      = Text;
 	Lines[CountLines].Url       = "";
 	Lines[CountLines].Font      = Font;
 	Lines[CountLines].LineColor = TextColor;
 	Lines[CountLines].Underline = Underline;
 	Lines[CountLines].Padding   = 0;

 	Lines[CountLines].Image = None;

 	CountLines++;
 	FlagUpdated = false;

 	return true;
 }


// ============================================================================
// AddLineUrl
//
// Adds a clickable Internet address.
// ============================================================================

 function bool AddLineUrl(string Url, optional byte Font,
                                     optional string Text)
 {

 	if (CountLines == ArrayCount(Lines) || Len(Url) == 0)
 	{
 		return false;
 	}

 	Lines[CountLines].Url       = Url;
 	Lines[CountLines].Font      = Font;
 	Lines[CountLines].LineColor = ColorLink;
 	Lines[CountLines].Underline = true;
 	Lines[CountLines].Padding   = 2;

 	if (Len(Text) == 0)
 	{
 		Lines[CountLines].Text = Url;
 	}
 	else
 	{
 		Lines[CountLines].Text = Text;
 	}

 	Lines[CountLines].Image = None;

 	CountLines++;
 	FlagUpdated = false;

 	return true;
 }


// ============================================================================
// AddLineImage
//
// Adds an image.
// ============================================================================

 function bool AddLineImage(Texture Image, optional int Width,
                                          optional int Height)
 {

 	if (CountLines == ArrayCount(Lines) || Image == None)
 	{
 		return false;
 	}

 	Lines[CountLines].Image   = Image;
 	Lines[CountLines].Width   = Width;
 	Lines[CountLines].Height  = Height;
 	Lines[CountLines].Padding = 0;

 	Lines[CountLines].Text = "";

 	CountLines++;
 	FlagUpdated = false;

 	return true;
 }


// ============================================================================
// AddPadding
//
// Adds padding to the last line.
// ============================================================================

 function bool AddPadding(int Padding)
 {

 	if (CountLines == 0)
 	{
 		return false;
 	}

 	Lines[CountLines - 1].Padding += Padding;
 }


// ============================================================================
// Clear
//
// Clears the credit lines.
// ============================================================================

 function Clear()
 {
 	Lines[0].Text = "";
 	Lines[0].Image = None;

 	FlagUpdated = false;
 }


// ============================================================================
// Reset
//
// Resets the scrolling area to its original position, the first line being
// just below the bottom of the arena.
// ============================================================================

 function Reset()
 {
 	if(HeightTotal + 20 <= WinHeight)
 	{
 		Offset = -(WinHeight - HeightTotal) / 2;
 	}
 	else
 	{
 		Offset = -10;
 	}

 	if (SpeedFade == 0.0)
 	{
 		Action = Action_Scrolling;
 	}
 	else
 	{
 		Action = Action_Fading;
 	}

 	ActionPrev = Action_None;
 }


// ============================================================================
// Update
//
// Calculates the total height of the credits list, retrieves element sizes and
// determines element indents.
// ============================================================================

 function Update(Canvas Canvas)
 {
 	local int IndexLine;
 	local float WidthText;
 	local float HeightText;

 	if (FlagUpdated)
 	{
 		return;
 	}

 	CountLines = 0;
 	HeightTotal = 0;

 	for (IndexLine = 0; IndexLine < ArrayCount(Lines); IndexLine++)
 	{
 		if (Len(Lines[IndexLine].Text) > 0)
 		{
 			Canvas.Font = Root.Fonts[Lines[IndexLine].Font];
 			TextSize(Canvas, Lines[IndexLine].Text, WidthText, HeightText);

 			Lines[IndexLine].Width = WidthText;
 			Lines[IndexLine].Height = HeightText;
 		}

 		else if (Lines[IndexLine].Image != None)
 		{
 			if (Lines[IndexLine].Width  == 0)
 			{
 				Lines[IndexLine].Width  = Lines[IndexLine].Image.UClamp;
 			}
 			if (Lines[IndexLine].Height == 0)
 			{
 				Lines[IndexLine].Height = Lines[IndexLine].Image.VClamp;
 			}
 		}

 		else
 		{
 			break;
 		}

 		Lines[IndexLine].Indent = (WinWidth - Lines[IndexLine].Width) / 2;

 		CountLines++;
 		HeightTotal += Lines[IndexLine].Height + Lines[IndexLine].Padding;
 	}

 	Reset();

 	FlagUpdated = true;
 }


// ============================================================================
// WindowShown
// ============================================================================

 function WindowShown()
 {

 	Reset();

 	Super.WindowShown();
 }

// ============================================================================
// Initiate
// ============================================================================

 function Initiate()
 {
 	FrameRate = 60;
 	DesiredAnimationFrameRate = 24;

 	TickCounterWarpNumber = (int(FrameRate) / 24);

 	AnimDiamond.Atlas[0] = texture'diamond1';
 	AnimDiamond.Atlas[1] = texture'diamond2';
 	AnimDiamond.Atlas[2] = texture'diamond3';
 	AnimDiamond.Atlas[3] = texture'diamond4';
 	AnimDiamond.Atlas[4] = texture'diamond5';
 	AnimDiamond.Atlas[5] = texture'diamond6';
 	AnimDiamond.Atlas[6] = texture'diamond7';
 	AnimDiamond.Atlas[7] = texture'diamond8';
 	AnimDiamond.Atlas[8] = texture'diamond9';
 	AnimDiamond.Atlas[9] = texture'diamond10';
 }

// ============================================================================
// Tick
// ============================================================================

 event Tick(float TimeDelta)
 {
 	if(TickCounter > TickCounterWarpNumber)
 	{
 		AnimDiamond.CurrentAnimFrame++;

 		if(AnimDiamond.CurrentAnimFrame > 9)
 		{
 			AnimDiamond.CurrentAnimFrame = 0;
 		}

 		TickCounter = 0;
 	}

 	TickCounter++;

 	if (Action != ActionPrev)
 	{
 		switch (Action)
 		{
 			case Action_Fading:
 				Fade = 0.0;
 				Delay = DelayFade;
 			break;
 			case Action_Scrolling:
 				Fade = 1.0;
 				Delay = DelayScroll;
 			break;
 		}

 		ActionPrev = Action;
 	}

 	if (Delay > 0.0)
 	{
 		Delay = FMax(0.0, Delay - TimeDelta);
 		return;
 	}

 	switch (Action)
 	{
 		case Action_Fading:
 			Fade = FMin(1.0, Fade + SpeedFade * TimeDelta);
 			if (Fade == 1.0)
 			{
 				Action = Action_Scrolling;
 			}
 		break;

 		case Action_Scrolling:
 		if (!bMouseDown)
 		{
 			if(HeightTotal + 20 <= WinHeight)
 			{
 				Offset = -(WinHeight - HeightTotal) / 2;
 			}
 			else
 			{
 				Offset += SpeedScroll * TimeDelta;
 			}
 		}
 		break;
 	}
 }


// ============================================================================
// Click
// ============================================================================

 function Click(float X, float Y)
 {

 	Super.Click(X, Y);

 	if (Len(TextUrlCurrent) == 0)
 	{
 		return;
 	}

 	if (Left(TextUrlCurrent, 4) ~= "www.")
 	{
 		GetPlayerOwner().ConsoleCommand("start http://" $ TextUrlCurrent);
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


// ============================================================================
// BeforePaint
// ============================================================================

 function BeforePaint(Canvas Canvas, float X, float Y)
 {

 	Update(Canvas);

 	Super.BeforePaint(Canvas, X, Y);
 }

// ============================================================================
// Resize
// ============================================================================

 function Resize()
 {
 	local int IndexLine;

 	for(IndexLine = 0; IndexLine < ArrayCount(Lines); IndexLine++)
 	{
 		Lines[IndexLine].Indent = (WinWidth - Lines[IndexLine].Width) / 2;
 	}
 }


// ============================================================================
// Paint
// ============================================================================

 function Paint(Canvas Canvas, float X, float Y)
 {

 	local int IndexLine;
 	local int OffsetCurrent;

 	if (bMouseDown)
 	{
 		if (FlagDrag)
 		{
 			Offset = OffsetDrag - Y;
 		}
 		else
 		{
 			OffsetDrag = Offset + Y;
 		}
 	}

 	FlagDrag = bMouseDown;

 	DrawStretchedTexture(Canvas, 0, 0, WinWidth, WinHeight, Texture 'UWindow.BlackTexture');

 	OffsetCurrent = -Offset;

 	for (IndexLine = 0; IndexLine < CountLines; IndexLine++)
 	{
 		if (OffsetCurrent + Lines[IndexLine].Height > 0)
 		{
 			break;
 		}
 		OffsetCurrent += Lines[IndexLine].Height + Lines[IndexLine].Padding;
 	}

 	TextUrlCurrent = "";
 	Canvas.bNoSmooth = false;

 	for (IndexLine = IndexLine; IndexLine < CountLines; IndexLine++)
 	{
 		if (OffsetCurrent > WinHeight)
 		{
 			break;
 		}

 		if (Len(Lines[IndexLine].Text) > 0)
 		{
 			if (Lines[IndexLine].LineColor.R == 0 &&
 					Lines[IndexLine].LineColor.G == 0 &&
 					Lines[IndexLine].LineColor.B == 0)
			{
 			    Canvas.DrawColor = ColorDefault;
 			}
 		    else
 		    {
 			    Canvas.DrawColor = Lines[IndexLine].LineColor;
 		    }
 		}

 		Canvas.DrawColor = Canvas.DrawColor * Fade;
 		Canvas.Font = Root.Fonts[Lines[IndexLine].Font];

 		// Top line
 		if(Lines[IndexLine].Text == "Chat Diamond")
 		{
 			ClipText(Canvas, Lines[IndexLine].Indent, OffsetCurrent, Lines[IndexLine].Text);
 			DrawStretchedTexture(Canvas, Lines[IndexLine].Indent - AnimDiamond.Atlas[AnimDiamond.CurrentAnimFrame].USize - 2,
 					OffsetCurrent,
 					AnimDiamond.Atlas[AnimDiamond.CurrentAnimFrame].USize,
 					AnimDiamond.Atlas[AnimDiamond.CurrentAnimFrame].VSize, AnimDiamond.Atlas[AnimDiamond.CurrentAnimFrame]);
 			DrawStretchedTexture(Canvas, Lines[IndexLine].Indent + Lines[IndexLine].Width + 2,
 					OffsetCurrent,
 					AnimDiamond.Atlas[AnimDiamond.CurrentAnimFrame].USize,
 					AnimDiamond.Atlas[AnimDiamond.CurrentAnimFrame].VSize, AnimDiamond.Atlas[AnimDiamond.CurrentAnimFrame]);
 		}
 		else
 		{
 			ClipText(Canvas, Lines[IndexLine].Indent, OffsetCurrent, Lines[IndexLine].Text);
 		}

 		if (Lines[IndexLine].Underline)
 		{
 			DrawStretchedTexture(Canvas, Lines[IndexLine].Indent,
 					Lines[IndexLine].Height + OffsetCurrent - 1,
 					Lines[IndexLine].Width,
 					1,
 					Texture 'UWindow.WhiteTexture');
 		}

 		if (Len(Lines[IndexLine].Url) > 0 &&
 			Clamp(X, Lines[IndexLine].Indent, Lines[IndexLine].Indent + Lines[IndexLine].Width) == int(X) &&
 			Clamp(Y, OffsetCurrent, OffsetCurrent + Lines[IndexLine].Height) == int(Y))
 			{
 				TextUrlCurrent = Lines[IndexLine].Url;
 			}

 		else if (Lines[IndexLine].Image != None)
 		{
 			Canvas.DrawColor = ColorImage * Fade;
 			DrawStretchedTexture(Canvas, Lines[IndexLine].Indent,
 					OffsetCurrent,
 					Lines[IndexLine].Width,
 					Lines[IndexLine].Height, Lines[IndexLine].Image);
 		}

 		OffsetCurrent += Lines[IndexLine].Height + Lines[IndexLine].Padding;
 	}

 	if (Len(TextUrlCurrent) == 0)
 	{
 		Cursor = Root.NormalCursor;
 	}
 	else
 	{
 		Cursor = Root.HandCursor;
 	}

 	if (OffsetCurrent + Lines[IndexLine - 1].Height <= 0)
 	{
 		Reset();
 	}
 }


// ============================================================================
// Color Operators
// ============================================================================

 static final operator(16) Color * (float Fade, Color Color)
 {

 	Color.R = byte(FClamp(Fade, 0.0, 1.0) * float(Color.R));
 	Color.G = byte(FClamp(Fade, 0.0, 1.0) * float(Color.G));
 	Color.B = byte(FClamp(Fade, 0.0, 1.0) * float(Color.B));

 	return Color;
 }

 static final operator(16) Color * (Color Color, float Fade)
 {
 	return Fade * Color;
 }


// ============================================================================
// Default Properties
// ============================================================================

 defaultproperties
 {
 	ColorDefault=(R=224,G=224,B=224)
 	ColorImage=(R=255,G=255,B=255)
 	ColorLink=(R=64,G=64,B=255)

 	DelayFade=0.2
 	DelayScroll=0

 	SpeedFade=1.0
 	SpeedScroll=32.0
 }
