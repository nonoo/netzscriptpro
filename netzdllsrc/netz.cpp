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
#include "resource.h"

extern HWND g_hMIRC;

// beepeles by Face
__declspec( dllexport ) int __stdcall beep( HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause )
{
	if ( !strlen( data ) ) {
		MessageBox( NULL, "Need more parameters: <freq> <duration> <beeps> <sleep>", NULL, MB_OK);
		return 0;
	}
	int freq=0, duration=0, beeps=0, sleep=0;
	sscanf( data, "%i %i %i %i", &freq, &duration, &beeps, &sleep );

	for ( ;beeps --> 0; )
	{
		Beep( freq, duration );
		_sleep( sleep );
	}

	return 1;
}

// seticon, mirc ikonjanak megvaltoztatasara by Face
__declspec( dllexport ) int __stdcall seticon( HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause )
{
	SendMessage( g_hMIRC, WM_SETICON, ICON_SMALL, (LPARAM) LoadIcon( GetModuleHandle( "netz.dll" ), MAKEINTRESOURCE( IDI_ICON1 ) ) );
	return 1;
}

// title, mirc ablak titlejenek megvaltoztatasara by Face
__declspec( dllexport ) int __stdcall title( HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause )
{
	if ( !strlen(data) )
	{
		MessageBox( NULL, "Need more parameter: <title>", NULL, MB_OK);
		return 0;
	}

	SetWindowText( g_hMIRC, data );

	return 1;
}

// idle, visszateresi erteke hogy hany masodperce nem nyult a felhasznalo az egerhez, billentyuzethez by Face
__declspec( dllexport ) int __stdcall idle( HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause )
{
	LASTINPUTINFO l;
	memset( &l, 0, sizeof(l) );
	l.cbSize = sizeof( LASTINPUTINFO );

	if ( !GetLastInputInfo( &l ) ) {
		sprintf( data, "-1" );
		return 3;
	};

	sprintf( data, "%i", GetTickCount() - l.dwTime );

	return 3;
}

// uuencode
__declspec( dllexport ) int __stdcall enkod( HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause )
{
	char out[MIRCDATASIZE];

	if( strlen( data ) > 255 )
	{
		MessageBox( NULL, "enkod: Az elkódolandó szöveg hossza max. 255 karakter lehet!", "Hiba", MB_ICONERROR | MB_OK );
		return 0;
	}

	if( !strlen( data ) )
	{
		return 1;
	}

	int insize = strlen( data );

	memset( data+insize, 32, MIRCDATASIZE-insize );

	out[0] = (unsigned char)insize + 0x20;

	int i,j;

	for( i=1, j=0; j < insize; j += 3, i += 4 )
	{
		char A = data[j];
		char B = data[j+1];
		char C = data[j+2];

		out[i]   = 0x20 + (( A >> 2                    ) & 0x3F);
		out[i+1] = 0x20 + (((A << 4) | ((B >> 4) & 0xF)) & 0x3F);
		out[i+2] = 0x20 + (((B << 2) | ((C >> 6) & 0x3)) & 0x3F);
		out[i+3] = 0x20 + (( C                         ) & 0x3F);
	}

	out[i] = 0;

	memcpy( data, out, i+1 );

	return 3;
}

// uudecode
__declspec( dllexport ) int __stdcall dekod( HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause )
{
	char out[MIRCDATASIZE];

	if( strlen( data ) < 1 )
	{
		return 1;
	}

	int i,j;
	int insize = data[0] - 0x20;

	for( i=1, j=0; j < insize; j += 3, i += 4 )
	{
		char b0 = data[i];
		char b1 = data[i+1];
		char b2 = data[i+2];
		char b3 = data[i+3];

		out[j]   = (b0 - 0x20) << 2 | (b1 - 0x20) >> 4;
		out[j+1] = ((b1 - 0x20) << 4 & 0xFF) | (b2 - 0x20) >> 2;
		out[j+2] = ((b2 - 0x20) << 6 & 0xFF) | (b3 - 0x20);
	}

	out[insize] = 0;

	memcpy( data, out, insize+1 );

	return 3;
}
