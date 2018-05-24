/**
 * mmpcmaudio_rt.c:  Contains methods for converting raw PCM audio data
 *    between various data types; also includes routines for setting a buffer
 *    to default silence state
 *
 * Copyright 2005-2013 The MathWorks, Inc.
 */

#ifdef MW_DSP_RT
#include "src/dspmmutils_rt.h"
#include "src/dspendian_rt.h"
#else
#include "dspmmutils_rt.h"
#include "dspendian_rt.h"
#endif

#if (!defined(INTEGER_CODE) || !INTEGER_CODE)

#define MM_MIN(a,b) ((a) > (b) ? (b) : (a))
#define MM_MAX(a,b) ((a) < (b) ? (b) : (a))


		
/*  Input:	32-bit normalized, IEEE Type 3 PCM audio samples */
/*  Output:	Double-precision array */
void Copy32BitType3PCM_ToDouble(void* buffer, void* outputSignal,
                                int_T numSamples, int_T numChannels)
{
    real32_T* buf = (real32_T*)buffer;
    real_T* y = (real_T*)outputSignal;
    int_T i;
    int_T channel;

    for (i=0; i < numSamples; i++) 
    {
        for (channel=0; channel < numChannels; channel++)
            y[numSamples * channel + i] = (real_T) *buf++;
    }
}


/*  Input:	24-bit PCM audio samples */
/*  Output:	Double-precision array */
void Copy24BitPCM_ToDouble(void* buffer, void* outputSignal, 
                           int_T numSamples, int_T numChannels)
{
    uint8_T *data = (uint8_T *)buffer;
    int_T i;
    int32_T intSample;
    uint8_T* bytePtr;
    real_T* y = (real_T*)outputSignal;
    int_T channel;

    bytePtr = (uint8_T*) &intSample;

    if(isLittleEndian()) {
        for(i=0; i < numSamples; i++)
            for(channel = 0; channel < numChannels; channel++)
            {
                bytePtr[0] = 0;
                bytePtr[1] = *data++;
                bytePtr[2] = *data++;
                bytePtr[3] = *data++;
                y[numSamples * channel + i] = 
                    (real_T) ((real_T)intSample / (MAX_int32_T+1.0));
            }
    }
    else {
        for(i=0; i < numSamples; i++)
            for(channel = 0; channel < numChannels; channel++)
            {
                bytePtr[0] = *data++;
                bytePtr[1] = *data++;
                bytePtr[2] = *data++;
                bytePtr[3] = 0;
                y[numSamples * channel + i] = 
                    (real_T) ((real_T)intSample / (MAX_int32_T+1.0));
            }
    }
}

		
/*  Input:	16-bit PCM audio samples */
/*  Output:	Double-precision array */
void Copy16BitPCM_ToDouble(void* buffer, void* outputSignal, 
                           int_T numSamples, int_T numChannels)
{
    int16_T *data = (int16_T *)buffer;
    int_T    i;
    real_T*  y = (real_T*)outputSignal;
    int_T    channel;

    for(i=0; i < numSamples; i++)
    {
        for(channel = 0; channel < numChannels; channel++)
        {
            y[numSamples * channel + i] = *data++ / 32768.0;
        }
    }
}

		
/*  Input:	8-bit PCM audio samples (unsigned) */
/*  Output:	Double-precision array */
void Copy8BitPCM_ToDouble(void* buffer, void* outputSignal, 
                          int_T numSamples, int_T numChannels)
{
    int_T i;
    real_T* y = (real_T*)outputSignal;
    uint8_T* buf = (uint8_T*) buffer;
    int_T channel;

    for(i=0; i < numSamples; i++) 
    {
        for(channel = 0; channel < numChannels; channel++)
        {
            y[numSamples * channel + i] = (*buf++ - 128.0) / 128.0;
        }
    }
}

		
/*  Input:	32-bit normalized, IEEE Type 3 PCM audio samples */
/*  Output:	Single-precision array */
void Copy32BitType3PCM_ToSingle(void* buffer, void* outputSignal,
                                int_T numSamples, int_T numChannels)
{
    real32_T* buf = (real32_T*)buffer;
    real32_T* y = (real32_T*)outputSignal;
    int_T i;
    int_T channel;

    for (i=0; i < numSamples; i++) 
    {
        for (channel=0; channel < numChannels; channel++)
            y[numSamples * channel + i] = *buf++;
    }
}
		
