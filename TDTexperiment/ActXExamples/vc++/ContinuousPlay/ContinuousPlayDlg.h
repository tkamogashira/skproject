// ContinuousPlayDlg.h : header file
//
//{{AFX_INCLUDES()
#include "rpcox.h"
//}}AFX_INCLUDES

#if !defined(AFX_CONTINUOUSPLAYDLG_H__03102F07_F2F9_4C9D_9096_2A0AEC9E62D8__INCLUDED_)
#define AFX_CONTINUOUSPLAYDLG_H__03102F07_F2F9_4C9D_9096_2A0AEC9E62D8__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <math.h>

/////////////////////////////////////////////////////////////////////////////
// CContinuousPlayDlg dialog

class CContinuousPlayDlg : public CDialog
{
// Construction
public:
	CContinuousPlayDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CContinuousPlayDlg)
	enum { IDD = IDD_CONTINUOUSPLAY_DIALOG };
	CButton	m_make_button;
	CRPcoX	m_rp2;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CContinuousPlayDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CContinuousPlayDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnMakeClick();
	afx_msg void MakeTones();
	afx_msg void SendTones(int bufpts, float *tone1, float *tone2);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CONTINUOUSPLAYDLG_H__03102F07_F2F9_4C9D_9096_2A0AEC9E62D8__INCLUDED_)
