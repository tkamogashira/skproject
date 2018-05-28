// TDT_ActiveX_Console.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "stdio.h"

#import "C:\\TDT\\ActiveX\\RPcoX.ocx"

RPCOXLib::_DRPcoXPtr RP;

int _tmain(int argc, _TCHAR* argv[])
{
	const char* circuitPath = "C:\\TDT\\ActiveX\\ActXExamples\\RP_files\\Band_Limited_Noise.rcx";

	//Initialize ActiveX object
	HRESULT hr;
	hr = CoInitialize(NULL);
	if (FAILED(hr)) {
		printf("Failed to initialize COM!\n");
	}
	const char* appId = "{d323a625-1d13-11d4-8858-444553540000}"; //"RPcoX.ocx"
	hr = RP.CreateInstance(appId);

	if (FAILED(hr)) {
		printf("CreateInstance for %s failed!\n", appId);
	}
	else {
		printf("Successfully initialized TDT ActiveX interface %s\n", appId);
	}

	if (0 == RP) return -1;
	//

	//TDT ActiveX commands
	if (RP->ConnectRP2("GB",1)) {  
		printf("Connected to RP2\n");
	}
	if (!RP->ClearCOF()) {  
		printf("ClearCOF failed\n");
	}
	if (RP->LoadCOF(circuitPath)) {
		printf("%s Loaded\n", circuitPath);
	}
	if (RP->Run()) {  
		printf("Circuit running\n");
	}
	//

	printf("Press Enter to halt circuit and exit");

	getchar();

	RP->Halt();

	return 0;
}