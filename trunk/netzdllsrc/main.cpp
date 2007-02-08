//  This file is part of netZ Script Pro.
//
//  netz.dll (c) Face, Nonoo 2005-2007
//
//  netZ Script Pro is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  netZ Script Pro is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with netZ Script Pro; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

#include "stdafx.h"

HWND g_hMIRC;

// loaddll hogy a dll betoltodve maradjon a mircben
struct LOADINFO
{
	DWORD  mVersion;
	HWND   mHwnd;
	BOOL   mKeep;
};

void __stdcall LoadDll( struct LOADINFO *load )
{
	g_hMIRC = load->mHwnd;
	load->mKeep = FALSE;
}

int __stdcall UnloadDll( int mTimeout )
{
	return 1;
}
