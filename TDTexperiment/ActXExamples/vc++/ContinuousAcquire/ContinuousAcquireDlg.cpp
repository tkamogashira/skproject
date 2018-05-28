// ContinuousAcquireDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ContinuousAcquire.h"
#include "ContinuousAcquireDlg.h"

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
// CContinuousAcquireDlg dialog

CContinuousAcquireDlg::CContinuousAcquireDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CContinuousAcquireDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CContinuousAcquireDlg)
	m_samples_text = _T("");
	m_index_text = _T("");
	//}}AFX_DATA_INIT
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CContinuousAcquireDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CContinuousAcquireDlg)
	DDX_Control(pDX, EXIT_BUTTON, m_exit_button);
	DDX_Control(pDX, LOAD_BUTTON, m_load_button);
	DDX_Control(pDX, STOP_BUTTON, m_stop_button);
	DDX_Control(pDX, START_BUTTON, m_start_button);
	DDX_Text(pDX, EDIT_SAMPLES, m_samples_text);
	DDX_Control(pDX, IDC_X1, m_rp2);
	DDX_Text(pDX, EDIT_INDEX, m_index_text);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CContinuousAcquireDlg, CDialog)
	//{{AFX_MSG_MAP(CContinuousAcquireDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(LOAD_BUTTON, OnLoadClick)
	ON_BN_CLICKED(START_BUTTON, OnStartClick)
	ON_BN_CLICKED(STOP_BUTTON, OnStopClick)
	ON_BN_CLICKED(EXIT_BUTTON, OnExitClick)
	ON_WM_TIMER()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CContinuousAcquireDlg message handlers

BOOL CContinuousAcquireDlg::OnInitDialog()
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

void CContinuousAcquireDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CContinuousAcquireDlg::OnPaint() 
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

HCURSOR CContinuousAcquireDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}


int CContinuousAcquireDlg::StartRP2() {
	if (m_rp2.ConnectRP2("GB", 1) ==0)
		if (m_rp2.ConnectRP2("USB", 1) == 0) {
			AfxMessageBox("Error connecting to RP2.");
			return 0;
		}

	m_rp2.ClearCOF();

	if (m_rp2.LoadCOF("C:\\TDT\\ActiveX\\ActXExamples\\RP_files\\Continuous_Acquire.rcx") == 0) {
		AfxMessageBox("Error loading .rcx file");
		return 0;
	}
	
	return m_rp2.Run();
}


const int buffer_size = 100000;
const float sample_rate = 97656.25; // 100kHz is actually this on RP2 
const int bufpts = buffer_size / 2;
const char *outfile = "C:\\TDT\\ActiveX\\ActXExamples\\vc++\\fnoise2.f32";


void CContinuousAcquireDlg::OnLoadClick() {
	if (!StartRP2())
		return;

	// initialize time array
	time = new double[bufpts];	
	for (int i = 0; i < bufpts; i++)
		time[i] = i / sample_rate;

	data = new float[bufpts];

	m_load_button.EnableWindow(FALSE);
	m_start_button.EnableWindow(TRUE);
	acquire = false;
	m_samples_text = "0";
	UpdateData(FALSE);
	samples_acquired = 0;
}


void CContinuousAcquireDlg::WriteToFile(float *data, int points) {
	fout.write((char *) data, points * sizeof(float));
}	


void CContinuousAcquireDlg::OnStartClick() {
	fout.open(outfile, ios::out | ios::binary);	

	m_start_button.EnableWindow(FALSE);
	m_stop_button.EnableWindow(TRUE);
	acquire = true;
	high = false;

	m_rp2.SoftTrg(1);
	
	SetTimer(1, 10, NULL);
}


void CContinuousAcquireDlg::OnStopClick() {
	acquire = false;
	m_rp2.SoftTrg(2);
	m_rp2.Halt();
	fout.close();
	m_stop_button.EnableWindow(FALSE);
	m_load_button.EnableWindow(TRUE);
}


void CContinuousAcquireDlg::OnExitClick() {
	KillTimer(1);
	CDialog::OnCancel();
}


void CContinuousAcquireDlg::OnTimer(UINT nIDEvent) {
	static int offset = 0;

	if(acquire) {
		curindex = m_rp2.GetTagVal("index");
		m_index_text.Format("%.0f", curindex);
		UpdateData(FALSE);

		if(high) {
			while(curindex > bufpts) { 
				curindex = m_rp2.GetTagVal("index");
				m_index_text.Format("%.0f", curindex);
				UpdateData(FALSE);
			}
		} else {
			while(curindex < bufpts) { 
				curindex = m_rp2.GetTagVal("index");
				m_index_text.Format("%.0f", curindex);
				UpdateData(FALSE);
			}
		}

		// read segment and write it to file
		if(m_rp2.ReadTag("dataout", data, offset, bufpts) == 0)
			AfxMessageBox("Error transferring data.");
		WriteToFile(data, bufpts);
		samples_acquired += bufpts;
		m_samples_text.Format("%d", samples_acquired);
		UpdateData(FALSE);
		
		// check to see if data is transferring fast enough
		curindex = m_rp2.GetTagVal("index");
		m_index_text.Format("%.0f", curindex);
		UpdateData(FALSE);
		if(high) {
			if (curindex > bufpts) {
				AfxMessageBox("Error: transfer rate too slow.");
				m_rp2.SoftTrg(2);
				m_rp2.Halt();
				acquire = false;
			}
		} else {
			if (curindex < bufpts) {
				AfxMessageBox("Error: transfer rate too slow.");
				m_rp2.SoftTrg(2);
				m_rp2.Halt();
				acquire = false;
			}
		}

		// set for next time
		if(high) {
			high = false;
			offset = 0;
		} else {
			high = true;
			offset = bufpts;
		}
	}

	CDialog::OnTimer(nIDEvent);
}
