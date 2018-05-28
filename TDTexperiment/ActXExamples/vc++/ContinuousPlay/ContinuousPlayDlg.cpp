// ContinuousPlayDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ContinuousPlay.h"
#include "ContinuousPlayDlg.h"

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
// CContinuousPlayDlg dialog

CContinuousPlayDlg::CContinuousPlayDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CContinuousPlayDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CContinuousPlayDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CContinuousPlayDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CContinuousPlayDlg)
	DDX_Control(pDX, BUTTON_MAKE, m_make_button);
	DDX_Control(pDX, IDC_X1, m_rp2);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CContinuousPlayDlg, CDialog)
	//{{AFX_MSG_MAP(CContinuousPlayDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(BUTTON_MAKE, OnMakeClick)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CContinuousPlayDlg message handlers

BOOL CContinuousPlayDlg::OnInitDialog()
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
	
	// TODO: Add extra initialization here
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CContinuousPlayDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CContinuousPlayDlg::OnPaint() 
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

HCURSOR CContinuousPlayDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}


void CContinuousPlayDlg::OnMakeClick() {
	if (m_rp2.ConnectRP2("GB", 1) ==0)
		if (m_rp2.ConnectRP2("USB", 1) == 0) {
			AfxMessageBox("Error connecting to RP2.");
			return;
		}

	m_rp2.ClearCOF();

	if (m_rp2.LoadCOF("C:\\TDT\\ActiveX\\ActXExamples\\RP_files\\Continuous_Play.rcx") == 0) {
		AfxMessageBox("Error loading .rcx file");
		return;
	}
	
	m_rp2.Run();

	MakeTones();	
}


void CContinuousPlayDlg::MakeTones() {
	int bufpts = m_rp2.GetTagSize("datain") / 2;
	int freq1 = 1000;
	int freq2 = 5000;
	const float sample_rate = 97656.25; // 100kHz is actually this on RP2 
	const int num_iterations = 10;
	const double PI = 3.14159;
	float *time, *tone1, *tone2;
	int i;

	// allocate space for arrays
	time = new float[bufpts];
	tone1 = new float[bufpts];
	tone2 = new float[bufpts];

	// initialize time array
	for (i = 0; i < bufpts; i++)
		time[i] = i / sample_rate;

	// for each iteration, load tones into arrays and send
	for (i = 0; i < num_iterations; i++) {
		freq1 += 500;
		freq2 += 500;
		for (int j = 0; j < bufpts; j++) {
			tone1[j] = (float) sin(2*PI*time[j]*freq1);
			tone2[j] = (float) sin(2*PI*time[j]*freq2);
		}
		if (i == 0) {
			// first time through
			m_rp2.WriteTag("datain", tone1, 0, bufpts);
			m_rp2.WriteTag("datain", tone2, bufpts, bufpts);
			m_rp2.SoftTrg(1);
		} else
			SendTones(bufpts, tone1, tone2);
	}

	// all done
	m_rp2.SoftTrg(2);
	m_rp2.Halt();
}


// sleeps for a given number of milliseconds
void sleep(clock_t wait) {
	clock_t goal;
	goal = wait + clock();
	while (goal > clock())
		;
}


void CContinuousPlayDlg::SendTones(int bufpts, float *tone1, float *tone2) {
	float curindex;

	// send first tone to first half of buffer
	curindex = m_rp2.GetTagVal("index");
	while (curindex < bufpts) {
		curindex = m_rp2.GetTagVal("index");
		sleep(20);
	}
	m_rp2.WriteTag("datain", tone1, 0, bufpts);
	curindex = m_rp2.GetTagVal("index");
	if (curindex < bufpts) {
		AfxMessageBox("Error: transfer rate too slow.");
		m_rp2.SoftTrg(2);
		return;
	}
	
	// send second tone to second half of buffer
	while (curindex > bufpts) {
		curindex = m_rp2.GetTagVal("index");
		sleep(20);
	}
	m_rp2.WriteTag("datain", tone2, bufpts, bufpts);
	curindex = m_rp2.GetTagVal("index");
	if (curindex > bufpts) {
		AfxMessageBox("Error: transfer rate too slow.");
		m_rp2.SoftTrg(2);
	}
}
