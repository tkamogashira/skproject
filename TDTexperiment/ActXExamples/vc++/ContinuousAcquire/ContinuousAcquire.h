// ContinuousAcquire.h : main header file for the CONTINUOUSACQUIRE application
//

#if !defined(AFX_CONTINUOUSACQUIRE_H__4C55ED92_7A43_4638_8143_54027647059E__INCLUDED_)
#define AFX_CONTINUOUSACQUIRE_H__4C55ED92_7A43_4638_8143_54027647059E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CContinuousAcquireApp:
// See ContinuousAcquire.cpp for the implementation of this class
//

class CContinuousAcquireApp : public CWinApp
{
public:
	CContinuousAcquireApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CContinuousAcquireApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CContinuousAcquireApp)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CONTINUOUSACQUIRE_H__4C55ED92_7A43_4638_8143_54027647059E__INCLUDED_)
