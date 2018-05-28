// ContinuousPlay.h : main header file for the CONTINUOUSPLAY application
//

#if !defined(AFX_CONTINUOUSPLAY_H__9F4C9C5F_EFBC_4780_AB8E_C5A218937EF1__INCLUDED_)
#define AFX_CONTINUOUSPLAY_H__9F4C9C5F_EFBC_4780_AB8E_C5A218937EF1__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CContinuousPlayApp:
// See ContinuousPlay.cpp for the implementation of this class
//

class CContinuousPlayApp : public CWinApp
{
public:
	CContinuousPlayApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CContinuousPlayApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CContinuousPlayApp)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CONTINUOUSPLAY_H__9F4C9C5F_EFBC_4780_AB8E_C5A218937EF1__INCLUDED_)