/*  Input:	24-bit PCM audio samples */
/*  Output:	Single-precision array */
void Copy24BitPCM_ToSingle(void* buffer, void* outputSignal, 
                           int_T numSamples, int_T numChannels)
{
    uint8_T *data = (uint8_T *)buffer;
    int_T i;
    int32_T intSample;
    uint8_T* bytePtr;
    real32_T* y = (real32_T*)outputSignal;
    int_T channel;
    bytePtr = (uint8_T*) &intSample;

    if(isLittleEndian()) {
        for(i=0; i < numSamples; i++)
            for(channel = 0; channel < numChannels; channel++)
            {
                bytePtr[0] = 0;
                bytePtr[1] = *data++;
                bytePtr[2] = *data++;
                bytePtr[3] = *data++;
                y[numSamples * channel + i] = 
                    (real32_T) ((real32_T)intSample / (MAX_int32_T+1.0F));
            }
    }
    else {
        for(i=0; i < numSamples; i++)
            for(channel = 0; channel < numChannels; channel++)
            {
                bytePtr[0] = *data++;
                bytePtr[1] = *data++;
                bytePtr[2] = *data++;
                bytePtr[3] = 0;
                y[numSamples * channel + i] = 
                    (real32_T) ((real32_T)intSample / (MAX_int32_T+1.0F));
            }
    }
}
		
/*  Input:	16-bit PCM audio samples */
/*  Output:	Single-precision array */
void Copy16BitPCM_ToSingle(void* buffer, void* outputSignal, 
                           int_T numSamples, int_T numChannels)
{
    int16_T *data = (int16_T *)buffer;
    int_T i;
    real32_T* y = (real32_T*)outputSignal;
    int_T channel;

    for(i=0; i < numSamples; i++) 
    {
        for(channel = 0; channel < numChannels; channel++)
        {
            y[numSamples * channel + i] = *data++ / 32768.0f;
        }
    }
}
		
/*  Input:	8-bit PCM audio samples (unsigned) */
/*  Output:	Single-precision array */
void Copy8BitPCM_ToSingle(void* buffer, void* outputSignal, 
                          int_T numSamples, int_T numChannels)
{
    int_T i;
    real32_T* y = (real32_T*)outputSignal;
    uint8_T* buf = (uint8_T*) buffer;
    int channel;
    
    for(i=0; i < numSamples; i++) 
    {
        for(channel = 0; channel < numChannels; channel++)
        {
            y[numSamples * channel + i] = (*buf++ - 128.0f) / 128.0f;
        }
    }
}

/*  Input:	32-bit normalized, IEEE Type 3 PCM audio samples */
/*  Output:	Int16 array */
void Copy32BitType3PCM_ToInt16(void* buffer, void* outputSignal,
                               int_T numSamples, int_T numChannels)
{
    real32_T* buf = (real32_T*)buffer;
    int16_T* y = (int16_T*)outputSignal;
    int_T i;
    int_T channel;

    /* We dont clip here, so the signal should already be in the range [-1 .. 1) */
    for (i=0; i < numSamples; i++)
    {
        for (channel=0; channel < numChannels; channel++)
            if(*buf >= 1)
                y[numSamples * channel + i] =  32767;
            else if(*buf < -1)
                y[numSamples * channel + i] = -32768;
            else
                y[numSamples * channel + i] = (int16_T) (*buf++ * 32768);
    }
}

/*  Input:	24-bit PCM audio samples */
/*  Output: Int16 array */
void Copy24BitPCM_ToInt16(void* buffer, void* outputSignal, 
                          int_T numSamples, int_T numChannels)
{
    uint8_T *data = (uint8_T *)buffer;
    uint8_T *y = (uint8_T*)outputSignal;
    int_T i, channel, yOffset;

    if(isLittleEndian()) {
        for(i=0; i < numSamples; i++)
            for(channel = 0; channel < numChannels; channel++)
            {
                yOffset = (numSamples * channel + i)*sizeof(int16_T);
                data++;
                y[yOffset] = *data++;
                y[yOffset+1] = *data++;
            }
    }
    else {
        for(i=0; i < numSamples; i++)
            for(channel = 0; channel < numChannels; channel++)
            {
                yOffset = (numSamples * channel + i)*sizeof(int16_T);
                y[yOffset] = *data++;
                y[yOffset+1] = *data++;
                data++;
            }
    }
}

		
/*  Input:	16-bit PCM audio samples */
/*  Output:	Int16 array */
void Copy16BitPCM_ToInt16(void* buffer, void* outputSignal, 
                          int_T numSamples, int_T numChannels)
{
    int16_T *data = (int16_T *)buffer;
    int16_T    *y = (int16_T *)outputSignal;
    int_T i;
    int_T channel;
    
    for(i=0; i < numSamples; i++) 
    {
        for(channel = 0; channel < numChannels; channel++)
        {
            y[numSamples * channel + i] = *data++;
        }
    }
}

