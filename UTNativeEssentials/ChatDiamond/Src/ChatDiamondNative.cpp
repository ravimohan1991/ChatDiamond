/*
 *   ------------------------
 *  |  ChatDiamondNative.cpp
 *   ------------------------
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
 */

#include "ChatDiamondNative.h"
#include <regex>

#include "shellapi.h"
#include "commdlg.h"
#include "CommCtrl.h"
#include "Window.h"

TCHAR SysDir[MAX_PATH] = TEXT(""), WinDir[MAX_PATH] = TEXT(""), ThisFile[MAX_PATH] = TEXT("");
class WConfigWizard : public WWizardDialog
{
	DECLARE_WINDOWCLASS(WConfigWizard, WWizardDialog, Startup)
		WLabel LogoStatic;
	FWindowsBitmap LogoBitmap;
	UBOOL Cancel;
	FString Title;
	WConfigWizard()
		: LogoStatic(this, IDC_Logo)
		, Cancel(0)
	{
		GetSystemDirectory(SysDir, ARRAY_COUNT(SysDir));
		GetWindowsDirectory(WinDir, ARRAY_COUNT(WinDir));
		GetModuleFileName(NULL, ThisFile, ARRAY_COUNT(ThisFile));
		if (appStrlen(ThisFile) > 4 && !appStricmp(&ThisFile[appStrlen(ThisFile) - 4], TEXT(".ICD")))
			appStrcpy(&ThisFile[appStrlen(ThisFile) - 4], TEXT(".EXE")); // stijn: mem safety ok
	}
	void OnInitDialog()
	{
		guard(WStartupWizard::OnInitDialog);
		WWizardDialog::OnInitDialog();
		SendMessageW(*this, WM_SETICON, ICON_BIG, (WPARAM)LoadIconW(hInstance, MAKEINTRESOURCEW(IDICON_Mainframe)));
		LogoBitmap.LoadFile(TEXT("..\\Help\\Logo.bmp"));
		GLog->Logf(TEXT("Loading %s"), TEXT("..\\Help\\Logo.bmp"));

		SendMessageW(LogoStatic, STM_SETIMAGE, IMAGE_BITMAP, (LPARAM)LogoBitmap.GetBitmapHandle());
		SetText(TEXT("Some Window Title"));
		SetForegroundWindow(hWnd);
		unguard;
	}
};

class WConfigPageSafeMode : public WWizardPage
{
	DECLARE_WINDOWCLASS(WConfigPageSafeMode, WWizardPage, Startup)
		WConfigWizard* Owner;
	WCoolButton RunButton, WebButton;
	WConfigPageSafeMode(WConfigWizard* InOwner)
		: WWizardPage(TEXT("ConfigPageSafeMode"), IDDIALOG_ConfigPageSafeMode, InOwner)
		, RunButton(this, IDC_Run, FDelegate(this, (TDelegate)&WConfigPageSafeMode::OnRun))
		, WebButton(this, IDC_Web, FDelegate(this, (TDelegate)&WConfigPageSafeMode::OnWeb))
		, Owner(InOwner)
	{}
	void OnRun()
	{
		Owner->EndDialog(1);
	}
	void OnWeb()
	{
		ShellExecuteW(*this, TEXT("open"), LocalizeGeneral(TEXT("WebPage"), TEXT("Startup")), TEXT(""), appBaseDir(), SW_SHOWNORMAL);
		Owner->EndDialog(0);
	}
	const TCHAR* GetNextText()
	{
		return NULL;
	}
};

IMPLEMENT_PACKAGE(ChatDiamond);

IMPLEMENT_CLASS(ACDDiscordActor);

ACDDiscordActor::ACDDiscordActor()
{
	//Super::AActor(); // Call super's constructor.
}

void ACDDiscordActor::execTestFunction(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execTestFunction);
	P_GET_STR(S);//Get the first parameter
	P_GET_INT(I);//and the second
	P_FINISH;//you MUST call this or it will crash.

	GLog->Logf(TEXT("Hello World! S=%s,I=%i"), *S, I);//Log output and use printf format.
	//You may also use debugf(TEXT("Hello world!")) since it may be easier to remember.
	*(UBOOL*)Result = true;// Return true to UScript, this is how you return a result. You cast your result into "Result" -- whatever it may be.
	unguard;
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execTestFunction);

