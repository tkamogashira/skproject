/**
 * @file HostLib_Midi.c
 * @brief Helper for the MIDI interface.
 * Copyright 2011-2013 The MathWorks, Inc.
 */ 

#include "HostLib_Midi.h"
#include <string.h>
#include <stdio.h>
/* #include "mex.h" */

#if defined(_WIN32)
const char *libName_Midi = "midi.dll";
#elif defined(__APPLE__)
const char *libName_Midi = "libmwmidi.dylib";
#else
const char *libName_Midi = "libmwmidi.so";
#endif

void LibCreate_Midi(void *hl, const double ctls[], int nctls, const double inits[], int ninits, const char* deviceName, int sync, int rawuint8, double cids[]) 
{
    HostLibrary *hostLib = (HostLibrary*)hl;

#if 0
    int i;
    mexPrintf("LibCreate_Midi:\n");
    mexPrintf("  control numbers:");
    for (i = 0; i < nctls; ++i) {
        mexPrintf(" %f", ctls[i]);
    }
    mexPrintf("\n");
    mexPrintf("  initial values:");
    for (i = 0; i < ninits; ++i) {
        mexPrintf(" %f", inits[i]);
    }
    mexPrintf("\n");
    mexPrintf("  deviceName: %s\n", deviceName);
    mexPrintf("  sync: %d\n", sync);

    mexPrintf("HostLibrary:\n");
    mexPrintf("  library: %x\n", hostLib->library);
    mexPrintf("  libCreate: %x\n", hostLib->libCreate);
    mexPrintf("  libStart: %x\n", hostLib->libStart);
    mexPrintf("  libReset: %x\n", hostLib->libReset);
    mexPrintf("  libUpdate: %x\n", hostLib->libUpdate);
    mexPrintf("  libOutputs: %x\n", hostLib->libOutputs);
    mexPrintf("  libTerminate: %x\n", hostLib->libTerminate);
    mexPrintf("  libDestroy: %x\n", hostLib->libDestroy);
    mexPrintf("  errorMessage: %s\n", hostLib->errorMessage);
#endif
    *hostLib->errorMessage  = '\0';
    hostLib->instance = cids;
    (MAKE_FCN_PTR(pFnLibCreate_Midi,hostLib->libCreate))(ctls, nctls, inits, ninits, deviceName, sync, rawuint8, cids, hostLib->errorMessage);
}

void LibOutputs_Midi(void *hl, int rawuint8, void* outputs) 
{
    HostLibrary *hostLib = (HostLibrary*)hl;
    if(hostLib->instance)
        (MAKE_FCN_PTR(pFnLibOutputs_Midi,hostLib->libOutputs))(hostLib->instance, rawuint8, outputs, hostLib->errorMessage);
}