/*  Input:	8-bit PCM audio samples (unsigned) */
/*  Output:	Int16 array */
void Copy8BitPCM_ToInt16(void* buffer, void* outputSignal, 
                         int_T numSamples, int_T numChannels)
{
    short* y = (short*) outputSignal;
    uint8_T* sampleBuffer = (uint8_T*)buffer;
    int_T i;
    int_T channel;
    for (i=0; i < numSamples; i++) 
    {
        for (channel=0; channel < numChannels; channel++) {
            y[numSamples * channel + i] = (*sampleBuffer++ - 128) * 256;
        }
    }
}


/*  Input:	32-bit normalized, IEEE Type 3 PCM audio samples */
/*  Output:	Uint8 array */
void Copy32BitType3PCM_ToUint8(void* buffer, void* outputSignal,
                               int_T numSamples, int_T numChannels)
{
    real32_T* buf = (real32_T*)buffer;
    uint8_T* y = (uint8_T*)outputSignal;
    int_T i;
    int_T channel;

    /* We dont clip here, so the signal should already be in the range [-1 .. 1) */
    for (i=0; i < numSamples; i++)
    {
        for (channel=0; channel < numChannels; channel++)
            if(*buf >= 1)
                y[numSamples * channel + i] = 255;
            else if(*buf < -1)
                y[numSamples * channel + i] = 0;
            else
                y[numSamples * channel + i] = (uint8_T) ((1.0+*buf++) * 128);
    }
}

/*  Input:	24-bit PCM audio samples */
/*  Output: Uint8 array */
void Copy24BitPCM_ToUint8(void* buffer, void* outputSignal, 
                          int_T numSamples, int_T numChannels)
{
    uint8_T *data = (uint8_T *)buffer;
    uint8_T *y = (uint8_T*)outputSignal;
    int_T i, channel, yOffset;

    if(isLittleEndian()) {
        for(i=0; i < numSamples; i++)
            for(channel = 0; channel < numChannels; channel++)
            {
                yOffset = (numSamples * channel + i)*sizeof(uint8_T);
                data++;
                data++;
                y[yOffset] = (uint8_T)(((int16_T)*data++)+128);
            }
    }
    else {
        for(i=0; i < numSamples; i++)
            for(channel = 0; channel < numChannels; channel++)
            {
                yOffset = (numSamples * channel + i)*sizeof(uint8_T);
                y[yOffset] = (uint8_T)(((int16_T)*data++)+128);
                data++;
                data++;
            }
    }
}

/*  Input:	16-bit PCM audio samples */
/*  Output:	Uint8 array */
void Copy16BitPCM_ToUint8(void* buffer, void* outputSignal, 
                          int_T numSamples, int_T numChannels)
{
    uint8_T* y = (uint8_T*) outputSignal;
    short* buf = (short*)buffer;

    int_T i;
    int_T channel;
    for (i=0; i < numSamples; i++) 
    {
        for (channel=0; channel < numChannels; channel++) {
            y[numSamples * channel + i] = ((*buf++) / 256) + 128;
        }
    }
}


/*  Input:	8-bit PCM audio samples (unsigned) */
/*  Output:	Uint8 array */
void Copy8BitPCM_ToUint8(void* buffer, void* outputSignal, 
                         int_T numSamples, int_T numChannels)
{
    int_T i;
    uint8_T* y = (uint8_T*)outputSignal;
    uint8_T* buf = (uint8_T*) buffer;
    int_T channel;
    
    for(i=0; i < numSamples; i++) 
    {
        for(channel = 0; channel < numChannels; channel++)
        {
            y[numSamples * channel + i] = *buf++;
        }
    }
}


