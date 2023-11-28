/*
 *   --------------------------
 *  |  CDUTConsole.uc
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
 *   December, 2022: Native experiments
 *   April, 2023: Native - scripting hybrid progress
 */

//==============================================================================
// CDUTConsole
//
//- This class is useful for gathering Console supplied messages
//- Should be useful when filtered appropriately (for instance SAY messages)
//==============================================================================

class CDUTConsole extends UTConsole config (ChatDiamond);

 var CDChatWindowChat ChatWindow;
 var CDConfigurationWindow ConfigureWindow;
 var string Version;
 var bool bNotifiedConfigurationWindow;

 var() config bool bFilterEvents;
 var() config bool bFilterNonChatMessages;

/*******************************************************************************
 * Routine to gather the messages supplied to the client via PlayerPawn
 *
 * @PARAM PRI                 The PlayerReplicationInfo of involved individual
 *                            who is receiving the message
 * @PARAM Msg                 The actual message
 * @PARAM N                   Message type
 *
 * @also see PlayerPawn::ClientMessage
 *
 *******************************************************************************
 */

function Message(PlayerReplicationInfo PRI, coerce string Msg, name N)
{
 	//Log("In the console: " $ Msg @ "Type: " $ N $ " PRI:" @ PRI.PlayerName);

 	if(PRI == none)
 	{
 	 	return;
 	}

 	if(bFilterNonChatMessages && !PRI.bIsSpectator && (!(N == 'Say' || N == 'TeamSay') && IsMessageNonChat(Msg, false, N)))
 	{
 		return;
 	}

 	// A: Assuming broadcasted messages don't have `:` delimiter
 	if(bFilterNonChatMessages && PRI.bIsSpectator && (IsMessageNonChat(Msg, true, N)))
 	{
 		return;
 	}

 	super.Message(PRI, Msg, N);

 	if(ChatWindow != none)
 	{
 		ChatWindow.InterpretAndDisplayTextClientSide(PRI, Msg, N);
 		//Log("In the console: " $ Msg @ "Type: " $ N $ " PRI:" @ PRI.PlayerName);
 	}
}

function bool IsMessageNonChat(string Message, bool bIsSpectator, name MessageType)
 {
 	local int SenderNameEndPosition;

 	//Log("IsMessageNonChat: " @ Message @ " Type: " @ MessageType);

 	// B: Assuming name has no funny character, i.e delimiter itself
 	// A better assumption (club A and B) there are no ':' delimiters in non chat Message for spectator
 	// except for the spectator name seperator
 	SenderNameEndPosition = Instr(Message, ":");

 	if(bIsSpectator)
 	{
 		if(SenderNameEndPosition != -1)
 		{
 			return false;
 		}
 		return true;
 	}
 	else
 	{
 		if(SenderNameEndPosition != -1)
 		{
 			return false;
 		}
 		return true;
 	}

 	// IDK atm
 	return true;
 }

event AddString( coerce string Msg )
 {
 	if(bFilterEvents)
 	{
 		return;
 	}
 	super.AddString(Msg);
 }

function CloseUWindow()
{
	Super.CloseUWindow();

	SaveConfig();
}

event Tick(float DeltaTime)
{
 	bNotifiedConfigurationWindow = false;
}

state UWindow
{

event bool KeyEvent(EInputKey Key, EInputAction Action, FLOAT Delta)
{

 	if(Action == EInputAction.IST_Press && !bNotifiedConfigurationWindow)
 	{
 		if(ConfigureWindow != none)
 		{
 		 		ConfigureWindow.ConsoleKeyEvent(Key, Action, Delta);
 		}
 		bNotifiedConfigurationWindow = true;
 	}

	return Super.KeyEvent(Key, Action, Delta );
}
}

event bool KeyEvent(EInputKey Key, EInputAction Action, FLOAT Delta)
{
 	if(Action == EInputAction.IST_Press && !bNotifiedConfigurationWindow)
 	{
 		if(ConfigureWindow != none)
 		{
 		 		ConfigureWindow.ConsoleKeyEvent(Key, Action, Delta);
 		}
 		bNotifiedConfigurationWindow = true;
 	}

 	return Super.KeyEvent(Key, Action, Delta);
}


 defaultproperties
 {
 	RootWindow="UMenu.UMenuRootWindow"
 	ConsoleClass=Class'ChatDiamond.CDModMenuWindowFrame'
 	ShowDesktop=True
 	bFilterEvents=False
 	bFilterNonChatMessages=False
 	Version="0.8"
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
