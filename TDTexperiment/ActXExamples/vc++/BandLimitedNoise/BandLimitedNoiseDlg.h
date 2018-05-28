// BandLimitedNoiseDlg.h : header file
//
//{{AFX_INCLUDES()
#include "rpcox.h"
//}}AFX_INCLUDES

#if !defined(AFX_BANDLIMITEDNOISEDLG_H__94C12354_720C_4FBA_8DF4_A4F634473D8C__INCLUDED_)
#define AFX_BANDLIMITEDNOISEDLG_H__94C12354_720C_4FBA_8DF4_A4F634473D8C__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CBandLimitedNoiseDlg dialog

class CBandLimitedNoiseDlg : public CDialog
{
// Construction
public:
	CBandLimitedNoiseDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CBandLimitedNoiseDlg)
	enum { IDD = IDD_BANDLIMITEDNOISE_DIALOG };
	CButton	m_exit;
	CButton	m_stop_button;
	CButton	m_start_button;
	CButton	m_load_button;
	CString	m_centerfreq_text;
	CString	m_amplitude_text;
	CString	m_bandwidth_text;
	CString	m_cycusage_text;
	CString	m_gain_text;
	CString	m_samplerate_text;
	CRPcoX	m_rp2;
	BOOL	m_check_clipped;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CBandLimitedNoiseDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CBandLimitedNoiseDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnStartClick();
	afx_msg void OnStopClick();
	afx_msg void OnLoadClick();
	afx_msg void OnExitClick();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_BANDLIMITEDNOISEDLG_H__94C12354_720C_4FBA_8DF4_A4F634473D8C__INCLUDED_)