/*  Input:	Doesn't matter */
/*  Output:	Double-precision array of zeros */
void EmptyPCM_ToDouble(void* buffer, void* outputSignal, 
                       int_T numSamples, int_T numChannels)
{
    real_T outputValue = 0.0;
    real_T* doubleSignal = (real_T*) outputSignal;
    int_T i;
    int_T channel;

    (void)buffer; /* silence warnings */

    for(i = 0; i < numSamples; i++)
    {
        for(channel = 0; channel < numChannels; channel++)
        {
            doubleSignal[numSamples * channel + i] = outputValue;
        }
    }
}

		
/*  Input:	Doesn't matter */
/*  Output:	Single-precision array of zeros */
void EmptyPCM_ToSingle(void* buffer, void* outputSignal, 
                       int_T numSamples, int_T numChannels)
{
    real32_T outputValue = 0.0;
    real32_T* singleSignal = (real32_T*)outputSignal;
    int_T i;
    int_T channel;

    /* silence warnings */
    (void)buffer;

    for(i = 0; i < numSamples; i++)
    {
        for(channel = 0; channel < numChannels; channel++)
        {
            singleSignal[numSamples * channel + i] = outputValue;
        }
    }
}

		
/*  Input:	Doesn't matter */
/*  Output:	Int16 array of zeros */
void EmptyPCM_ToInt16(void* buffer, void* outputSignal, 
                      int_T numSamples, int_T numChannels)
{
    int16_T outputValue = 0;
    short* int16Signal = (short*)outputSignal;
    int_T i;
    int_T channel;

    /* silence warnings */
    (void)buffer;

    for(i = 0; i < numSamples; i++)
    {
        for(channel = 0; channel < numChannels; channel++)
        {
            int16Signal[numSamples * channel + i] = outputValue;
        }
    }
}

		
/*  Input:	Doesn't matter */
/*  Output:	Uint8 array of zeros */
void EmptyPCM_ToUint8(void* buffer, void* outputSignal, 
                      int_T numSamples, int_T numChannels)
{
    uint8_T outputValue = 128;
    uint8_T* uint8Signal = (uint8_T*)outputSignal;
    int_T i;
    int_T channel;

    /* silence warnings */
    (void)buffer;

    for(i = 0; i < numSamples; i++)
    {
        for(channel = 0; channel < numChannels; channel++)
        {
            uint8Signal[numSamples * channel + i] = outputValue;
        }
    }
}
		
