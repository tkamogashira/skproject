/**
 * @file HostLib_Midi.h
 * @brief Helper for the MIDI interface.
 * Copyright 2011-2013 The MathWorks, Inc.
 */ 

#ifndef HOSTLIB_MIDI_H
#define HOSTLIB_MIDI_H

/* Wrap everything in extern C */
#ifdef __cplusplus
extern "C" {
#endif 

extern const char *libName_Midi;
  
/*******************************
 * Routines which are defined in the library in question
 *******************************/
typedef void (*pFnLibCreate_Midi)(const double ctls[], int nctls, const double inits[], int ninits, 
                                  const char* deviceName, int sync, int rawuint8, double cids[], char *errmsg);
typedef void (*pFnLibOutputs_Midi)(const double *cids, int rawuint8, void* outputs, char *errmsg);

/*******************************
 * Routines which we define to call the functions in the library 
 *******************************/
void LibCreate_Midi(void *hostLib, const double ctls[], int nctls, const double inits[], int ninits, 
                    const char* deviceName, int sync, int rawuint8, double cids[]);

void LibOutputs_Midi(void *hl, int rawuint8, void* outputs);

/* Include HostLib for declarations of LibTerminate, CreateHostLibrary, and DestroyHostLibrary. */
#include "HostLib_rtw.h"

#ifdef __cplusplus
} // extern "C"
#endif 

#endif
/* There must be a newline at the end of this file */
