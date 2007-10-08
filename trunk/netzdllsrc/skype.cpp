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
//
//
//  skype.cpp is based on msgapitest.cpp, a Skype API example source code file.
//  Original license:
//
//  Copyright (c) 2004-2006, Skype Limited.
//  All rights reserved.
// 
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//
//    * Redistributions of source code must retain the above copyright
//      notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above
//      copyright notice, this list of conditions and the following
//      disclaimer in the documentation and/or other materials provided
//      with the distribution.
//    * Neither the name of the Skype Limited nor the names of its
//      contributors may be used to endorse or promote products derived
//      from this software without specific prior written permission.
//  
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
//  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
//  COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
//  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
//  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
//  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//

#include "stdafx.h"

#define SKYPE_WAIT_TIMEOUT 5000

HWND		g_hMainWindowHandle = NULL;
HINSTANCE	g_hProcessHandle = NULL;
char		g_szWindowClassName[128];
UINT		g_nMsgID_SkypeControlAPIAttach = 0;
UINT		g_nMsgID_SkypeControlAPIDiscover = 0;
HWND		g_hSkypeAPIWindowHandle = NULL;

bool		g_fPendingAuthorization = false;
bool		g_fAttachRefused = false;
bool		g_fSkypeNotAvailable = false;

enum {
	SKYPECONTROLAPI_ATTACH_SUCCESS = 0,					// Client is successfully attached and API window handle can be found in wParam parameter
	SKYPECONTROLAPI_ATTACH_PENDING_AUTHORIZATION = 1,	// Skype has acknowledged connection request and is waiting for confirmation from the user.
	// The client is not yet attached and should wait for SKYPECONTROLAPI_ATTACH_SUCCESS message
	SKYPECONTROLAPI_ATTACH_REFUSED = 2,					// User has explicitly denied access to client
	SKYPECONTROLAPI_ATTACH_NOT_AVAILABLE = 3,			// API is not available at the moment. For example, this happens when no user is currently logged in.
	// Client should wait for SKYPECONTROLAPI_ATTACH_API_AVAILABLE broadcast before making any further connection attempts.
	SKYPECONTROLAPI_ATTACH_API_AVAILABLE = 0x8001
};

static LRESULT APIENTRY SkypeAPI_Windows_WindowProc( HWND hWindow, UINT uiMessage, WPARAM uiParam, LPARAM ulParam )
{
	LRESULT lReturnCode = 0;

	switch( uiMessage )
	{
		case WM_COPYDATA:
			if( g_hSkypeAPIWindowHandle == (HWND)uiParam )
			{
				//PCOPYDATASTRUCT poCopyData = (PCOPYDATASTRUCT)ulParam;
				//printf( "Message from Skype(%u): %.*s\n", poCopyData->dwData, poCopyData->cbData, poCopyData->lpData);
				lReturnCode = 1;
			}
			break;
		default:
			if( uiMessage == g_nMsgID_SkypeControlAPIAttach )
			{
				switch( ulParam )
				{
					case SKYPECONTROLAPI_ATTACH_SUCCESS:
						// connected!
						g_hSkypeAPIWindowHandle = (HWND)uiParam;
						break;
					case SKYPECONTROLAPI_ATTACH_PENDING_AUTHORIZATION:
						g_fPendingAuthorization = true;
						break;
					case SKYPECONTROLAPI_ATTACH_REFUSED:
						g_fAttachRefused = true;
						break;
					case SKYPECONTROLAPI_ATTACH_NOT_AVAILABLE:
						g_fSkypeNotAvailable = true;
						break;
					case SKYPECONTROLAPI_ATTACH_API_AVAILABLE:
						// skype has been started
						break;
				}
				lReturnCode = 1;
				break;
			}
			return DefWindowProc( hWindow, uiMessage, uiParam, ulParam );
	}
	return lReturnCode;
}

bool skypeCreateWindowClass()
{
	unsigned char* paucUUIDString;
	RPC_STATUS lUUIDResult;
	bool fReturnStatus;
	UUID oUUID;

	if( g_hProcessHandle != NULL )
	{
		// we already have a window class registered
		return true;
	}

	fReturnStatus = false;
	lUUIDResult = UuidCreate( &oUUID );
	g_hProcessHandle = (HINSTANCE)OpenProcess( PROCESS_DUP_HANDLE, FALSE, GetCurrentProcessId() );
	if( g_hProcessHandle != NULL && ( lUUIDResult == RPC_S_OK || lUUIDResult == RPC_S_UUID_LOCAL_ONLY ) )
	{
		if( UuidToString( &oUUID, &paucUUIDString ) == RPC_S_OK )
		{
			WNDCLASS oWindowClass;

			strcpy( g_szWindowClassName, "netZScriptPro-");
			strcat( g_szWindowClassName, (char *)paucUUIDString );

			oWindowClass.style = CS_HREDRAW|CS_VREDRAW|CS_DBLCLKS;
			oWindowClass.lpfnWndProc = (WNDPROC)&SkypeAPI_Windows_WindowProc;
			oWindowClass.cbClsExtra = 0;
			oWindowClass.cbWndExtra = 0;
			oWindowClass.hInstance = g_hProcessHandle;
			oWindowClass.hIcon = NULL;
			oWindowClass.hCursor = NULL;
			oWindowClass.hbrBackground = NULL;
			oWindowClass.lpszMenuName = NULL;
			oWindowClass.lpszClassName = g_szWindowClassName;

			if( RegisterClass( &oWindowClass ) != 0 )
			{
				fReturnStatus = true;
			}

			RpcStringFree( &paucUUIDString );
		}
	}

	if( fReturnStatus == false )
	{
		CloseHandle( g_hProcessHandle );
		g_hProcessHandle = NULL;
	}
	return( fReturnStatus );
}