/*  Input:	Double-precision array */
/*  Output:	16-bit PCM audio samples */
void Output16BitPCM_FromDouble(const void* inputSignal, void* output, 
                               int_T numSamples, int_T numChannels)
{
    const real_T *u = (const real_T *)inputSignal;
    int16_T *buf = (int16_T *)output;
    int_T i;
    int_T channel;
    real_T sample;

    for (i=0; i < numSamples; i++) 
    {
        for (channel=0; channel < numChannels; channel++) 
        {
            sample = floor(u[numSamples * channel + i] * 32768);
            if(sample < -32768) 
                sample =-32768;
            else 
                if (sample >  32767)
                    sample = 32767;
			
            *buf++ = (int16_T)sample;
        }
    }
}


		
/*  Input:	Double-precsion array */
/*  Output:	24-bit PCM audio samples */
void Output24BitPCM_FromDouble(const void* inputSignal, void* output, 
                               int_T numSamples, int_T numChannels)
{
    const real_T *u = (const real_T *)inputSignal;
    uint8_T* sampleBuffer = (uint8_T*)output;
    int_T i;
    int32_T intSample;
    int_T channel;
    real_T sample;

    for (i=0; i < numSamples; i++) 
    {
        for (channel=0; channel < numChannels; channel++) 
        {
            sample = floor(u[numSamples * channel + i] * (MAX_int32_T+1.0));
            if(sample < MIN_int32_T) 
                sample = MIN_int32_T;
            else 
                if (sample >  MAX_int32_T)
                    sample = MAX_int32_T;

            intSample = (int32_T) sample;

            *sampleBuffer++ = (uint8_T)((intSample >> 8 ) & 0x000000FF);
            *sampleBuffer++ = (uint8_T)((intSample >> 16) & 0x000000FF);
            *sampleBuffer++ = (uint8_T)((intSample >> 24) & 0x000000FF);
        }
    }
}


		
/*  Input:	Single-precision array */
/*  Output:	24-bit PCM audio samples */
void Output24BitPCM_FromSingle(const void* inputSignal, void* output, 
                               int_T numSamples, int_T numChannels)
{
    const real32_T *u = (const real32_T *)inputSignal;
    uint8_T* sampleBuffer = (uint8_T*)output;
    int_T i;
    int32_T intSample;
    int_T channel;
    real32_T sample;

    for (i=0; i < numSamples; i++) 
    {
        for (channel=0; channel < numChannels; channel++) 
        {
            sample = (real32_T) floor(u[numSamples * channel + i] * (MAX_int32_T+1.0F));
            if(sample < MIN_int32_T) 
                sample = (real32_T) MIN_int32_T;
            else 
                if (sample >  MAX_int32_T)
                    sample = (real32_T) MAX_int32_T;

            intSample = (int32_T) sample;

            *sampleBuffer++ = (uint8_T)((intSample >> 8 ) & 0x000000FF);
            *sampleBuffer++ = (uint8_T)((intSample >> 16) & 0x000000FF);
            *sampleBuffer++ = (uint8_T)((intSample >> 24) & 0x000000FF);
        }
    }
}


		
/*  Input:	Single-precision array */
/*  Output:	16-bit PCM audio samples */
void Output16BitPCM_FromSingle(const void* inputSignal, void* output, 
                               int_T numSamples, int_T numChannels)
{
    const real32_T *u = (const real32_T *)inputSignal;
    int16_T *buf = (int16_T *)output;
    int_T i;
    int_T channel;
    real32_T sample;

    for (i=0; i < numSamples; i++) 
    {
        for (channel=0; channel < numChannels; channel++) 
        {
            sample = (real32_T) floor(u[numSamples * channel + i] * 32768);
            if(sample < -32768) 
                sample =-32768;
            else 
                if (sample >  32767) sample = 32767;
            *buf++ = (int16_T)sample;
        }
    }
}


		
/*  Input:	Int16 array */
/*  Output:	16-bit PCM audio samples */
void Output16BitPCM_FromInt16(const void* inputSignal, void* output, 
                              int_T numSamples, int_T numChannels)
{
    const int16_T *u = (const int16_T *)inputSignal;
    int16_T *buf = (int16_T *)output;
    int_T i;
    int_T channel;

    for (i=0; i < numSamples; i++) {
        for (channel=0; channel < numChannels; channel++) 
        {
            *buf++ = (int16_T)u[numSamples * channel + i];
        }
    }
}


		
/*  Input:	Uint8 array */
/*  Output:	8-bit PCM audio samples (unsigned) */
void Output8BitPCM_FromUint8(const void* inputSignal, void* output, 
                             int_T numSamples, int_T numChannels)
{
    const uint8_T *u = (const uint8_T *)inputSignal;
    uint8_T *buf = (uint8_T *)output;
    int_T i;
    int_T channel;

    for (i=0; i < numSamples; i++) 
    {
        for (channel=0; channel < numChannels; channel++)
            *buf++ = (uint8_T)u[numSamples * channel + i];
    }
}


		
/*  Input:	Double-precision array */
/*  Output:	32-bit normalized, IEEE Type 3 PCM audio samples */
void Output32BitType3PCM_FromDouble(const void* inputSignal, void* output, 
                                    int_T numSamples, int_T numChannels)
{
    const real_T *uptr = (const real_T *)inputSignal;

    real32_T *buf = (real32_T *)output;
    int16_T channel;
    int_T i;
    real32_T u;
    for (channel=0; channel < numChannels; channel++)
    {
        for (i=0; i < numSamples; i++) 
        {
            u = (real32_T)*uptr;  uptr++;
            buf[channel + i * numChannels] = u;
        }
    }
}


		
/*  Input:	Double-precision array */
/*  Output:	8-bit PCM audio samples (unsigned) */
void Output8BitPCM_FromDouble(const void* inputSignal, void* output, 
                              int_T numSamples, int_T numChannels)
{
    const real_T *uptr = (const real_T *)inputSignal;

    uint8_T *buf = (uint8_T *)output;
    int_T i;
    int16_T channel;
    for (i=0; i < numSamples; i++) 
    {
        for (channel=0; channel < numChannels; channel++) 
        {
            buf[channel + i * numChannels] = 
                (uint8_T)MM_MAX
                (0, MM_MIN(255, floor(uptr[numSamples * channel + i] * 128 + 
                                      128)));
        }
    }
}



		
/*  Input:	Single-precision array */
/*  Output:	32-bit normalized, IEEE Type 3 PCM audio samples */
void Output32BitType3PCM_FromSingle(const void* inputSignal, void* output, 
                                    int_T numSamples, int_T numChannels)
{
    const real32_T *uptr = (const real32_T *)inputSignal;

    real32_T *buf = (real32_T *)output;
    int16_T channel;
    int_T i;
    for (channel=0; channel < numChannels; channel++)
    {
        for (i=0; i < numSamples; i++) 
        {
            real32_T u = *uptr;  uptr++;
            buf[channel + i * numChannels] = u;
        }
    }
}




		
/*  Input:	Single-precision array */
/*  Output:	8-bit PCM audio samples (unsigned) */
void Output8BitPCM_FromSingle(const void* inputSignal, void* output, 
                              int_T numSamples, int_T numChannels)
{
    const real32_T *uptr = (const real32_T *)inputSignal;

    uint8_T *buf = (uint8_T *)output;
    int_T i;
    int16_T channel;
    for (i=0; i < numSamples; i++) 
    {
        for (channel=0; channel < numChannels; channel++)
        {
            buf[channel + i * numChannels] = 
                (uint8_T)MM_MAX
                (0, MM_MIN(255, floor(uptr[numSamples * channel + i] * 128 +
                                      128)));
        }
    }
}



		
/*  Input:	Int16 array */
/*  Output:	8-bit PCM audio samples (unsigned) */
void Output8BitPCM_FromInt16(const void* inputSignal, void* output, 
                             int_T numSamples, int_T numChannels)
{
    const short* uptr = (const short*)inputSignal;
    uint8_T* sampleBuffer = (uint8_T*)output;
    int_T i;
    int16_T channel;
    for(i=0; i < numSamples; i++)
    {
        for(channel = 0; channel < numChannels; channel++)
        {
            sampleBuffer[channel + i * numChannels] = 
                (uint8_T)
                MM_MAX(0, MM_MIN(255, uptr[numSamples * channel + i] / 255 +
                                 128));
        }
    }
}


		
/*  Input:	Uint8 array */
/*  Output:	16-bit PCM audio samples */
void Output16BitPCM_FromUint8(const void* inputSignal, void* output, 
                              int_T numSamples, int_T numChannels)
{
    const uint8_T *uptr = (const uint8_T *)inputSignal;
    int16_T *buf = (int16_T *)output;
    int16_T channel;
    int_T i;
    for (channel=0; channel < numChannels; channel++)
    {
        for (i=0; i < numSamples; i++) 
        {
            real_T u = *uptr - 128;
            u = floor(u * 255);  uptr++;
            buf[channel + i * numChannels] = (int16_T)MM_MAX(-32768, MM_MIN(32767, u));
        }
    }
}

