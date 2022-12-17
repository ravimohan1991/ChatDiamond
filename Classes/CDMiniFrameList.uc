/*
 *   ----------------------
 *  |  CDMiniFrameList.uc
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
 */

class CDMiniFrameList extends UWindowDynamicTextRow;

 // Total number of Rows and Columns starting with  some reference
 var int TotalMFRows;
 var int TotalMFColumns;

 var CDMiniFrameList ReferenceMF;
 var float MaxDisplayHeight;

 // This member's (Row, Column)
 var int MFRow;
 var int MFColumn;

 // This member's width, height, and MF number
 var int MFWidth;
 var int MFHeight;
 var int MFNumber;
 var bool bSplitByHand;
 var bool bIsBeingHovered;

 var int XTopLeftPos, YTopLeftPos;
 var int XBottomRightPos, YBottomRightPos;

 // Some variables stored for height coomputation
 var float BeginHeight;
 var float BetweenMiniFrameVerticalSeperation;


 // Should be called after ComputeRowAndColumnOfElements()
 function int RowCount()
 {
 	local int NumberOfRows;
 	local CDMiniFrameList Tempo;

 	NumberOfRows = -1;

 	Tempo = CDMiniFrameList(self.Next);

 	while(Tempo != none)
 	{
 		if(Tempo.MFRow != NumberOfRows)
 		{
 		 NumberOfRows = Tempo.MFRow;
 		}

 		Tempo = CDMiniFrameList(Tempo.Next);
 	}

 	return NumberOfRows + 1;
 }

 // Starting from current MF
 function CDMiniFrameList SkipRows(int Number)
 {
 	local CDMiniFrameList Tempo;
 	local int RowCounterGauge, RowRegister;

 	Tempo = CDMiniFrameList(self.Next);
 	RowRegister = Tempo.MFRow;

 	while(Tempo.Next != none && RowCounterGauge != Number)
 	{
 		Tempo = CDMiniFrameList(Tempo.Next);

 		if(Tempo.MFRow != RowRegister)
 		{
 		RowCounterGauge++;
 		RowRegister++;
 		}
 	}

 	if(Tempo != none)
 	{
 		return Tempo;
 	}

 	return none;
 }

 function ComputeRowAndColumnOfElements(Region DisplayArea, float YBegin,
          float BetweenTheMiniFrameSeperationX, float BetweenTheMiniFrameSeperationY)
 {
 	local CDMiniFrameList Tempo;
 	local float XOccupied, YOccupied;
 	local int RowIndex, ColumnIndex;

 	if(self.Next == none)
 	{
 		Log("Reached last element.");
 		return;
 	}

 	RowIndex = 0;
 	ColumnIndex = 0;

 	XOccupied += MFWidth * 0.2;
 	YOccupied = YBegin;

 	BeginHeight = YBegin;
 	BetweenMiniFrameVerticalSeperation = BetweenTheMiniFrameSeperationY;

 	// LL iteration
 	Tempo = CDMiniFrameList(self.Next);

 	while(Tempo != None)
 	{
 		Tempo.ReferenceMF = CDMiniFrameList(self.Next);

 		XOccupied += Tempo.MFWidth + BetweenTheMiniFrameSeperationX;

 		Tempo.MFRow = RowIndex;
 		Tempo.MFColumn = ColumnIndex;

 		ColumnIndex++;

 		if(Tempo.Next != none)
 		{
 			if(XOccupied + CDMiniFrameList(Tempo.Next).MFWidth >= DisplayArea.W || CDMiniFrameList(Tempo.Next).bSplitByHand)
 			{
 				RowIndex++;
 				ColumnIndex = 0;

 				XOccupied = MFWidth * 0.2;

 				if(CDMiniFrameList(Tempo.Next).MFNumber < 28)
 				{
 				YOccupied += BetweenTheMiniFrameSeperationY + Tempo.MFHeight;
 				}
 				else if(CDMiniFrameList(Tempo.Next).MFNumber >= 28 && CDMiniFrameList(Tempo.Next).MFNumber <= 40)// Emotes
 				{
 				YOccupied += 2 * BetweenTheMiniFrameSeperationY + Tempo.MFHeight;
 				}
 			}
 		}

 		//Log("MiniFrame Number is:" @ Tempo.MFNumber @ Tempo.ReferenceMF.MFNumber);
 		//Log("RowIndex: " $ Tempo.MFRow $ " ColumnIndex: " $ Tempo.MFColumn);
 		Tempo = CDMiniFrameList(Tempo.Next);
 	}
 }

/*
 function CDMiniFrameList CheckMaxRows(float MaximumDisplayHeight)
 {
 	local CDMiniFrameList MFRowEliminated;

 	MFRowEliminated = None;

 	while(MaximumDisplayHeight > 0 && self.GetMiniFrameListHieght() > MaximumDisplayHeight - CDMinFrameList(self.Next).MFHeight - BetweenMiniFrameVerticalSeperation && List.Next != None)
 	{
 		L = UWindowDynamicTextRow(List.Next);
 		RemoveWrap(L);
 		L.Remove();
 	}

 	return MFRowEliminated;
}
*/

 // This function should be called after
 // ComputeRowAndColumnOfElements()
 function float GetMiniFrameListHieght()
 {
 	local CDMiniFrameList Tempo;
 	local float HeightComputed;
 	local int RowCache;

 	HeightComputed = BeginHeight;
 	RowCache = -1;// Heh, fix for the first LL element being dummy

 	// Log("Ystarting point for computation: " @ HeightComputed @ BetweenMiniFrameVerticalSeperation);

 	//Traversing LL
 	Tempo = CDMiniFrameList(self.Next);

 	while(Tempo != none)
 	{
 		if(Tempo.MFRow != RowCache)
 		{
 			if(Tempo.bSplitByHand)
 			{
 				HeightComputed += Tempo.MFHeight + 2 * BetweenMiniFrameVerticalSeperation;
 			}
 			else
 			{
 				HeightComputed += Tempo.MFHeight + BetweenMiniFrameVerticalSeperation;
 			}
 			// Log(Tempo.MFNumber @ "Increment to Height: " $ HeightComputed @ Tempo.MFRow);

 			RowCache = Tempo.MFRow;
 		}

 		Tempo = CDMiniFrameList(Tempo.Next);
 	}

 	return HeightComputed;
 }

 function int GetRow()
 {
 	return MFRow;
 }

 function int GetColumn()
 {
 	return MFColumn;
 }

 function Clear()
 {
 	super.Clear();
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
