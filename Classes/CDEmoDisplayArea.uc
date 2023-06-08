/*
 *   ----------------------
 *  |  CDEmoDisplayArea.uc
 *   ----------------------
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

//==============================================================================
// CDEmoDisplayArea
//
//- All the information relevant to Emoji or Emote display.
//- For interactive display UI. Also connection with status bar.
//==============================================================================

 class CDEmoDisplayArea extends CDUTChatTextTextureAnimEmoteArea;

 #exec AUDIO IMPORT FILE="Sounds\hover.wav" NAME=HoverSound GROUP="Sound"

 struct MiniFrameDimensions
 {
 	var int Width;
 	var int Height;
 };
 var MiniFrameDimensions MFEmo;

 struct MiniFrame
 {
 	var int MFNumber;

 	var MiniFrameDimensions MFEmo;
 };

 var MiniFrame EmoFrames[100];

 var CDChatWindowEmojis EmoWindowPage;
 var CDMiniFrameList DrawnMiniFrameList;

 var float MiniFrameBeingHovered;
 var float VSBPosDiff;
 var CDMiniFrameList VerticalSBTempo;
 var bool bPlayHoverSound;
 var bool bMiniFrameLMousePressed;

 var() config bool bShouldPlayHoverSound;

 var bool bIsHoveringStill;

 function Created()
 {
 	super.Created();

 	bIsHoveringStill = false;
 	MiniFrameBeingHovered = -1;

 	bMiniFrameLMousePressed = false;

 	if(DrawnMiniFrameList != None)
 	{
 		DrawnMiniFrameList.DestroyList();
 	}
 }

 function float DrawTextTextureLine(Canvas C, UWindowDynamicTextRow L, float Y)
 {
 	return 0;
 }

 // Paint in TheEmoArea
 function Paint2(Canvas C, float MouseX, float MouseY)
 {
 	local float MiniFrameX, MiniFrameY;
 	local float BetweenTheMiniFrameSeperationX, BetweenTheMiniFrameSeperationY;
 	local CDMiniFrameList TempoMFToPaint;
 	local Region ThisWindowRegion;
 	local int SkipCount;

 	ThisWindowRegion.X = 0;
 	ThisWindowRegion.Y = 0;
 	ThisWindowRegion.W = WinWidth;
 	ThisWindowRegion.H = WinHeight;

 	// Some sweet values after dynamic interpolation
 	// More information: when no scaling, with minimum size
 	MFEmo.Width = 495 / 8;
 	MFEmo.Height = int(MFEmo.Width * 1.1) * 0.75;

 	BetweenTheMiniFrameSeperationX = MFEmo.Width * 0.2;
 	BetweenTheMiniFrameSeperationY = MFEmo.Height * 0.4;

 	// EMO display starting point
 	MiniFrameY = MFEmo.Height * 0.2;
 	MiniFrameX = MFEmo.Width * 0.2;

 	// See which one are to be painted and prepare LL accordingly

 	// First include all the mini frames in LL
 	PrepareMFDrawLL(MiniFrameY);

 	// Estimate and compute the row and column of each frame
 	DrawnMiniFrameList.ComputeRowAndColumnOfElements(ThisWindowRegion, MiniFrameY, BetweenTheMiniFrameSeperationX,
 	BetweenTheMiniFrameSeperationY);

 	// Compute visible rows
 	VisibleRows = ThisWindowRegion.H / (MFEmo.Height + 2 * BetweenTheMiniFrameSeperationY);
 	Count =  DrawnMiniFrameList.RowCount();

 	VertSB.SetRange(0, Count, VisibleRows);

 	if(Count <= VisibleRows)
 	{
 		VertSB.HideWindow();
 	}
 	else
 	{
 		VertSB.ShowWindow();
 	}

 	//Log("After skipping 2 rows, mini frame number got is: " @ CDMiniFrameList(DrawnMiniFrameList.Next).SkipRows(2).MFNumber);


 	SkipCount = VertSB.Pos;
 	TempoMFToPaint = DrawnMiniFrameList.SkipRows(SkipCount);


 	//Log("Display Height is: " $ WinHeight $ " LL height is: " $ DrawnMiniFrameList.GetMiniFrameListHieght());

 	// Iterate over the DrawnMiniFrameList LL
 	//Tempo = CDMiniFrameList(DrawnMiniFrameList.Next);

 	// For all emojis with vertical scrolling enabled
 	while(TempoMFToPaint != none && MiniFrameY < WinHeight)
 	{
 		if(TempoMFToPaint.bIsBeingHovered)
 		{
 			if(TempoMFToPaint.MFNumber < 28)
 			{
 				DrawDepressedMiniFrameCell(C, MiniFrameX, MiniFrameY, TempoMFToPaint.MFWidth, TempoMFToPaint.MFHeight, GetEmojiTextSymbol(TempoMFToPaint.MFNumber), GetEmojiTexture(TempoMFToPaint.MFNumber));
 				EmoWindowPage.EmoHelper(GetEmojiStatusBarText(TempoMFToPaint.MFNumber), true);
 			}
 			else
 			{
 				DrawDepressedMiniFrameCell(C, MiniFrameX, MiniFrameY, TempoMFToPaint.MFWidth, TempoMFToPaint.MFHeight, GetEmoteTextSymbol(TempoMFToPaint.MFNumber), GetEmoteTexture(TempoMFToPaint.MFNumber));
 				EmoWindowPage.EmoHelper(GetEmoteStatusBarText(TempoMFToPaint.MFNumber), true);
 			}
 		}
 		else
 		{
 			if(TempoMFToPaint.MFNumber < 28)
 			{
 				DrawMiniFrameCell(C, MiniFrameX, MiniFrameY, TempoMFToPaint.MFWidth, TempoMFToPaint.MFHeight, GetEmojiTextSymbol(TempoMFToPaint.MFNumber), GetEmojiTexture(TempoMFToPaint.MFNumber));
 			}
 			else
 			{
 				DrawMiniFrameCell(C, MiniFrameX, MiniFrameY, TempoMFToPaint.MFWidth, TempoMFToPaint.MFHeight, GetEmoteTextSymbol(TempoMFToPaint.MFNumber), GetEmoteTexture(TempoMFToPaint.MFNumber));
 			}
 		}

 		MiniFrameX += MFEmo.Width + BetweenTheMiniFrameSeperationX;

 		if(TempoMFToPaint.Next != none && CDMiniFrameList(TempoMFToPaint.Next).bSplitByHand)
 		{
 			MiniFrameX = MFEmo.Width * 0.2;
 			MiniFrameY += MFEmo.Height + 2 * BetweenTheMiniFrameSeperationY;
 		}

 		if(MiniFrameX + MFEmo.Width >= WinWidth)
 		{
 			MiniFrameX = MFEmo.Width * 0.2;
 			MiniFrameY += MFEmo.Height + BetweenTheMiniFrameSeperationY;
 		}

 		TempoMFToPaint = CDMiniFrameList(TempoMFToPaint.Next);
 	}

 }

 function Click(float X, float Y)
 {
 	EmoClick(X, Y + VSBPosDiff);
 }

 function Tick(float DeltaTime)
 {
 	super.Tick(DeltaTime);

 	if(VertSB.Pos != 0)
 	{
 		VSBPosDiff =  VertSB.Pos * (MFEmo.Height + MFEmo.Height * 0.4 /*BetweenTheMiniFrameSeperationY*/);
 	}
 	else
 	{
 		VSBPosDiff = 0.0;
 	}
 }

