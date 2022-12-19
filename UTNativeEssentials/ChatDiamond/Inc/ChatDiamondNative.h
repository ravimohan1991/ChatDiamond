/*
 *   -----------------------
 *  |  ChatDiamondNative.cpp
 *   -----------------------
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

#pragma once

#include "Core.h"
#include "Engine.h"

#include "ActorNativeClass.h"

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