bool skypeCreateMainWindow()
{
	if( g_hMainWindowHandle != NULL )
	{
		// we already have a window initialised
		return true;
	}

	g_hMainWindowHandle = CreateWindowEx( WS_EX_APPWINDOW|WS_EX_WINDOWEDGE, g_szWindowClassName, "", WS_BORDER|WS_SYSMENU|WS_MINIMIZEBOX,
		CW_USEDEFAULT, CW_USEDEFAULT, 128, 128, NULL, 0, g_hProcessHandle, 0 );
	return ( g_hMainWindowHandle != NULL ? true : false );
}

void skypeProcessMessages()
{
	MSG oMessage;
	while( PeekMessage( &oMessage, 0, 0, 0, PM_REMOVE ) != 0 )
	{
		TranslateMessage( &oMessage );
		DispatchMessage( &oMessage );
	}
}

bool skypeConnect()
{
	g_nMsgID_SkypeControlAPIAttach = RegisterWindowMessage( "SkypeControlAPIAttach" );
	g_nMsgID_SkypeControlAPIDiscover = RegisterWindowMessage( "SkypeControlAPIDiscover" );

	g_hSkypeAPIWindowHandle = NULL;
	g_fPendingAuthorization = false;
	g_fAttachRefused = false;
	g_fSkypeNotAvailable = false;

	if( ( g_nMsgID_SkypeControlAPIAttach == 0 ) || ( g_nMsgID_SkypeControlAPIDiscover == 0 ) )
	{
		return false;
	}

	if( !skypeCreateWindowClass() )
	{
		return false;
	}

	if( !skypeCreateMainWindow() )
	{
		return false;
	}

	if( SendMessage( HWND_BROADCAST, g_nMsgID_SkypeControlAPIDiscover, (WPARAM)g_hMainWindowHandle, 0) == 0 )
	{
		return false;
	}

	// waiting for a reply from skype
	DWORD dwCurrTick = GetTickCount();
	while( ( GetTickCount() < dwCurrTick + SKYPE_WAIT_TIMEOUT ) && ( g_hSkypeAPIWindowHandle == NULL ) && ( !g_fAttachRefused ) && ( !g_fSkypeNotAvailable ) )
	{
		// waiting for user to authorize
		if( g_fPendingAuthorization )
		{
			dwCurrTick = GetTickCount();
		}
		skypeProcessMessages();
		Sleep( 10 );
	}
	if( g_hSkypeAPIWindowHandle == NULL )
	{
		return false;
	}
	else
	{
		return true;
	}
}

__declspec( dllexport ) int __stdcall skype( HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause )
{
	if( _stricmp( data, "isskyperunning" ) == 0 )
	{
		if( !skypeConnect() )
		{
			sprintf( data, "-1" );
			if( g_fAttachRefused )
			{
				sprintf( data, "-2" );
			}
			if( g_fSkypeNotAvailable )
			{
				sprintf( data, "-3" );
			}
		}
		else
		{
			sprintf( data, "1" );
		}
		return 3;
	}

	if( _stricmp( data, "disconnect" ) == 0 )
	{
		// destroying main window
		if( g_hMainWindowHandle != NULL )
		{
			DestroyWindow( g_hMainWindowHandle );
			g_hMainWindowHandle = NULL;
		}

		// destroying window class
		if( g_hProcessHandle != NULL )
		{
			UnregisterClass( g_szWindowClassName, g_hProcessHandle );
			CloseHandle( g_hProcessHandle );
			g_hProcessHandle = NULL;
		}

		g_hSkypeAPIWindowHandle = NULL;

		sprintf( data, "1" );
		return 3;
	}

	sprintf( data, "0" );
	return 3;
}

__declspec( dllexport ) int __stdcall skypesendmsg( HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause )
{
	if( !skypeConnect() )
	{
		sprintf( data, "-1" );
		if( g_fAttachRefused )
		{
			sprintf( data, "-2" );
		}
		if( g_fSkypeNotAvailable )
		{
			sprintf( data, "-3" );
		}
		return 3;
	}

	char szMsg[MIRCDATASIZE];
	strcpy( szMsg, data );

	sprintf( data, "-1" );

	COPYDATASTRUCT oCopyData;
	oCopyData.dwData = 0;
	oCopyData.lpData = szMsg;
	oCopyData.cbData = strlen( szMsg ) + 1;
	if( oCopyData.cbData != 1 )
	{
		if( SendMessage( g_hSkypeAPIWindowHandle, WM_COPYDATA, (WPARAM)g_hMainWindowHandle, (LPARAM)&oCopyData ) )
		{
			sprintf( data, "1" );
		}
	}
	return 3;
}
