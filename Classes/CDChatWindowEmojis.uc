/*
 *   --------------------------
 *  |  UTChatWindowEmojis.uc
 *   --------------------------
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

//================================================================================
// UTChatWindowEmojis
//
// - Flashing of availabule emojis
//================================================================================

class CDChatWindowEmojis extends UWindowPageWindow;

 #exec Texture Import File=Textures\emodisplay.bmp    Name=IYellow    Mips=off
 #exec AUDIO IMPORT FILE="Sounds\hover.wav" NAME=HoverSound GROUP="Sound"

 //var() int Element

 struct MiniFrameDimensions
 {
 	var int Width;
 	var int Height;
 };
 var MiniFrameDimensions MFEmo;

 struct MiniFrame
 {
 	var int XTopLeftPos, YTopLeftPos;
 	var int XBottomRightPos, YBottomRightPos;
 	var int MFNumber;

 	var MiniFrameDimensions MFEmo;
 };

 var MiniFrame EmoFrames[100];

 var CDMiniFrameList DrawnMiniFrameList;

 var int NumberOfColumnElements;

 var float MFWidhtToHeightRatio;

 var CDUTChatTextTextureAnimEmoteArea TheEmoDisplayArea;
 var CDChatWindowChat ChatWindow;

 var CDModMenuWindowFrame FrameWindow;

 var int MaxMFRows;

 var color WhiteColor, GrayColor;
 var color PinkColor;

 var float  PrevWinWidth, PrevWinHeight;
 var float  PageWidth, PageHeight;
 var string DetailMode;
 var bool bIsHoveringStill;

 var float MiniFrameBeingHovered;
 var float MiniFrameGotClicked;

 var bool bMiniFrameLMousePressed;
 var bool bPlayHoverSound;

 var UWindowSmallButton ButSend;
 var UWindowSmallButton ButSave;
 var UWindowSmallButton ButtonPlaySpectate;
 var UWindowSmallButton ButtonDisconnectAndQuit;
 var UWindowEditControl EditMesg;

 var UWindowHSliderControl MiniFrameSlider;

 function Created ()
 {
 	// Some sweet values after dynamic interpolation
 	NumberOfColumnElements = 8;
 	MFWidhtToHeightRatio = 1.1;

 	Super.Created();

 	TheEmoDisplayArea = CDUTChatTextTextureAnimEmoteArea(CreateControl(Class'CDUTChatTextTextureAnimEmoteArea', 0, 0, 385, 212));
 	TheEmoDisplayArea.AbsoluteFont = Font(DynamicLoadObject("UWindowFonts.TahomaB12", class'Font'));
 	TheEmoDisplayArea.bAutoScrollbar = False;
 	TheEmoDisplayArea.SetTextColor(GrayColor);
 	TheEmoDisplayArea.Clear();
 	TheEmoDisplayArea.bVariableRowHeight = True;
 	TheEmoDisplayArea.bScrollOnResize = True;
 	TheEmoDisplayArea.EmoWindowPage = self;

 	MiniFrameBeingHovered = -1;
 	bIsHoveringStill = false;

 	MiniFrameGotClicked = -1;
 	bMiniFrameLMousePressed = false;

 	// Literal copy paste from CDChatWindowChat
 	ButSave = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 4, 230, 50, 25));
 	ButSave.SetText("Save");
 	ButSave.DownSound = sound'UnrealShare.FSHLITE2';

 	ButSend = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 278, 230, 50, 25));
 	ButSend.SetText("Send");
 	ButSend.DownSound = sound'UnrealShare.FSHLITE2';

 	ButtonDisconnectAndQuit = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 333, 230, 50, 25));
 	ButtonDisconnectAndQuit.SetText("RAGE");//("Goodbye!");
 	ButtonDisconnectAndQuit.DownSound = sound'UnrealShare.FSHLITE2';

 	ButtonPlaySpectate = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 4, 255, 380, 25));

 	if(GetPlayerOwner().GetDefaultURL("OverrideClass") == "Botpack.CHSpectator")
 	{
 		ButtonPlaySpectate.SetText("Play");
 	}
 	else
 	{
 		ButtonPlaySpectate.SetText("Spectate");
 	}
 	ButtonPlaySpectate.DownSound = sound'UnrealShare.FSHLITE2';

 	// must go here to get 1st focus
 	EditMesg = UWindowEditControl(CreateControl(Class'UWindowEditControl', 56, 230, 217, 16));
 	EditMesg.EditBoxWidth = 217;
 	EditMesg.SetNumericOnly(False);
 	EditMesg.SetFont(0);
 	EditMesg.SetHistory(True);
 	EditMesg.SetValue("");
 	EditMesg.Align = TA_Left;

 	if(DrawnMiniFrameList != None)
 	{
 		if(DrawnMiniFrameList.Next == None)
 		{
 			return;
 		}
 		DrawnMiniFrameList.DestroyList();
 	}
 
 	// Initialize LL
 	// DrawnMiniFrameList = new class'CDMiniFrameList';
 	// DrawnMiniFrameList.SetupSentinel();

 	SetAcceptsFocus();

 	PrevWinWidth  = WinWidth;
 	PrevWinHeight = WinHeight;
 }

 function bool IsMouseOverPage()
 {
 	local float MouseX, MouseY;
 	local float ThisPageTopLeftX, ThisPageTopLeftY, ThisPageBottomRightX, ThisPageBottomRightY;

 	Root.GetMouseXY(MouseX, MouseY);

 	ThisPageTopLeftY = self.WinTop;
 	ThisPageTopLeftX = self.WinLeft;
 	ThisPageBottomRightX = ThisPageTopLeftX + WinWidth;
 	ThisPageBottomRightY = ThisPageTopLeftY + WinHeight;

 	if(IsCoordinateWithinRegion(MouseX, MouseY, ThisPageTopLeftX, ThisPageTopLeftY, ThisPageBottomRightX, ThisPageBottomRightY))
 	{
 		return true;
 	}
 }

 // I know, should be named coordinates.
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

 function Notify (UWindowDialogControl C, byte E)
 {
 	Super.Notify(C,E);

 	if(E == DE_MouseMove)
 	{
 		if(C == ButSend)
 		{
 			FrameWindow.StatusBarText = "Send the message!";
 		}

 		if(C == ButSave)
 		{
 			FrameWindow.StatusBarText = "Save the messages in ChatDiamond.ini!";
 		}

 		if(C == ButtonPlaySpectate)
 		{
 			FrameWindow.StatusBarText = "Based on the context, play or spectate!";
 		}

 		if(C == ButtonDisconnectAndQuit)
 		{
 			FrameWindow.StatusBarText = "Shut down the game and do `better` things!";
 		}

 		if(C == EditMesg)
 		{
 			FrameWindow.StatusBarText = "Type a message for everyone!";
 		}
 	}

 	Switch(E)
 	{
 		case DE_Change:
 			switch(C)
 			{
 				case MiniFrameSlider:
 					MFWidhtToHeightRatio = MiniFrameSlider.GetValue();
 					MiniFrameSlider.SetText(string(MFWidhtToHeightRatio));
 					MFEmo.Width = WinWidth / 8;
 					MFEmo.Height =  int(MFEmo.Width * MFWidhtToHeightRatio);
 				break;

 				case EditMesg:
 					if(ChatWindow.EditMesg.GetValue() != EditMesg.GetValue())
 					{
 						ChatWindow.EditMesg.SetValue(EditMesg.GetValue());
 					}
 				break;
 			}
 			break;
 		case DE_Click:
 			switch(C)
 			{
 				case ButSave:
 							ChatWindow.SaveConfig();
 							ButSave.bDisabled = True;
 							GetPlayerOwner().ClientMessage("All Messages have been saved to ChatDiamond.ini");
 						break;

 						case ButSend:
 							ChatWindow.SendMessage(EditMesg);
 						break;

 						case ButtonDisconnectAndQuit:
 							Root.QuitGame();
 						break;

 						// Courtsey ProAsm's UTCmds8
 						case ButtonPlaySpectate:
 						if(GetPlayerOwner().PlayerReplicationInfo.bIsSpectator)
 						{
 							GetPlayerOwner().PreClientTravel();
 							GetPlayerOwner().ClientTravel("?OverrideClass=", TRAVEL_Relative, False);
 							ButtonPlaySpectate.SetText("Spectate");
 						}
 						else
 						{
 						GetPlayerOwner().PreClientTravel();
 						GetPlayerOwner().ClientTravel("?OverrideClass=Botpack.CHSpectator", TRAVEL_Relative, False);
 						ButtonPlaySpectate.SetText("Play");
 						}

 						break;
 				}
 			break;
 		case 7:
 			ChatWindow.SendMessage(EditMesg);
 		break;
 		default:
 		break;
 	}
 }

 function EmoHelper(string StatusBarText, bool bSet)
 {
 	if(bSet)
 	{
 		FrameWindow.StatusBarText = StatusBarText;
 	}
 	else
 	{
 		FrameWindow.StatusBarText = "";
 	}
 }


 function EmoClick(float X, float Y)
 {
 	local int MiniFrameCellNumber;

 	if(IsHoveringOverMiniFrameCell(X, Y, MiniFrameCellNumber))
 	{
 		if(MiniFrameCellNumber < 28)
 		{
 			EditMesg.EditBox.InsertText(TheEmoDisplayArea.GetEmojiTextSymbol(MiniFrameCellNumber));
 		}
 		else
 		{
 			EditMesg.EditBox.InsertText(TheEmoDisplayArea.GetEmoteTextSymbol(28));
 		}
 	}
 }

 function EmoHover(float X, float Y)
 {
 	local int MiniFrameCellNumber;

 	if(IsHoveringOverMiniFrameCell(X, Y, MiniFrameCellNumber))
 	{
 		bIsHoveringStill = true;
 		MiniFrameBeingHovered = MiniFrameCellNumber;

 		if(bPlayHoverSound)
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

 			EmoMouseNoLongerHovering(X, Y);
 			bIsHoveringStill = false;

 			if(MiniFrameBeingHovered < 28)
 			{
 				EmoHelper(TheEmoDisplayArea.GetEmojiStatusBarText(MiniFrameBeingHovered), false);
 			}
 			else
 			{
 				EmoHelper(TheEmoDisplayArea.GetEmoteStatusBarText(MiniFrameBeingHovered), false);
 			}
 			MiniFrameBeingHovered = -1;
 		}
 	}
 }

 function EmoMouseNoLongerHovering(float X, float Y)
 {
 }

 function bool IsHoveringOverMiniFrameCell(float X, float Y, optional out int CellNumber)
 {
 	local int Index;

 	for(Index = 0; Index <= 28; Index++)
 	{
 		if(IsCoordinateWithinRegion(X, Y, EmoFrames[Index].XTopLeftPos, EmoFrames[Index].YTopLeftPos,
 		EmoFrames[Index].XBottomRightPos, EmoFrames[Index].YBottomRightPos))
 		{
 			CellNumber = EmoFrames[Index].MFNumber;
 			return true;
 		}
 	}

 	return false;
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
 	if ((DiffX != 0 || DiffY != 0))
 	{
 		TheEmoDisplayArea.SetSize(TheEmoDisplayArea.WinWidth + DiffX, TheEmoDisplayArea.WinHeight + DiffY);
 		TheEmoDisplayArea.WrapWidth = TheEmoDisplayArea.WinWidth - 80;

 		ButSave.WinTop += DiffY;

 		ButSend.WinLeft += DiffX;
 		ButSend.WinTop += DiffY;

 		ButtonDisconnectAndQuit.WinLeft += DiffX;
 		ButtonDisconnectAndQuit.WinTop += DiffY;

 		EditMesg.WinTop += DiffY;
 		EditMesg.SetSize(EditMesg.WinWidth + DiffX, EditMesg.WinHeight);
 		EditMesg.EditBoxWidth = EditMesg.WinWidth;

 		ButtonPlaySpectate.WinTop += DiffY;
 		ButtonPlaySpectate.SetSize(ButtonPlaySpectate.WinWidth + DiffX, ButtonPlaySpectate.WinHeight);
 	}
 	PrevWinWidth = WinWidth;
 	PrevWinHeight = WinHeight;
 }

 function BeforePaint( Canvas C, float X, float Y )
 {
 	Super.BeforePaint(C, X, Y);
 	Resize();
 }

 function Paint (Canvas C, float MouseX, float MouseY)
 {
 	local float TitleXLength, TitleYLength, MiniFrameX, MiniFrameY, MiniFrameWidth, MiniFrameHeight;
 	local string StringToDraw;
 	local float MaximumFrameWidth;
 	local int EmoCounter;
 	local float BetweenTheMiniFrameSeperationX, BetweenTheMiniFrameSeperationY;
 	local CDMiniFrameList Tempo;
 	local Region ThisWindowRegion;

 	Super.Paint(C,MouseX,MouseY);

 	// Initialize LL
 	DrawnMiniFrameList = new class'CDMiniFrameList';
	DrawnMiniFrameList.SetupSentinel();
	DrawnMiniFrameList.MaxDisplayHeight = TheEmoDisplayArea.WinHeight;

 	ThisWindowRegion.X = 0;
 	ThisWindowRegion.Y = 0;
 	ThisWindowRegion.W = WinWidth;
 	ThisWindowRegion.H = WinHeight;

 	MaximumFrameWidth = WinWidth * Root.GUIScale;

 	// Page Title
 	C.Font = Root.Fonts[F_LargeBold];

 	StringToDraw = "Chat Diamond EMO Representation";
 	C.TextSize(StringToDraw, TitleXLength, TitleYLength);

 	C.SetPos((WinWidth * Root.GUIScale) / 2 - TitleXLength / 2, Root.GUIScale * TitleYLength * 0.25);
 	C.DrawText(StringToDraw);

 	// Some sweet values after dynamic interpolation
 	// More information: when no scaling, with minimum size
 	MFEmo.Width = 495 / 8;
 	MFEmo.Height = int(MFEmo.Width * MFWidhtToHeightRatio) * 0.75;

 	BetweenTheMiniFrameSeperationX = MFEmo.Width * 0.2;
 	BetweenTheMiniFrameSeperationY = MFEmo.Height * 0.4;

 	// EMO display starting point
 	MiniFrameY = 2 * TitleYLength / Root.GUIScale;
 	MiniFrameX = MFEmo.Width * 0.2;

 	//Log("The y statring coordinate is: " @ MiniFrameY);

 	//VisibleRows = WinHeight / DefaultTextTextureLineHeight;

 	// For all emojis
 	for(EmoCounter = 0; EmoCounter < 28; EmoCounter++)
 	{
 		MiniFrameWidth = MFEmo.Width;
 		MiniFrameHeight = MFEmo.Height;

 		if(MiniFrameBeingHovered == EmoCounter)
 		{
 			DrawDepressedMiniFrameCell(C, MiniFrameX, MiniFrameY, MiniFrameWidth, MiniFrameHeight, TheEmoDisplayArea.GetEmojiTextSymbol(EmoCounter), TheEmoDisplayArea.GetEmojiTexture(EmoCounter));
 			EmoHelper(TheEmoDisplayArea.GetEmojiStatusBarText(EmoCounter), true);
 		}
 		else
 		{
 		DrawMiniFrameCell(C, MiniFrameX, MiniFrameY, MiniFrameWidth, MiniFrameHeight, TheEmoDisplayArea.GetEmojiTextSymbol(EmoCounter), TheEmoDisplayArea.GetEmojiTexture(EmoCounter));
 		}

 		// Cache values
 		EmoFrames[EmoCounter].MFNumber = EmoCounter;
 		EmoFrames[EmoCounter].XTopLeftPos = MiniFrameX;
 		EmoFrames[EmoCounter].YTopLeftPos = MiniFrameY;
 		EmoFrames[EmoCounter].XBottomRightPos = MiniframeX + MiniFrameWidth;
 		EmoFrames[EmoCounter].YBottomRightPos = MiniframeY + MiniFrameHeight;
 		EmoFrames[EmoCounter].MFEmo = MFEmo;

 		// Add to MF display list
 		Tempo = CDMiniFrameList(DrawnMiniFrameList.Append(class'CDMiniFrameList'));

 		Tempo.MFWidth = MiniFrameWidth;
 		Tempo.MFHeight = MiniFrameHeight;

 		Tempo.MFNumber = EmoCounter;
 		//Log(Tempo.MFNumber @ "Tempo.MFHeight = " @ MiniFrameHeight);

 		MiniFrameX += MFEmo.Width + BetweenTheMiniFrameSeperationX;

 		if(MiniFrameX + MFEmo.Width >= WinWidth)
 		{
 			MiniFrameX = MFEmo.Width * 0.2;
 			MiniFrameY += MFEmo.Height + BetweenTheMiniFrameSeperationY;

 			// May need to consider scrolling
 		}
 	}

 	//Log("Printing DrawnMF");

 	// Emotes

 	MiniFrameX = MFEmo.Width * 0.2;
 	MiniFrameY += MFEmo.Height + 2 * BetweenTheMiniFrameSeperationY;

 	MiniFrameWidth = MFEmo.Width;
 	MiniFrameHeight = MFEmo.Height;

 	if(MiniFrameBeingHovered == 28)
 	{
 		DrawDepressedMiniFrameCell(C, MiniFrameX, MiniFrameY, MiniFrameWidth, MiniFrameHeight,
 		TheEmoDisplayArea.GetEmoteTextSymbol(EmoCounter), TheEmoDisplayArea.GetEmoteTexture(28));
 		EmoHelper(TheEmoDisplayArea.GetEmoteStatusBarText(MiniFrameBeingHovered), true);
 	}
 	else
 	{
 		DrawMiniFrameCell(C, MiniFrameX, MiniFrameY, MiniFrameWidth, MiniFrameHeight,
 		TheEmoDisplayArea.GetEmoteTextSymbol(EmoCounter), TheEmoDisplayArea.GetEmoteTexture(28));
 	}

 	EmoFrames[28].MFNumber = 28;
 	EmoFrames[28].XTopLeftPos = MiniFrameX;
 	EmoFrames[28].YTopLeftPos = MiniFrameY;
 	EmoFrames[28].XBottomRightPos = MiniframeX + MiniFrameWidth;
 	EmoFrames[28].YBottomRightPos = MiniframeY + MiniFrameHeight;
 	EmoFrames[28].MFEmo = MFEmo;

 	Tempo = CDMiniFrameList(DrawnMiniFrameList.Append(class'CDMiniFrameList'));

 	Tempo.MFWidth = MiniFrameWidth;
 	Tempo.MFHeight = MiniFrameHeight;
 	Tempo.MFNumber = 28;
 	Tempo.bSplitByHand = true;// Helps in gauging the row and column numbers of MF
 	
 	//Log(MiniFrameY @ "Y depth is: " @ MiniFrameY + MiniFrameHeight);
 	
 	DrawnMiniFrameList.ComputeRowAndColumnOfElements(ThisWindowRegion, TitleYLength, BetweenTheMiniFrameSeperationX,
 	BetweenTheMiniFrameSeperationY);
 	// Log(Root.GUIScale @ "Display Height is: " $ TheEmoDisplayArea.WinHeight * Root.GUIScale $ " LL height is: " $ DrawnMiniFrameList.GetMiniFrameListHieght());

 	DrawnMiniFrameList.Clear();
 }

function PrepareMFDrawLL()
{
}

function CDMiniFrameList AddMiniFrame(string NewLine)
{
	local CDMiniFrameList L;

	return L;
}

function CDMiniFrameList CheckMaxRows()
{
	local CDMiniFrameList L;
	L = None;

	while(MaxMFRows > 0 && DrawnMiniFrameList.Count() > MaxMFRows - 1 && DrawnMiniFrameList.Next != None)
	{
		L = CDMiniFrameList(DrawnMiniFrameList.Next);
		RemoveWrap(L);
		L.Remove();
	}

	return L;
}

function RemoveWrap(CDMiniFrameList L)
{
	local CDMiniFrameList N;

	// Remove previous word-wrapping
	N = CDMiniFrameList(L.Next);
	while(N != None && N.WrapParent == L)
	{
		L.Text = L.Text $ N.Text;
		N.Remove();
		N = CDMiniFrameList (L.Next);
	}
}

 function  DrawDepressedMiniFrameCell(Canvas C, float FrameStartX, float FrameStartY, float Width, float Height, string TextSymbol, Texture Tex)
 {
 	local float DisplayFractionH, DisplayFractionV, XS, YS;
 	local int DepressedOffset;

 	// Nice tuned parameters
 	// specifying how much space texture should be endowed with
 	DisplayFractionH = 0.5;
 	DisplayFractionV = 0.6;

 	DepressedOffset = 1;

 	if(!bMiniFrameLMousePressed)
 	{
 		DrawMiniFrame(C, FrameStartX, FrameStartY, 2);
 	}
 	DrawStretchedTexture(C, FrameStartX + 4 + DepressedOffset, DepressedOffset + FrameStartY + Height / 2  - Height * DisplayFractionV / 2, Width / 2, Height * DisplayFractionV, Tex);

 	C.Font = Root.Fonts[F_Bold];
 	C.TextSize(TextSymbol, XS, YS);

 	C.DrawColor = PinkColor;
 	ClipText(C, FrameStartX + MFEmo.Width / 2 + XS + DepressedOffset, DepressedOffset + FrameStartY + MFEmo.Height / 2 - YS / 2, TextSymbol);
 }

 function DrawMiniFrameCell(Canvas C, float FrameStartX, float FrameStartY, float Width, float Height, string TextSymbol, Texture Tex)
 {
 	local float DisplayFractionH, DisplayFractionV, XS, YS;

 	// Nice tuned parameters
 	// specifying how much space texture should be endowed with
 	DisplayFractionH = 0.5;
 	DisplayFractionV = 0.6;

 	DrawMiniFrame(C, FrameStartX, FrameStartY, 2);
 	DrawStretchedTexture(C, FrameStartX + 4, FrameStartY + Height / 2  - Height * DisplayFractionV / 2, Width / 2, Height * DisplayFractionV, Tex);

 	C.Font = Root.Fonts[F_Bold];
 	C.TextSize(TextSymbol, XS, YS);

 	C.DrawColor = PinkColor;
 	ClipText(C, FrameStartX + MFEmo.Width / 2 + XS, FrameStartY + MFEmo.Height / 2 - YS / 2, TextSymbol);
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

 function Close (optional bool bByParent)
 {
 	Super.Close(bByParent);
 	SaveConfig();
 }

 defaultproperties
 {
 	WhiteColor=(R=255,G=255,B=255)
 	PinkColor=(R=255,G=192,B=203)
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