/*******************************************************************************
 * The routine to detect which MiniFrame was clicked by the mouse cursor.
 * If the MiniFrame was clicked then inscribe the appropriate symbol in text.
 *
 * @PARAM X       The absissa of the mouse position
 * @PARAM Y       The ordinate of the mouse position
 *
 *******************************************************************************
 */

 function EmoClick(float X, float Y)
 {
 	local int MiniFrameCellNumber;

 	if(IsHoveringOverMiniFrameCell(X, Y, MiniFrameCellNumber))
 	{
 		if(MiniFrameCellNumber < 28)
 		{
 			EmoWindowPage.EditMesg.EditBox.InsertText(GetEmojiTextSymbol(MiniFrameCellNumber));
 		}
 		else
 		{
 			EmoWindowPage.EditMesg.EditBox.InsertText(GetEmoteTextSymbol(MiniFrameCellNumber));
 		}
 	}
 }

 function MouseMove(float X, float Y)
 {
 	Super.MouseMove(X, Y);
 	EmoHover(X, Y + VSBPosDiff);
 }

/*******************************************************************************
 * The function is called when mouse cursor is hovering over the
 * TheEmoDisplayArea. The utility is two-fold (using flipflop logic)
 * 1. Detect when the mouse enters a mini frame region
 * 2. Detect when the mouse leave the mini frame region
 *
 * @PARAM X       The absissa of the mouse position
 * @PARAM Y       The ordinate of the mouse position
 *
 *******************************************************************************
 */

 function EmoHover(float X, float Y)
 {
 	local int MiniFrameCellNumber;
 	local CDMiniFrameList LMiniFrame;

 	if(IsHoveringOverMiniFrameCell(X, Y, MiniFrameCellNumber))
 	{
 		bIsHoveringStill = true;
 		MiniFrameBeingHovered = MiniFrameCellNumber;

 		if(bPlayHoverSound && bShouldPlayHoverSound)
 		{
 			Root.GetPlayerOwner().ClientPlaySound(sound'HoverSound');
 			bPlayHoverSound = false;
 		}
 	}
 	else
 	{
 		if(bIsHoveringStill)
 		{
 			bPlayHoverSound = true;

 			bIsHoveringStill = false;

 			if(MiniFrameBeingHovered < 28)
 			{
 				EmoWindowPage.EmoHelper(GetEmojiStatusBarText(MiniFrameBeingHovered), false);
 			}
 			else
 			{
 				EmoWindowPage.EmoHelper(GetEmoteStatusBarText(MiniFrameBeingHovered), false);
 			}

 			LMiniFrame = CDMiniFrameList(DrawnMiniFrameList.Next);

 			while(LMiniFrame != none)
 			{
 				if(LMiniFrame.bIsBeingHovered)
 				{
 					LMiniFrame.bIsBeingHovered = false;
 				}

 				LMiniFrame = CDMiniFrameList(LminiFrame.Next);
 			}

 			MiniFrameBeingHovered = -1;
 		}
 	}
 }