#define NUM_DTYPES	9				/* right now, anyway */
#define NUM_AUDIO_BIT_DEPTHS	4



static COPY_PCM_SAMPLES_FUNC pcmAudioCopyFcns[] = 
{
    /* AudioDataType_Double = 0,	double */
    Copy32BitType3PCM_ToDouble,	/*  32-bit */
    Copy24BitPCM_ToDouble,	/*  24-bit */
    Copy16BitPCM_ToDouble,	/*  16-bit */
    Copy8BitPCM_ToDouble,	/*  8-bit */
    /* AudioDataType_Single,	 float */
    Copy32BitType3PCM_ToSingle,	/*  32-bit */
    Copy24BitPCM_ToSingle,	/*  24-bit */
    Copy16BitPCM_ToSingle,	/*  16-bit */
    Copy8BitPCM_ToSingle,	/*  8-bit */
    /* AudioDataType_Int8,		 char */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  32-bit */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  24-bit */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  16-bit */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  8-bit */
    /* AudioDataType_Uint8,  uint8_T */
    Copy32BitType3PCM_ToUint8,	/*  32-bit */
    Copy24BitPCM_ToUint8,	/*  24-bit */
    Copy16BitPCM_ToUint8,	/*  16-bit */
    Copy8BitPCM_ToUint8,	/*  8-bit */
    /* AudioDataType_Int16,	 short */
    Copy32BitType3PCM_ToInt16,	/*  32-bit */
    Copy24BitPCM_ToInt16,	/*  24-bit */
    Copy16BitPCM_ToInt16,	/*  16-bit */
    Copy8BitPCM_ToInt16,	/*  8-bit */
    /* AudioDataType_Uint16,   unsigned short */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  32-bit */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  24-bit */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  16-bit */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  8-bit */
    /* AudioDataType_Int32,	 long */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  32-bit */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  24-bit */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  16-bit */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  8-bit */
    /* AudioDataType_Uint32,	 unsigned long */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  32-bit */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  24-bit */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  16-bit */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  8-bit */
    /* AudioDataType_Boolean	 bool */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  32-bit */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  24-bit */
    (COPY_PCM_SAMPLES_FUNC) NULL,	/*  16-bit */
    (COPY_PCM_SAMPLES_FUNC) NULL	/*  8-bit */
};

