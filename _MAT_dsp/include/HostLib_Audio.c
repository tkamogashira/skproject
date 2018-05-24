/**
 * @file HostLib_Audio.c
 * @brief Helper for C clients of the HostLib library.
 * Copyright 2007-2012 The MathWorks, Inc.
 */ 

#include "HostLib_Audio.h"
#include <string.h>
#include <stdio.h>

#if defined(_WIN32)
const char *libName_Audio = "hostlibaudio.dll";
#elif defined(__APPLE__)
const char *libName_Audio = "libmwhostlibaudio.dylib";
#else
const char *libName_Audio = "libmwhostlibaudio.so";
#endif

void LibCreate_Audio(void *hl, char *warn, const char *deviceName, int apiID, int inOut,
                     int numChannels, double sampleRate, int deviceDatatype, int bufferSize, int queueDuration,
                     int frameSize, int signalDatatype, int* channelMap) 
{
    HostLibrary *hostLib = (HostLibrary*)hl;
    *hostLib->errorMessage  = '\0';
    if(warn)
    {
        *warn = '\0';
    }
    (MAKE_FCN_PTR(pFnLibCreate_Audio,hostLib->libCreate))(hostLib->errorMessage, warn, deviceName, apiID, inOut, &hostLib->instance,
                                                    numChannels, sampleRate, deviceDatatype, bufferSize, queueDuration,
                                                    frameSize, signalDatatype, channelMap);
}
void LibUpdate_Audio(void *hl, const void *src, int signalDatatype, int samplesPerFrame, int *nDroppedSamples) 
{
    HostLibrary *hostLib = (HostLibrary*)hl;
    if(hostLib->instance)
        (MAKE_FCN_PTR(pFnLibUpdate_Audio,hostLib->libUpdate))(hostLib->instance, hostLib->errorMessage, src, signalDatatype, samplesPerFrame, nDroppedSamples);
}
void LibOutputs_Audio(void *hl, void *src, int signalDatatype, int samplesPerFrame, int *nDroppedSamples) 
{
    HostLibrary *hostLib = (HostLibrary*)hl;
    if(hostLib->instance)
        (MAKE_FCN_PTR(pFnLibOutputs_Audio,hostLib->libOutputs))(hostLib->instance, hostLib->errorMessage, src, signalDatatype, samplesPerFrame, nDroppedSamples);
}