/*******************************************************************************
 * A utility function to check if mouse is hovering a mini frame. Spits the
 * number of the mini frame cell
 *
 * @PARAM X           The absissa of the mouse position
 * @PARAM Y           The ordinate of the mouse position
 * @PARAM CellNumber  The number of mini frame being hovered by the mouse
 * @Return            True if a mini frame is being hovered over
 *
 *******************************************************************************
 */

 function bool IsHoveringOverMiniFrameCell(float X, float Y, optional out int CellNumber)
 {
 	local CDMiniFrameList LMiniFrame;

 	LMiniFrame = CDMiniFrameList(DrawnMiniFrameList.Next);

 	while(LMiniFrame != none)
 	{
 		if(IsCoordinateWithinRegion(X, Y, LMiniFrame.XTopLeftPos, LMiniFrame.YTopLeftPos,
 			LMiniFrame.XBottomRightPos, LMiniFrame.YBottomRightPos))
 		{
 			CellNumber = LMiniFrame.MFNumber;
 			return true;
 		}

 		LMiniFrame = CDMiniFrameList(LminiFrame.Next);
 	}

 	return false;
 }

/*******************************************************************************
 * A very important utility routine for checking whether the point (X, Y) is
 * inside or not (inclusive) of defined area (Top left and bottom right
 * coordinates). Also I know, should be named AreCoordinatesWithinRegion!
 *
 * @PARAM CoordinateX    The absissa of the point being checked
 * @PARAM CoordinateY    The ordinate of the point being checked
 * @PARAM TopLeftX       The top left corner absissa of the region (or area)
 * @PARAM TopLeftY       The top left corner ordinate of the region
 * @PARAM BottomRightX   The bottom right corner absissa of the region
 * @PARAM BottomRightX   The bottom right corner ordinate of the region
 * @PARAM return         True if the point is inside (inclusive) of the rigion
 *                       False if not!!
 *
 *******************************************************************************
 */

 function bool IsCoordinateWithinRegion(float CoordinateX, float CoordinateY, float TopLeftX, float TopLeftY, float BottomRightX, float BottomRightY)
 {
 	if(CoordinateX >= TopLeftX && CoordinateX <= BottomRightX)
 	{
 		if(CoordinateY >= TopLeftY && CoordinateY <= BottomRightY)
 		{
 			return true;
 		}
 		return false;
 	}

 	return false;
 }

 function LMouseDown(float X, float Y)
 {
 	super.LMouseDown(X, Y);
 	bMiniFrameLMousePressed = true;
 }

 function LMouseUp(float X, float Y)
 {
 	super.LMouseUp(X, Y);
 	bMiniFrameLMousePressed = false;
 }

