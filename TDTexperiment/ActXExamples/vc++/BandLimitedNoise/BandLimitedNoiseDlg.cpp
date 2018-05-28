// BandLimitedNoiseDlg.cpp : implementation file
//

#include "stdafx.h"
#include "BandLimitedNoise.h"
#include "BandLimitedNoiseDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CBandLimitedNoiseDlg dialog

CBandLimitedNoiseDlg::CBandLimitedNoiseDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CBandLimitedNoiseDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CBandLimitedNoiseDlg)
	m_centerfreq_text = _T("");
	m_amplitude_text = _T("");
	m_bandwidth_text = _T("");
	m_cycusage_text = _T("");
	m_gain_text = _T("");
	m_samplerate_text = _T("");
	m_check_clipped = FALSE;
	//}}AFX_DATA_INIT
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CBandLimitedNoiseDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CBandLimitedNoiseDlg)
	DDX_Control(pDX, BUTTON_EXIT, m_exit);
	DDX_Control(pDX, BUTTON_STOP, m_stop_button);
	DDX_Control(pDX, BUTTON_START, m_start_button);
	DDX_Control(pDX, BUTTON_LOAD, m_load_button);
	DDX_Text(pDX, EDIT_CENTERFREQ, m_centerfreq_text);
	DDX_Text(pDX, EDIT_AMPLITUDE, m_amplitude_text);
	DDX_Text(pDX, EDIT_BANDWIDTH, m_bandwidth_text);
	DDX_Text(pDX, EDIT_CYCUSAGE, m_cycusage_text);
	DDX_Text(pDX, EDIT_GAIN, m_gain_text);
	DDX_Text(pDX, EDIT_SAMPLERATE, m_samplerate_text);
	DDX_Control(pDX, IDC_X1, m_rp2);
	DDX_Check(pDX, CHECK_CLIPPED, m_check_clipped);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CBandLimitedNoiseDlg, CDialog)
	//{{AFX_MSG_MAP(CBandLimitedNoiseDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(BUTTON_START, OnStartClick)
	ON_BN_CLICKED(BUTTON_STOP, OnStopClick)
	ON_BN_CLICKED(BUTTON_LOAD, OnLoadClick)
	ON_BN_CLICKED(BUTTON_EXIT, OnExitClick)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CBandLimitedNoiseDlg message handlers

BOOL CBandLimitedNoiseDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// set default values for each field
	m_centerfreq_text = "2000";
	m_gain_text = "6";
	m_bandwidth_text = "100";
	m_amplitude_text = "1.0";
	m_samplerate_text = "0";
	m_cycusage_text = "0";
	m_check_clipped = FALSE;
	UpdateData(FALSE);

	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CBandLimitedNoiseDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CBandLimitedNoiseDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

HCURSOR CBandLimitedNoiseDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}


void CBandLimitedNoiseDlg::OnLoadClick() 
{
	if (m_rp2.ConnectRP2("GB", 1) ==0)
		if (m_rp2.ConnectRP2("USB", 1) == 0) {
			AfxMessageBox("Error connecting to RP2");
			return;
		}

	m_rp2.ClearCOF();

	if (m_rp2.LoadCOF("C:\\TDT\\ActiveX\\ActXExamples\\RP_files\\Band_Limited_Noise.rcx") == 0) {
		AfxMessageBox("Error loading .rcx file");
		return;
	}
	
	// enable start button, disable stop button
	m_start_button.EnableWindow(TRUE);
	m_stop_button.EnableWindow(FALSE);
}

void sleep(unsigned int mseconds)
{
    clock_t goal = mseconds + clock();
    while (goal > clock());
}

void CBandLimitedNoiseDlg::OnStartClick() 
{
	// set parameter values
	UpdateData(TRUE);
	m_rp2.SetTagVal("Amp", (float)atof(m_amplitude_text));
	m_rp2.SetTagVal("Freq", (float)atof(m_centerfreq_text));
	m_rp2.SetTagVal("BW", (float)atof(m_bandwidth_text));
	m_rp2.SetTagVal("Gain", (float)atof(m_gain_text));
	m_rp2.SetTagVal("Enable", 1);

	m_rp2.Run();

	sleep(250);
	m_rp2.SetTagVal("Enable", 0);

	long status = m_rp2.GetStatus();
	if (!(status && 4)) {
		AfxMessageBox("Error running circuit");
		m_rp2.Halt();
	} else {
		m_start_button.EnableWindow(FALSE);
		m_stop_button.EnableWindow(TRUE);
	}

	m_samplerate_text.Format("%.3f", m_rp2.GetSFreq());
	m_cycusage_text.Format("%d", m_rp2.GetCycUse());
	m_check_clipped = (BOOL)m_rp2.GetTagVal("Clip");
	UpdateData(FALSE);
}

void CBandLimitedNoiseDlg::OnStopClick() 
{
	m_rp2.Halt();
	m_start_button.EnableWindow(TRUE);
	m_stop_button.EnableWindow(FALSE);
}

void CBandLimitedNoiseDlg::OnExitClick() 
{
	CDialog::OnCancel();
}
