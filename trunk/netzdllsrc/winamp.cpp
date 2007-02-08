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
#include "wa_ipc.h" // winamp sdk header

// winamp ipc by Nonoo
__declspec( dllexport ) int __stdcall winamp( HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause )
{
	HWND hWinamp = FindWindow( "Winamp v1.x", NULL );

	// ha nem fut a winamp
	if( hWinamp == 0 )
	{
		sprintf( data, "0" );
		return 3;
	}

	// winamp szol?
	if( _stricmp( data, "isplaying" ) == 0 )
	{
		int res = SendMessage( hWinamp, WM_WA_IPC, 0, IPC_ISPLAYING );
		if( res != 1 )
		{
			sprintf( data, "0" );
		}
		else
		{
			sprintf( data, "1" );
		}
		return 3;
	}

	// jelenlegi pozicio masodpercben
	if( _stricmp( data, "GetCurrentWinampSongElapsedTime" ) == 0 )
	{
		int res = SendMessage( hWinamp, WM_WA_IPC, 0, IPC_GETOUTPUTTIME );
		sprintf( data, "%d", res/1000 );
		return 3;
	}

	// jelenlegi szam cime
	if( _stricmp( data, "GetCurrentWinampSong" ) == 0 )
	{
		/*		char tmp[MIRCDATASIZE];
		int from=0, to;
		to = GetWindowText( hWinamp, tmp, MIRCDATASIZE);

		// ha valamiert nem lehet lekerni a window captiont
		if( to == 0 )
		{
		sprintf( data, "-1" );
		return 3;
		}

		// cim formaja: #. szamcim - Winamp
		// le kell vagni a '#.'-t es a '- Winamp'-ot
		while( tmp[from] != ' ' )
		{
		from++;
		}
		from++;
		while( tmp[to] != '-' )
		{
		to--;
		}
		to--;

		memcpy( data, tmp+from, to-from );
		data[to-from] = 0;

		return 3;
		*/
		DWORD dwProcID;
		GetWindowThreadProcessId( hWinamp, &dwProcID );

		HANDLE hWinamp2 = OpenProcess( PROCESS_ALL_ACCESS, false, dwProcID );

		int nListPos = SendMessage( hWinamp, WM_WA_IPC, 0, IPC_GETLISTPOS );
		// lekerjuk a winamptol a pointert, ahol a jelenleg megnyitott zene cime tarolodik mint char tomb
		LPCVOID res = (LPCVOID)SendMessage( hWinamp, WM_WA_IPC, nListPos, IPC_GETPLAYLISTTITLE );

		ReadProcessMemory( hWinamp2, res, data, MIRCDATASIZE, NULL );

		CloseHandle( hWinamp2 );

		return 3;
	}

	// jelenlegi szam bitrataja
	if( _stricmp( data, "GetCurrentWinampSongKbps" ) == 0 )
	{
		int res = SendMessage( hWinamp, WM_WA_IPC, 1, IPC_GETINFO );
		sprintf( data, "%d", res );
		return 3;
	}

	// jelenlegi szam mintavetelezesi frekije
	if( _stricmp( data, "GetCurrentWinampSongKHz" ) == 0 )
	{
		int res = SendMessage( hWinamp, WM_WA_IPC, 0, IPC_GETINFO );
		sprintf( data, "%d", res );
		return 3;
	}

	// jelenlegi szam hossza masodpercben
	if( _stricmp( data, "GetCurrentWinampSongTotalTime" ) == 0 )
	{
		int res = SendMessage( hWinamp, WM_WA_IPC, 1, IPC_GETOUTPUTTIME );
		sprintf( data, "%d", res );
		return 3;
	}

	// jelenlegi szam csatornainak szama
	if( _stricmp( data, "GetCurrentWinampSongChannels" ) == 0 )
	{
		int res = SendMessage( hWinamp, WM_WA_IPC, 2, IPC_GETINFO );
		sprintf( data, "%d", res );
		return 3;
	}

	// jelenlegi szam fajlneve
	if( _stricmp( data, "GetCurrentWinampSongFilename" ) == 0 )
	{
		DWORD dwProcID;
		GetWindowThreadProcessId( hWinamp, &dwProcID );

		HANDLE hWinamp2 = OpenProcess( PROCESS_ALL_ACCESS, false, dwProcID );

		int nListPos = SendMessage( hWinamp, WM_WA_IPC, 0, IPC_GETLISTPOS );
		// lekerjuk a winamptol a pointert, ahol a jelenleg megnyitott fajl path-ja tarolodik mint char tomb
		LPCVOID res = (LPCVOID)SendMessage( hWinamp, WM_WA_IPC, nListPos, IPC_GETPLAYLISTFILE );

		ReadProcessMemory( hWinamp2, res, data, MIRCDATASIZE, NULL );

		CloseHandle( hWinamp2 );

		return 3;
	}

	sprintf( data, "0" );
	return 3;
}