function PrepareMFDrawLL(float MiniFrameY)
{
 	local float MiniFrameX;
 	local int EmoCounter;
 	local float BetweenTheMiniFrameSeperationX, BetweenTheMiniFrameSeperationY;
 	local CDMiniFrameList Tempo;

 	if(DrawnMiniFrameList != none)
 	{
 		DrawnMiniFrameList.DestroyList();
 	}

 	// Initialize LL
 	DrawnMiniFrameList = new class'CDMiniFrameList';
 	DrawnMiniFrameList.SetupSentinel();
 	DrawnMiniFrameList.MaxDisplayHeight = WinHeight;

 	// Some sweet values after dynamic interpolation
 	// More information: when no scaling, with minimum size
 	MFEmo.Width = 495 / 8;
 	MFEmo.Height = int(MFEmo.Width * 1.1) * 0.75;

 	BetweenTheMiniFrameSeperationX = MFEmo.Width * 0.2;
 	BetweenTheMiniFrameSeperationY = MFEmo.Height * 0.4;

 	// EMO display starting point abscissa
 	MiniFrameX = MFEmo.Width * 0.2;

 	// For all emojis, assuming there is no vertical scrolling needed
 	for(EmoCounter = 0; EmoCounter < 28; EmoCounter++)
 	{
 		// Cache values
 		EmoFrames[EmoCounter].MFNumber = EmoCounter;
 		EmoFrames[EmoCounter].MFEmo = MFEmo;

 		// Add to MF display list
 		Tempo = CDMiniFrameList(DrawnMiniFrameList.Append(class'CDMiniFrameList'));

 		Tempo.MFWidth = MFEmo.Width;
 		Tempo.MFHeight = MFEmo.Height;
 		Tempo.XTopLeftPos = MiniFrameX;
 		Tempo.YTopLeftPos = MiniFrameY;
 		Tempo.XBottomRightPos = MiniFrameX + MFEmo.Width;
 		Tempo.YBottomRightPos = MiniFrameY + MFEmo.Height;

 		Tempo.MFNumber = EmoCounter;

 		if(EmoCounter == MiniFrameBeingHovered)
 		{
 			Tempo.bIsBeingHovered = true;
 		}
 		else
 		{
 			Tempo.bIsBeingHovered = false;
 		}

 		//Log(Tempo.MFNumber @ "Tempo.MFHeight = " @ MiniFrameHeight);

 		// We don't want last element 28 after computation. Either split or halt
 		if(EmoCounter < 27)
 		{
 			MiniFrameX += MFEmo.Width + BetweenTheMiniFrameSeperationX;

 			if(MiniFrameX + MFEmo.Width >= WinWidth)
 			{
 				MiniFrameX = MFEmo.Width * 0.2;
 				MiniFrameY += MFEmo.Height + BetweenTheMiniFrameSeperationY;
 			}
 		}
 	}

 	// Emotes

 	// Set position for the mini frame
 	MiniFrameX = MFEmo.Width * 0.2;
 	MiniFrameY += MFEmo.Height + 2 * BetweenTheMiniFrameSeperationY;

 	// Cache variables
 	EmoFrames[28].MFNumber = 28;
 	EmoFrames[28].MFEmo = MFEmo;

 	// Add to MF display list
 	Tempo = CDMiniFrameList(DrawnMiniFrameList.Append(class'CDMiniFrameList'));

 	Tempo.MFWidth = MFEmo.Width;
 	Tempo.MFHeight = MFEmo.Height;
 	Tempo.XTopLeftPos = MiniFrameX;
 	Tempo.YTopLeftPos = MiniFrameY;
 	Tempo.XBottomRightPos = MiniFrameX + MFEmo.Width;
 	Tempo.YBottomRightPos = MiniFrameY + MFEmo.Height;

 	Tempo.MFNumber = 28;

 	if(MiniFrameBeingHovered == 28)
 	{
 		Tempo.bIsBeingHovered = true;
 	}
 	else
 	{
 		Tempo.bIsBeingHovered = false;
 	}
 	Tempo.bSplitByHand = true;// Helps in gauging the row and column numbers of displayable MF

 	MiniFrameX += MFEmo.Width + BetweenTheMiniFrameSeperationX;

 	// Continue with the Emotes loop
 	for(EmoCounter = 29; EmoCounter < 30; EmoCounter++)
 	{
 		// Cache values
 		EmoFrames[EmoCounter].MFNumber = EmoCounter;
 		EmoFrames[EmoCounter].MFEmo = MFEmo;

 		// Add to MF display list
 		Tempo = CDMiniFrameList(DrawnMiniFrameList.Append(class'CDMiniFrameList'));

 		Tempo.MFWidth = MFEmo.Width;
 		Tempo.MFHeight = MFEmo.Height;
 		Tempo.XTopLeftPos = MiniFrameX;
 		Tempo.YTopLeftPos = MiniFrameY;
 		Tempo.XBottomRightPos = MiniFrameX + MFEmo.Width;
 		Tempo.YBottomRightPos = MiniFrameY + MFEmo.Height;

 		Tempo.MFNumber = EmoCounter;

 		if(EmoCounter == MiniFrameBeingHovered)
 		{
 			Tempo.bIsBeingHovered = true;
 		}
 		else
 		{
 			Tempo.bIsBeingHovered = false;
 		}

 		//Log(Tempo.MFNumber @ "Tempo.MFHeight = " @ MiniFrameHeight);

 		// Filled the row, now split
 		MiniFrameX += MFEmo.Width + BetweenTheMiniFrameSeperationX;

 		if(MiniFrameX + MFEmo.Width >= WinWidth)
 		{
 			MiniFrameX = MFEmo.Width * 0.2;
 			MiniFrameY += MFEmo.Height + BetweenTheMiniFrameSeperationY;
 		}
 	}
}