//#include "UnEngineWin.h"
std::shared_ptr<WObjectProperties> CowboyWindow = nullptr;
void ACDDiscordActor::execOpenNativeTestWindow(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execOpenNativeTestWindow);
	P_GET_UBOOL(bVisible);
	P_GET_OBJECT(UObject, ParentWindow);
	P_FINISH;

	UViewport* ClientViewPort = UTexture::__Client->Viewports(0); //thx mongo! (amazing this works)

	for (int i = 0; i < WWindow::_Windows.Num(); i++)
	{
		if (WWindow::_Windows(i) != nullptr && WWindow::_Windows(i)->OwnerWindow != nullptr)
			GLog->Logf(TEXT("The window name is %s and owner window is %s"), *WWindow::_Windows(i)->PersistentName, *WWindow::_Windows(i)->OwnerWindow->PersistentName);
	}

	if (CowboyWindow == nullptr)
	{
		CowboyWindow.reset(new WObjectProperties(TEXT("Cowboy's Window"), 0, TEXT("Yeehaw!"), WWindow::_Windows(0), 1));
		WWindow::_Windows.AddItem(CowboyWindow.get());
	}

	if (CowboyWindow != nullptr && CowboyWindow->hWnd != nullptr)
	{
		CowboyWindow->OpenWindow();// if  hWndParent is null is none then owner window's (GlogWindow here) hWnd is used
		CowboyWindow->Show(true);
	}

	(VOID*)Result = NULL;

	unguard;
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execOpenNativeTestWindow)

/**********************************************************************************
 *
 *      Files and Folders relevant routines
 *      May require considerations for different filesystems (read MacOS and Linux)
 *
 **********************************************************************************
 */

 /*-----------------------------------------------------------------------------
	 Global vars
 -----------------------------------------------------------------------------*/
	TArray<FString> FileList;          // File list containing desired file names
TArray<FString> FileINformation;
FString CachedFolderPath;         // Path from which the list was retrieved

void ACDDiscordActor::execCacheListOfFiles(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execCacheListOfFiles);

	P_GET_STR(Extension);
	P_GET_STR(FolderPath);
	P_FINISH;

	if (Extension == TEXT(""))
	{
		GLog->Logf(TEXT("No extension provided, returning."));
		*(INT*)Result = 0;

		return;
	}

	if (FolderPath == TEXT(""))
	{
		GLog->Logf(TEXT("No folder path provided, returning."));
		*(INT*)Result = 0;

		return;
	}

	FString TempoBase = FolderPath;

	FolderPath += Extension;
	FileList = GFileManager->FindFiles(*FolderPath, true, false);

	GLog->Logf(TEXT("Found %i files with extension %s in %s"), FileList.Num(), *Extension, *FolderPath);

	for (int i = 0; i < FileList.Num(); i++)
	{
		GLog->Logf(TEXT("Found file %s with global time %l"), *FileList(i), GFileManager->GetGlobalTime(*(TempoBase + FileList(i))));
	}

	unguard;
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execCacheListOfFiles)

void ACDDiscordActor::execGetIthFileFromCacheList(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execGetIthFileFromCacheList);

	P_GET_INT(I);
	P_FINISH;

	if (I > FileList.Num())
	{
		GLog->Logf(TEXT("Inquiry for a file number %i, greater than found files %i"), I, FileList.Num());
		*(FString*)Result = TEXT("");

		return;
	}

	*(FString*)Result = FileList(I);

	unguard;
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execGetIthFileFromCacheList)

void ACDDiscordActor::execGetGameSystemPath(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execGetIthFileFromCacheList);

	P_FINISH;

	*(FString*)Result = appBaseDir();

	unguard;
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execGetGameSystemPath)

//==================================================================================================