static OUTPUT_PCM_SAMPLES_FUNC pcmAudioOutputFcns[] = 
{
    /* AudioDataType_Double = 0,  double */
    Output32BitType3PCM_FromDouble,	/*  32-bit */
    Output24BitPCM_FromDouble,	/*  24-bit */
    Output16BitPCM_FromDouble,	/*  16-bit */
    Output8BitPCM_FromDouble,	/*  8-bit */
    /* AudioDataType_Single,	 float */
    Output32BitType3PCM_FromSingle,	/*  32-bit */
    Output24BitPCM_FromSingle,	/*  24-bit */
    Output16BitPCM_FromSingle,	/*  16-bit */
    Output8BitPCM_FromSingle,	/*  8-bit */
    /* AudioDataType_Int8,		 char */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  32-bit */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  24-bit */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  16-bit */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  8-bit */
    /* AudioDataType_Uint8,	  uint8_T */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  32-bit */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  24-bit */
    Output16BitPCM_FromUint8,	/*  16-bit */
    Output8BitPCM_FromUint8,	/*  8-bit */
    /* AudioDataType_Int16,	  short */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  32-bit */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  24-bit */
    Output16BitPCM_FromInt16,	/*  16-bit */
    Output8BitPCM_FromInt16,	/*  8-bit */
    /* AudioDataType_Uint16,	unsigned short */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  32-bit */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  24-bit */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  16-bit */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  8-bit */
    /* AudioDataType_Int32,		long */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  32-bit */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  24-bit */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  16-bit */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  8-bit */
    /* AudioDataType_Uint32,	unsigned long */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  32-bit */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  24-bit */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  16-bit */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  8-bit */
    /* AudioDataType_Boolean	bool */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  32-bit */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  24-bit */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL,	/*  16-bit */
    (OUTPUT_PCM_SAMPLES_FUNC) NULL	/*  8-bit */
};



COPY_PCM_SAMPLES_FUNC MWDSP_GetPCMAudioCopyFcn(AudioDataType dType, int_T numBits)
{
    int_T offset = dType * NUM_AUDIO_BIT_DEPTHS + 4 - (numBits / 8);
    if(offset >= 0 && offset < (NUM_DTYPES * NUM_AUDIO_BIT_DEPTHS))
        return pcmAudioCopyFcns[offset];
    else
        return (COPY_PCM_SAMPLES_FUNC) NULL;
}

COPY_PCM_SAMPLES_FUNC MWDSP_GetPCMAudioEmptyFcn(AudioDataType dType)
{
    COPY_PCM_SAMPLES_FUNC ret;

    switch(dType)
    {
      case AudioDataType_Double:
        ret = EmptyPCM_ToDouble;
        break;
      case AudioDataType_Single:
        ret = EmptyPCM_ToSingle;
        break;
      case AudioDataType_Int16:
        ret = EmptyPCM_ToInt16;
        break;
      case AudioDataType_Uint8:
        ret = EmptyPCM_ToUint8;
        break;
      default:
        ret = (COPY_PCM_SAMPLES_FUNC) NULL;
        break;
    }

    return ret;

}

OUTPUT_PCM_SAMPLES_FUNC MWDSP_GetPCMAudioOutputFcn(AudioDataType dType, int_T numBits)
{
    int_T offset = dType * NUM_AUDIO_BIT_DEPTHS + 4 - (numBits / 8);
    if(offset >= 0 && offset < (NUM_DTYPES * NUM_AUDIO_BIT_DEPTHS))
        return pcmAudioOutputFcns[offset];
    else
        return (OUTPUT_PCM_SAMPLES_FUNC) NULL;
}

#endif /* !INTEGER_CODE */

/* [EOF] mmpcmaudio_rt.c */
