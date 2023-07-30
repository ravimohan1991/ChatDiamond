/*
 *   ---------------------------
 *  |  CDConfigurationWindow.uc
 *   ---------------------------
 *   This file is part of CDAboutWindow for UT99.
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
// CDConfigurationWindow
//
//- ChatDiamond configuration or calibration levers!
//==============================================================================

class CDConfigurationWindow expands UWindowPageWindow;

#exec Texture Import File=Textures\BackgroundTexture.bmp    Name=BackgroundGradation    Mips=off

 var CDModMenuWindowFrame FrameWindow;
 var CDClientSideWindow  ClientWindow;
 var CDUTChatTextTextureAnimEmoteArea ChatWindowTextArea;
 var CDUTConsole UTConsole;

 var UWindowHSliderControl BackGroundRedSlider;
 var UWindowHSliderControl BackGroundGreenSlider;
 var UWindowHSliderControl BackGroundBlueSlider;
 var UWindowHSliderControl EmotesAnimationSpeed;
 var UWindowHSliderControl EmoSizeSlider;
 var UWindowCheckbox ApplyBGToChatWindow, ApplyBGToConsole;
 var UWindowCheckbox PlayMessageArrivedSound;
 var UWindowCheckbox OpenChatWindowAtMatchCompletion;
 var UWIndowCheckbox AutoScrollChat;
 var UWindowEditControl LoadLastMessagesNumber;
 var UWindowSmallButton MessageLoadButton;
 var bool bSecondKeyEvent;

 var UMenuRaisedButton ChatBindButton;
 var UMenuLabelControl ChatBindLabel;

 var float EmojiPreviewX, EmojiPreviewY;
 var float AnimWidth, AnimHeight, AnimPreviewX, AnimPreviewY;

 struct MiniFrameDimensions
 {
 	var int Width;
 	var int Height;
 };
 var MiniFrameDimensions MFEmo;

 var() config int ChatWindowKeyForBind;  //EInputKey

 var float  PrevWinWidth, PrevWinHeight;

 function Created()
 {
 	super.Created();

 	BackGroundRedSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', 20, 40, 250, 50));
 	BackGroundRedSlider.SetTextColor(class'CDChatWindowEmojis'.default.WhiteColor);
 	BackGroundRedSlider.SetText("Red Color");
 	BackGroundRedSlider.SetRange(0, 255, 2);

 	BackGroundGreenSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', 20, 60, 250, 50));
 	BackGroundGreenSlider.SetTextColor(class'CDChatWindowEmojis'.default.WhiteColor);
 	BackGroundGreenSlider.SetText("Green Color");
 	BackGroundGreenSlider.SetRange(0, 255, 2);

 	BackGroundBlueSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', 20, 80, 250, 50));
 	BackGroundBlueSlider.SetTextColor(class'CDChatWindowEmojis'.default.WhiteColor);
 	BackGroundBlueSlider.SetText("Blue Color");
 	BackGroundBlueSlider.SetRange(0, 255, 2);

 	ApplyBGToChatWindow = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 310, 45, 100, 50));
 	ApplyBGToChatWindow.SetTextColor(class'CDChatWindowEmojis'.default.WhiteColor);
 	ApplyBGToChatWindow.SetText("Apply To Chat");
 	//ApplyBGToChatWindow.bChecked = FrameWindow.bApplyBGToChatWindow;

 	ApplyBGToConsole = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 310, 65, 100, 50));
 	ApplyBGToConsole.SetTextColor(class'CDChatWindowEmojis'.default.WhiteColor);
 	ApplyBGToConsole.SetText("Apply To Console");
 	//ApplyBGToConsole.bChecked = FrameWindow.bApplyBGToConsole;

 	ChatBindButton = UMenuRaisedButton(CreateControl(class'UMenuRaisedButton', 144, 120, 60, 1));
 	ChatBindButton.SetTextColor(class'CDChatWindowEmojis'.default.WhiteColor);

 	ChatBindButton.SetText(class'UMenuCustomizeClientWindow'.default.LocalizedKeyName[ChatWindowKeyForBind]);

 	ChatBindLabel = UMenuLabelControl(CreateControl(class'UMenuLabelControl', 20, 125, 65, 1));
 	ChatBindLabel.SetTextColor(class'CDChatWindowEmojis'.default.WhiteColor);
 	ChatBindLabel.SetText("Chat Binding");
 	ChatBindLabel.bAcceptsFocus = False;
 	ChatBindLabel.bIgnoreLDoubleClick = True;
 	ChatBindLabel.bIgnoreMDoubleClick = True;
 	ChatBindLabel.bIgnoreRDoubleClick = True;

 	//ConsoleBindButton to do

 	EmotesAnimationSpeed = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', 20, 160, 250, 50));
 	EmotesAnimationSpeed.SetTextColor(class'CDChatWindowEmojis'.default.WhiteColor);
 	EmotesAnimationSpeed.SetText("Animation Speed");
 	EmotesAnimationSpeed.SetRange(50, 100, 1);

 	EmoSizeSlider = UWindowHSliderControl(CreateCOntrol(class'UWindowHSliderControl', 20, 220, 250, 50));
 	EmoSizeSlider.SetTextColor(class'CDChatWindowEmojis'.default.WhiteColor);
 	EmoSizeSlider.SetText("Emo Size");
 	EmoSizeSlider.SetRange(0, 25, 1);

 	PlayMessageArrivedSound = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 20, 290, 200, 50));
 	PlayMessageArrivedSound.SetTextColor(class'CDChatWindowEmojis'.default.WhiteColor);

 	PlayMessageArrivedSound.SetText("Play sound on message arrival");

 	OpenChatWindowAtMatchCompletion = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 20, 310, 200, 50));
 	OpenChatWindowAtMatchCompletion.SetTextColor(class'CDChatWindowEmojis'.default.WhiteColor);

 	OpenChatWindowAtMatchCompletion.SetText("Open chat window on match completion");

 	LoadLastMessagesNumber = UWindowEditControl(CreateControl(Class'UWindowEditControl', 20, 334, 200, 16));
 	LoadLastMessagesNumber.EditBoxWidth = 25;
 	LoadLastMessagesNumber.SetTextColor(class'CDChatWindowEmojis'.default.WhiteColor);
 	LoadLastMessagesNumber.SetText("Load last x messages");
 	LoadLastMessagesNumber.SetNumericOnly(true);
 	LoadLastMessagesNumber.SetFont(0);
 	LoadLastMessagesNumber.SetHistory(True);
 	LoadLastMessagesNumber.SetValue("");
 	LoadLastMessagesNumber.Align = TA_Left;

 	MessageLoadButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 230, 334, 50, 25));
 	MessageLoadButton.SetText("Load");

 	MessageLoadButton.DownSound = sound'UnrealShare.FSHLITE2';

 	AutoScrollChat = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 20, 360, 200, 50));
 	AutoScrollChat.SetTextColor(class'CDChatWindowEmojis'.default.WhiteColor);

 	AutoScrollChat.SetText("Auto v-scroll chat");

 	// See Paint() for drawing of preview miniframe

 	CDUTConsole(Root.Console).ConfigureWindow = self;

 	SetAcceptsFocus();

 	PrevWinWidth  = WinWidth;
 	PrevWinHeight = WinHeight;

 }

 function Notify (UWindowDialogControl C, byte E)
 {
  	local int Temp;

 	super.Notify(C, E);

 	Switch(E)
 	{
 		case DE_Change:
 			switch(C)
 			{
 				case BackGroundRedSlider:
 					FrameWindow.BackGroundColor.R = BackGroundRedSlider.GetValue();
 					FrameWindow.SaveConfig();
 				break;

 				case BackGroundGreenSlider:
 					FrameWindow.BackGroundColor.G = BackGroundGreenSlider.GetValue();
 					FrameWindow.SaveConfig();
 				break;

 				case BackGroundBlueSlider:
 					FrameWindow.BackGroundColor.B = BAckGroundBlueSlider.GetValue();
 					FrameWindow.SaveConfig();
 				break;
 				case ApplyBGToChatWindow:
 					FrameWindow.bApplyBGToChatWindow = ApplyBGToChatWindow.bChecked;
 					FrameWindow.SaveConfig();
 				break;
 				case ApplyBGToConsole:
 					FrameWindow.bApplyBGToConsole = ApplyBGToConsole.bChecked;
 					FrameWindow.SaveConfig();
 				break;
 				case EmoSizeSlider:
 					FrameWindow.EmoSize = EmoSizeSlider.GetValue();
 					FrameWindow.SaveConfig();
 					ClientWindow.ChatConfigurationUpdated();
 				break;
 				case EmotesAnimationSpeed:
					FrameWindow.EmoteAnimSpeed = EmotesAnimationSpeed.GetValue();
					FrameWindow.SaveConfig();
					ClientWindow.ChatConfigurationUpdated();
 				break;
 				case PlayMessageArrivedSound:
 					FrameWindow.bPlaySoundOnMessageArrival = PlayMessageArrivedSound.bChecked;
 					FrameWindow.SaveConfig();
 					ClientWindow.ChatConfigurationUpdated();
 				break;
 				case OpenChatWindowAtMatchCompletion:
					FrameWindow.bOpenChatWindowOnMatchCompletion = OpenChatWindowAtMatchCompletion.bChecked;
 					FrameWindow.SaveConfig();
 					//ClientWindow.ChatConfigurationUpdated();
 				break;
 				case AutoScrollChat:
 					FrameWindow.bAutoScrollChat = AutoScrollChat.bChecked;
 					FrameWindow.SaveConfig();
 					ClientWindow.ChatConfigurationUpdated();
 				break;
 				/*
 				case ConfigPoller:
 					if(ChatBindButton.bDisabled && ConfigPoller.GetValue() != "")
 					{
 						Log("Typing " $ UWindowEditControl(C).GetValue());
 						ChatBindButton.bDisabled = false;

 					}
 				break;  */
 			}
 		break;
 		case DE_Click:
 			switch(C)
 			{
 				case ChatBindButton:
 					ChatBindButton.bDisabled = true;
 					bSecondKeyEvent = true;
 				break;
 				case MessageLoadButton:
  					Temp = int(LoadLastMessagesNumber.GetValue());
  					if(Temp != FrameWindow.LastHistoricMessagesNumber)
  					{
 						FrameWindow.LastHistoricMessagesNumber = Temp;
 						FrameWindow.SaveConfig();
 						ClientWindow.ChatConfigurationUpdated();
 						ClientWindow.ReloadChatMessages();
  					}
 				break;
 			}
 		break;
 	}
 }

 function ConsoleKeyEvent(int Key, int Action, float Delta)
 {
 	local UMenuPageControl LPages;
 	local UWindowWindow UWindow;

 	if(ChatBindButton.bDisabled)
 	{
 		ChatWindowKeyForBind = Key;
 		ChatBindButton.SetText(class'UMenuCustomizeClientWindow'.default.LocalizedKeyName[Key]);
 		ChatBindButton.bDisabled = false;
 		SaveConfig();
 	}
 	else if(bSecondKeyEvent)
 	{
 		bSecondKeyEvent = false;
 	}
 	else if(Key == ChatWindowKeyForBind)
 	{
 		Root.Console.bQuickKeyEnable = !Root.Console.bUWindowActive;
 		Root.Console.LaunchUWindow();
 		Root.Console.ShowConsole();
 		UWindow =  Root.Console.ConsoleWindow.ClientArea;
 		LPages = CDClientSideWindow(UWindow).Pages;
 		LPages.GotoTab(LPages.GetTab("Public Chats"));
 	}
 }

 function Resized()
 {
 	Super.Resized();
 	Resize();

 	BackGroundRedSlider.SetValue(FrameWindow.BackGroundColor.R);
 	BackGroundGreenSlider.SetValue(FrameWindow.BackGroundColor.G);
 	BackGroundBlueSlider.SetValue(FrameWindow.BackGroundColor.B);
 	EmoSizeSlider.SetValue(FrameWindow.EmoSize);
 	EmotesAnimationSpeed.SetValue(FrameWindow.EmoteAnimSpeed);
 	LoadLastMessagesNumber.SetValue(string(FrameWindow.LastHistoricMessagesNumber));
 	ApplyBGToChatWindow.bChecked = FrameWindow.bApplyBGToChatWindow;
 	OpenChatWindowAtMatchCompletion.bChecked = FrameWindow.bOpenChatWindowOnMatchCompletion;
 	ApplyBGToConsole.bChecked = FrameWindow.bApplyBGToConsole;
 	AutoScrollChat.bChecked = FrameWindow.bAutoScrollChat;
 	PlayMessageArrivedSound.bChecked = FrameWindow.bPlaySoundOnMessageArrival;
 	ChatBindButton.SetText(class'UMenuCustomizeClientWindow'.default.LocalizedKeyName[ChatWindowKeyForBind]);
 }

 function Resize()
 {
 	local float DiffX, DiffY;

 	DiffX = WinWidth - PrevWinWidth;
 	DiffY = WinHeight - PrevWinHeight;
 	if ((DiffX != 0 || DiffY != 0))
 	{
 		//BackgroundRedSlider.WinLeft += DiffX;
 		//BackgroundRedSlider.WinTop += DiffY;
 	}
 	PrevWinWidth = WinWidth;
 	PrevWinHeight = WinHeight;
 }

 function BeforePaint( Canvas C, float X, float Y )
 {
 	Super.BeforePaint(C, X, Y);
 	Resize();
 }

 function Paint(Canvas C, float MouseX, float MouseY)
 {
 	local float TextureWidth, TextureHeight;

 	Super.Paint(C, MouseX, MouseY);

 	MFEmo.Width = 495 / 8;
 	MFEmo.Height = int(MFEmo.Width * 1.1) * 0.75;

 	AnimWidth =  ChatWindowTextArea.AnimShockEmote.Atlas[ChatWindowTextArea.AnimShockEmote.CurrentAnimFrame].USize * ChatWindowTextArea.AnimShockEmote.TexChatSizeFraction;
 	AnimHeight = ChatWindowTextArea.AnimShockEmote.Atlas[ChatWindowTextArea.AnimShockEmote.CurrentAnimFrame].VSize * ChatWindowTextArea.AnimShockEmote.TexChatSizeFraction;
 	TextureWidth = Texture'Happy'.USize * 0.05 * EmoSizeSlider.GetValue();
 	TextureHeight = Texture'Happy'.VSize * 0.05 * EmoSizeSlider.GetValue();

 	AnimPreviewX = 340 + MFEmo.Width / 2 - AnimWidth / 2;
 	AnimPreviewY = 160 + MFEmo.Height / 2 - AnimHeight / 2;
 	EmojiPreviewX = 340 + MFEmo.Width / 2 - TextureWidth / 2;
 	EmojiPreviewY = 220 + MFEmo.Height / 2 - TextureHeight / 2;

 	C.DrawColor = FrameWindow.BackGroundColor;
 	DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BackgroundGradation');


 	C.Style = 3;// STY_Translucent
 	C.DrawColor = class'CDChatWindowEmojis'.default.WhiteColor;
 	// Animation preview window
 	//DrawEmoteMiniFrame(C, 340, 160, 2);
 	DrawStretchedTexture(C, AnimPreviewX, AnimPreviewY, AnimWidth,
 			AnimHeight, ChatWindowTextArea.AnimShockEmote.Atlas[ChatWindowTextArea.AnimShockEmote.CurrentAnimFrame]);
 	C.Style = 1;// STY_Normal

 	C.DrawColor = class'CDChatWindowEmojis'.default.WhiteColor;
 	// Emoji preview window
 	DrawEmojiMiniFrame(C, 340, 220, 2);

 	C.Style = 3;// STY_Translucent
 	C.DrawColor = class'CDChatWindowEmojis'.default.WhiteColor;
 	DrawStretchedTexture(C, EmojiPreviewX, EmojiPreviewY, TextureWidth,
 				TextureHeight, Texture'Happy');
	C.Style = 1;// STY_Normal
 }

 function Close (optional bool bByParent)
 {
 	Super.Close(bByParent);
 	SaveConfig();
 }

 function Tick(float DeltaTime)
 {
 	if(ChatWindowTextArea.TickCounter > ChatWindowTextArea.TickCounterWarpNumber)
 	{
 		ChatWindowTextArea.AnimShockEmote.CurrentAnimFrame++;

 		if(ChatWindowTextArea.AnimShockEmote.CurrentAnimFrame > 9)
 		{
 			ChatWindowTextArea.AnimShockEmote.CurrentAnimFrame = 0;
 		}

 		ChatWindowTextArea.TickCounter = 0;
 	}

 	ChatWindowTextArea.TickCounter++;

 	Super.Tick(DeltaTime);
 }

 // Drawing functions
 function DrawEmoteMiniFrame(Canvas C, float X, float Y, int BorderWidth)
 {
 	// Top Line
 	DrawStretchedTexture(C, X, Y, BorderWidth, BorderWidth, Texture'BlueMenuTL');
 	DrawStretchedTexture(C, X + BorderWidth, Y, AnimWidth - 2 * BorderWidth, BorderWidth, Texture'BlueMenuT');
 	DrawStretchedTexture(C, X + AnimWidth - BorderWidth, Y, BorderWidth, BorderWidth, Texture'BlueMenuTR');

 	// Bottom Line
 	DrawStretchedTexture(C, X, Y + AnimHeight - BorderWidth, BorderWidth, BorderWidth, Texture'BlueMenuBL');
 	DrawStretchedTexture(C, X + BorderWidth, Y + AnimHeight - BorderWidth, AnimWidth - 2 * BorderWidth, BorderWidth, Texture'BlueMenuB');
 	DrawStretchedTexture(C, X + AnimWidth - BorderWidth, Y + AnimHeight - BorderWidth, BorderWidth, BorderWidth, Texture'BlueMenuBR');

 	// Left and Right Lines
 	DrawStretchedTexture(C, X, Y + BorderWidth, BorderWidth, AnimHeight - 2 * BorderWidth, Texture'BlueMenuL');
 	DrawStretchedTexture(C, X + AnimWidth - BorderWidth, Y + BorderWidth, BorderWidth, AnimHeight - 2 * BorderWidth, Texture'BlueMenuR');
 }

 function DrawEmojiMiniFrame(Canvas C, float X, float Y, int BorderWidth)
 {
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
