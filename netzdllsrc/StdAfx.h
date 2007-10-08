#if !defined(AFX_STDAFX_H__A9876626_9094_4B98_A388_F42011B5820B__INCLUDED_)
#define AFX_STDAFX_H__A9876626_9094_4B98_A388_F42011B5820B__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#define WIN32_LEAN_AND_MEAN		// Exclude rarely-used stuff from Windows headers

#define _WIN32_WINNT 0x501

#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <ShellAPI.h>

// skype.cpp
#include <rpc.h>
#include <rpcdce.h>

#define SAFE_DELETE(p)       { if(p) { delete (p);     (p)=NULL; } }
#define SAFE_DELETE_ARRAY(p) { if(p) { delete[] (p);   (p)=NULL; } }
#define SAFE_RELEASE(p)      { if(p) { (p)->Release(); (p)=NULL; } }

#define MIRCDATASIZE 900 // ennyi byteot tud tarolni a mirc dll hivasanak data tombje

#endif // !defined(AFX_STDAFX_H__A9876626_9094_4B98_A388_F42011B5820B__INCLUDED_)