function DrawDepressedMiniFrameCell(Canvas C, float FrameStartX, float FrameStartY, float Width, float Height, string TextSymbol, Texture Tex)
 {
 	local float DisplayFractionH, DisplayFractionV, XS, YS;
 	local int DepressedOffset;

 	// Nice tuned parameters
 	// specifying how much space texture should be endowed with
 	DisplayFractionH = 0.5;
 	DisplayFractionV = 0.6;

 	DepressedOffset = 1;

 	C.DrawColor = WhiteColor;
 	if(!bMiniFrameLMousePressed)
 	{
 		DrawMiniFrame(C, FrameStartX, FrameStartY, 2);
 	}

 	DrawStretchedTexture(C, FrameStartX + 4 + DepressedOffset, DepressedOffset + FrameStartY + Height / 2  - Height * DisplayFractionV / 2, Width / 2, Height * DisplayFractionV, Tex);

 	C.Font = Root.Fonts[F_Bold];
 	C.TextSize(":d", XS, YS);

 	C.DrawColor = class'CDChatWindowEmojis'.default.BlackColor;
 	ClipText(C, FrameStartX + MFEmo.Width / 2 + 0.32 * XS + DepressedOffset, DepressedOffset + FrameStartY + MFEmo.Height / 2 - 0.2 * YS, TextSymbol);
 }

 function DrawMiniFrameCell(Canvas C, float FrameStartX, float FrameStartY, float Width, float Height, string TextSymbol, Texture Tex)
 {
 	local float DisplayFractionH, DisplayFractionV, XS, YS;

 	// Nice tuned parameters
 	// specifying how much space texture should be endowed with
 	DisplayFractionH = 0.5;
 	DisplayFractionV = 0.6;

 	C.DrawColor = WhiteColor;
 	DrawMiniFrame(C, FrameStartX, FrameStartY, 2);

 	DrawStretchedTexture(C, FrameStartX + 4, FrameStartY + Height / 2  - Height * DisplayFractionV / 2, Width / 2, Height * DisplayFractionV, Tex);

 	C.Font = Root.Fonts[F_Bold];
 	C.TextSize(":d", XS, YS);

 	C.DrawColor = class'CDChatWindowEmojis'.default.BlackColor;
 	ClipText(C, FrameStartX + MFEmo.Width / 2 + 0.32 * XS, FrameStartY + MFEmo.Height / 2 - 0.2 * YS, TextSymbol);
 }

 function DrawMiniFrame(Canvas C, float X, float Y, int BorderWidth)
 {
 	/* Maybe for later lazy sunday afternoons
 	local texture LT;

 	LT = self.GetLookAndFeelTexture();
 	*/

 	//DrawStretchedTexture(C, X, Y, MFEmo.Width, MFEmo.Height, Texture'IYellow');

 	// Top Line
 	DrawStretchedTexture(C, X, Y, BorderWidth, BorderWidth, Texture'BlueMenuTL');
 	DrawStretchedTexture(C, X + BorderWidth, Y, MFEmo.Width - 2 * BorderWidth, BorderWidth, Texture'BlueMenuT');
 	DrawStretchedTexture(C, X + MFEmo.Width - BorderWidth, Y, BorderWidth, BorderWidth, Texture'BlueMenuTR');

 	// Bottom Line
 	DrawStretchedTexture(C, X, Y + MFEmo.Height - BorderWidth, BorderWidth, BorderWidth, Texture'BlueMenuBL');
 	DrawStretchedTexture(C, X + BorderWidth, Y + MFEmo.Height - BorderWidth, MFEmo.Width - 2 * BorderWidth, BorderWidth, Texture'BlueMenuB');
 	DrawStretchedTexture(C, X + MFEmo.Width - BorderWidth, Y + MFEmo.Height - BorderWidth, BorderWidth, BorderWidth, Texture'BlueMenuBR');

 	// Left and Right Lines
 	DrawStretchedTexture(C, X, Y + BorderWidth, BorderWidth, MFEmo.Height - 2 * BorderWidth, Texture'BlueMenuL');
 	DrawStretchedTexture(C, X + MFEmo.Width - BorderWidth, Y + BorderWidth, BorderWidth, MFEmo.Height - 2 * BorderWidth, Texture'BlueMenuR');
 }

 defaultproperties
 {
 	bShouldPlayHoverSound=true
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
