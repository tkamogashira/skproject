// ContinuousAcquireDlg.h : header file
//
//{{AFX_INCLUDES()
#include "rpcox.h"
//}}AFX_INCLUDES

#if !defined(AFX_CONTINUOUSACQUIREDLG_H__6A241053_C798_42A5_94B0_8904F2C4CAAD__INCLUDED_)
#define AFX_CONTINUOUSACQUIREDLG_H__6A241053_C798_42A5_94B0_8904F2C4CAAD__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


#include <fstream>
using namespace std;

/////////////////////////////////////////////////////////////////////////////
// CContinuousAcquireDlg dialog

class CContinuousAcquireDlg : public CDialog
{
// Construction
public:
	CContinuousAcquireDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CContinuousAcquireDlg)
	enum { IDD = IDD_CONTINUOUSACQUIRE_DIALOG };
	CButton	m_exit_button;
	CButton	m_load_button;
	CButton	m_stop_button;
	CButton	m_start_button;
	CString	m_samples_text;
	CRPcoX	m_rp2;
	CString	m_index_text;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CContinuousAcquireDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	double *time;
	ofstream fout;
	bool acquire, high;
	unsigned int samples_acquired;
	float curindex;
	float *data;

	// Generated message map functions
	//{{AFX_MSG(CContinuousAcquireDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg int StartRP2();
	afx_msg void WriteToFile(float *data, int points);
	afx_msg void OnLoadClick();
	afx_msg void OnStartClick();
	afx_msg void OnStopClick();
	afx_msg void OnExitClick();
	afx_msg void OnTimer(UINT nIDEvent);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CONTINUOUSACQUIREDLG_H__6A241053_C798_42A5_94B0_8904F2C4CAAD__INCLUDED_)
