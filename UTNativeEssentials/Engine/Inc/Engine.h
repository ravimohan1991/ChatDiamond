/*=============================================================================
	Engine.h: Unreal engine public header file.
	Copyright 1997-1999 Epic Games, Inc. All Rights Reserved.
=============================================================================*/

#ifndef _INC_ENGINE
#define _INC_ENGINE

/*----------------------------------------------------------------------------
	API.
----------------------------------------------------------------------------*/

#ifndef ENGINE_API
	#define ENGINE_API DLL_IMPORT
#endif

/*-----------------------------------------------------------------------------
	Dependencies.
-----------------------------------------------------------------------------*/

#include "Core.h"

/*-----------------------------------------------------------------------------
	Engine compiler specific includes.
-----------------------------------------------------------------------------*/

#if __GNUG__
	#include "UnEngineGnuG.h"
#endif

/*-----------------------------------------------------------------------------
	Engine public includes.
-----------------------------------------------------------------------------*/

#include "UnObj.h"				// Standard object definitions.
#include "UnPrim.h"				// Primitive class.
#include "UnModel.h"			// Model class.
#include "UnTexFmt.h"
#include "UnColor.h"
#include "UnTexComp.h"
#include "UnTex.h"				// Texture and palette.
#include "UnAnim.h"
#include "EngineClasses.h"		// All actor classes.
#include "UnReach.h"			// Reach specs.
#include "UnURL.h"				// Uniform resource locators.
#include "UnLevel.h"			// Level object.
#include "UnIn.h"				// Input system.
#include "UnPlayer.h"			// Player class.
#include "UnEngine.h"			// Unreal engine.
#include "UnGame.h"				// Unreal game engine.
#include "UnCamera.h"			// Viewport subsystem.
#include "UnMesh.h"				// Mesh objects.
#include "UnSkeletalMesh.h"		// Skeletal model objects.
#include "UnActor.h"			// Actor inlines.
#include "UnAudio.h"			// Audio code.
#include "UnDynBsp.h"			// Dynamic Bsp objects.
#include "UnScrTex.h"			// Scripted textures.
#include "UnRenderIterator.h"	// Enhanced Actor Render Interface
#include "UnRenderIteratorSupport.h"
#include "UnFieldCache.h"		// Cached UField iterator
#include "UnRender.h"
#include "UnNet.h"
#include "UnCon.h"

/*-----------------------------------------------------------------------------
	Global variables.
-----------------------------------------------------------------------------*/

ENGINE_API extern class FMemStack			GEngineMem;
ENGINE_API extern class FMemCache			GCache;
ENGINE_API extern INT						GDynamicFontCounter;
ENGINE_API extern TArray<FDynamicFontInfo*> GDynamicFonts;

/*-----------------------------------------------------------------------------
	The End.
-----------------------------------------------------------------------------*/
#endif