void ACDDiscordActor::execLoadTextureFromFileOnTheRun(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execLoadTextureFromFileOnTheRun);
	P_GET_STR(FileName);
	P_FINISH;

	//UTexture* SomeTexture = NULL;
	//ULinkerLoad* Linker;
	//Linker->Summary.Guid;

	//BeginLoad();

	FString FilePath = appBaseDir();
	FilePath += TEXT("welldone.bmp");

	//GLog->Logf(TEXT("Hmm so the file path is %s"), FilePath);

	FWindowsBitmap TestBitmap;
	UBOOL bResult = TestBitmap.LoadFile(*FilePath);

	if (!bResult)
	{
		GLog->Logf(TEXT("Failed to load the file!"));
		(void*)Result = NULL;
		return;
	}

	HDC hdc = GetDC(0);

	HBITMAP BitHandle = TestBitmap.GetBitmapHandle();

	BITMAPINFO MyBMInfo = { 0 };
	MyBMInfo.bmiHeader.biSize = sizeof(MyBMInfo.bmiHeader);

	// Get the BITMAPINFO structure from the bitmap
	if (0 == GetDIBits(hdc, BitHandle, 0, 0, NULL, &MyBMInfo, DIB_RGB_COLORS))
	{
		GLog->Logf(TEXT("Failed to load DIBits (1)"));
	}

	TCHAR* Pixels = new TCHAR[MyBMInfo.bmiHeader.biSizeImage];

	// Better do this here - the original bitmap might have BI_BITFILEDS, which makes it
	// necessary to read the color table - you might not want this.
	MyBMInfo.bmiHeader.biCompression = BI_RGB;

	// get the actual bitmap buffer
	if (0 == GetDIBits(hdc, BitHandle, 0, MyBMInfo.bmiHeader.biHeight, (LPVOID)Pixels, &MyBMInfo, DIB_RGB_COLORS))
	{
		GLog->Logf(TEXT("Failed to load DIBits (2)"));
	}

	UTexture* TestTexture = new UTexture();

	GLog->Logf(TEXT("Attempting to import pixels to texture %s"), Pixels);
	//TestTexture->Import(Pixels, Pixels + MyBMInfo.bmiHeader.biSizeImage, NULL);

	//TestTexture->Destroy();

	*(UTexture*)Result = *TestTexture;
	//TestBitmap.SizeX;

	//ULinkerLoad* Linker = GetPackageLinker(NULL, *FilePath, LOAD_None, NULL, NULL);

	//UTexture TestBitMap;

	//TestBitMap.Load

	// No linker => file not present or access denied?
	/*if (1)//!Linker)
	{
		*(BYTE*)Result = NULL;
		GLog->Logf(TEXT("File is %s"));
		EndLoad();
		return;
	}*/

	//SomeTexture = LoadObject<UTexture>(NULL, NULL, *Linker->Filename, LOAD_NoFail, NULL);

	/*
	if (SomeTexture)
	{
		GLog->Logf(TEXT("ChatDiamond: Successfully loaded welldone.bmp"));
		*(UTexture*)Result = *SomeTexture;
		EndLoad();
		return;
	}
	else
	{
		GLog->Logf(TEXT("ChatDiamond: couldn't load welldone.bmp, well!"));
		(void*)Result = NULL;
		EndLoad();
		return;
	}*/

	//EndLoad();
	unguard;
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execLoadTextureFromFileOnTheRun);

void ACDDiscordActor::execSpitIpFromChatString(FFrame& Stack, RESULT_DECL)
{
	guard(ACDDiscordActor::execSpitIpFromChatString);
	P_GET_STR(Message);
	P_GET_INT_REF(IPCategory);
	P_FINISH;

	std::smatch Match;

	// The nice way out, from game and web server mix, seems to make an assumption that, in context of UT, the gameserver IP
	// be given by complete port number.

	// https://github.com/ravimohan1991/ChatDiamond/issues/1#issuecomment-1356906185
	std::regex GameIPMould("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\:\\d{1,4}");
	std::regex WebIPMould("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}");

	std::wstring WString(*Message);
	std::string SampleString(WString.begin(), WString.end());

	std::string IPString;

	// Look for game IP
	if (std::regex_search(SampleString, Match, GameIPMould))
	{
		for (auto Tempo : Match)
		{
			IPString = Tempo.str();
			break;
		}
	}

	if (!IPString.empty())
	{
		std::wstring WideIPString = std::wstring(IPString.begin(), IPString.end());
		*IPCategory = 0;
		*(FString*)Result = WideIPString.c_str();
		return;
	}

	// Look for game IP
	if (std::regex_search(SampleString, Match, WebIPMould))
	{
		for (auto Tempo : Match)
		{
			IPString = Tempo.str();
			break;
		}
	}

	if (!IPString.empty())
	{
		std::wstring WideIPString = std::wstring(IPString.begin(), IPString.end());
		*IPCategory = 1;
		*(FString*)Result = WideIPString.c_str();
		return;
	}

	std::wstring WideIPString = std::wstring(IPString.begin(), IPString.end());
	*IPCategory = 2;
	*(FString*)Result = WideIPString.c_str();

	unguard;
}
IMPLEMENT_FUNCTION(ACDDiscordActor, -1, execSpitIpFromChatString);

/*
void SomeFunction()
{
	std::string SampleString("There's no place like 127.0.0.1 and what is 192.168.1.1\n");
	std::smatch Match;
	std::regex IPMould("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}");

	while (std::regex_search(SampleString, Match, IPMould))
	{
		for (auto x : Match)
		{
			std::cout << x << " ";
		}

		std::cout << std::endl;

		SampleString = Match.suffix().str();
	}

	return 0;
}
*/

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