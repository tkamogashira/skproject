// BandLimitedNoise.h : main header file for the BANDLIMITEDNOISE application
//

#if !defined(AFX_BANDLIMITEDNOISE_H__195C0670_998A_498A_8E2E_85DAD308FDC6__INCLUDED_)
#define AFX_BANDLIMITEDNOISE_H__195C0670_998A_498A_8E2E_85DAD308FDC6__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CBandLimitedNoiseApp:
// See BandLimitedNoise.cpp for the implementation of this class
//

class CBandLimitedNoiseApp : public CWinApp
{
public:
	CBandLimitedNoiseApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CBandLimitedNoiseApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CBandLimitedNoiseApp)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_BANDLIMITEDNOISE_H__195C0670_998A_498A_8E2E_85DAD308FDC6__INCLUDED_)
