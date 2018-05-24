/*
 * mmrgb24convert_rt.c: RGB24 video frame data type conversion functions
 *     and functions for setting a frame to default black state
 *
 * Copyright 2005-2013 The MathWorks, Inc.
 */

#ifdef MW_DSP_RT
#include "src/dspmmutils_rt.h"
#else
#include "dspmmutils_rt.h"
#endif

#if (!defined(INTEGER_CODE) || !INTEGER_CODE)

#define DOUBLE_255      255.0
#define FLOAT_255       255.0f

/*  bwherry 7/20/2004 - fix for g222770
    Added support for non-multiple-of-4 width video.  DirectShow needs row
    strides to align with DWORD boundaries.  That's what the stridePadding
    stuff is all about.
    Look here for more info:
    http://msdn.microsoft.com/archive/default.asp?url=/archive/en-us/directx9_c/
    directx/htm/stride.asp
*/

/* //////////////////////////////// Uint8 ///////////////////////////////// */
                
/*  Input:      RGB24 video frame */
/*  Output:     Uint8 matrix */
void CopyRGB24VideoFrame_ToUint8(void* source, 
                                 void* target,
                                 int_T width,
                                 int_T height,
                                 VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    uint8_T* redOut = (uint8_T *)target;
    uint8_T* greenOut = redOut + frameArea;
    uint8_T* blueOut = greenOut + frameArea;
    CopyRGB24VideoFrame_ToUint8_Channels(source, 
                                         redOut, greenOut, blueOut,
                                         width, height, rowOrColumn);
}

/*  Input:      RGB24 video frame */
/*  Output:     three Uint8 matrices */
void CopyRGB24VideoFrame_ToUint8_Channels(void* source, 
                                          void* targetRed,
                                          void* targetGreen,
                                          void* targetBlue,
                                          int_T width,
                                          int_T height,
                                          VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    uint8_T* redOut = (uint8_T*)targetRed;
    uint8_T* greenOut = (uint8_T*)targetGreen;
    uint8_T* blueOut = (uint8_T*)targetBlue;
    uint32_T rowBytes = width * 3;
    uint32_T result = rowBytes % 4;
    uint32_T stridePadding = result == 0 ? 0 : 4 - result;
    uint32_T byteOffsetFromStart = height * width * 3 + 
        (stridePadding * height) - 3;
    MM_RGBTRIPLE* rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)source) + 
                                            byteOffsetFromStart);

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount;
        int_T hCount;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(wCount = width-1; wCount >= 0; wCount--, rgbIn--)
            {
                blueOut[wCount] = rgbIn->rgbtBlue;
                greenOut[wCount] = rgbIn->rgbtGreen;
                redOut[wCount] = rgbIn->rgbtRed;
            }
            blueOut  += width;
            greenOut += width;
            redOut   += width;
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        blueOut += frameArea;
        greenOut += frameArea;
        redOut += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbIn--)
            {
                blueOut -= height;
                greenOut -= height;
                redOut -= height;

                *blueOut = rgbIn->rgbtBlue;
                *greenOut = rgbIn->rgbtGreen;
                *redOut = rgbIn->rgbtRed;
            }
            blueOut += (frameArea + 1);
            greenOut += (frameArea + 1);
            redOut += (frameArea + 1);
        }
    }
}


/*  Input:      (none) */
/*  Output:     black RGB24 video frame as Uint8 matrix */
void EmptyRGB24VideoFrame_ToUint8(void* source, 
                                  void* target,
                                  int_T width,
                                  int_T height,
                                  VideoFrameOrientation rowOrColumn)
{
    (void)source; /* silence warnings */
    (void)rowOrColumn;

    memset(target, 0, (width * height * 3));
}

                
/*  Input:      (none) */
/*  Output:     black RGB24 video frame as three Uint8 matrices */
void EmptyRGB24VideoFrame_ToUint8_Channels(void* source, 
                                           void* targetRed,
                                           void* targetGreen,
                                           void* targetBlue,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;

    (void)source; /* silence warnings */
    (void)rowOrColumn;

    memset(targetRed, 0, frameArea);
    memset(targetGreen, 0, frameArea);
    memset(targetBlue, 0, frameArea);
}



/* ///////////////////////// Int8 //////////////////////////////////////// */
                
/*  Input:      RGB24 video frame */
/*  Output:     Int8 matrix */
void CopyRGB24VideoFrame_ToInt8(void* source, 
                                void* target,
                                int_T width,
                                int_T height,
                                VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    char_T* redOut = (char_T*)target;
    char_T* greenOut = redOut + frameArea;
    char_T* blueOut = greenOut + frameArea;
    CopyRGB24VideoFrame_ToInt8_Channels(source, 
                                        redOut, greenOut, blueOut,
                                        width, height, rowOrColumn);
}

                
/*  Input:      RGB24 video frame */
/*  Output:     three Int8 matrices */
void CopyRGB24VideoFrame_ToInt8_Channels(void* source, 
                                         void* targetRed,
                                         void* targetGreen,
                                         void* targetBlue,
                                         int_T width,
                                         int_T height,
                                         VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    char_T* redOut = (char_T*)targetRed;
    char_T* greenOut = (char_T*)targetGreen;
    char_T* blueOut = (char_T*)targetBlue;
    uint32_T rowBytes = width * 3;
    uint32_T result = rowBytes % 4;
    uint32_T stridePadding = result == 0 ? 0 : 4 - result;
    uint32_T byteOffsetFromStart = height * width * 3 + 
        (stridePadding * height) - 3;
    MM_RGBTRIPLE* rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)source) + 
                                            byteOffsetFromStart);

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount;
        int_T hCount;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(wCount = width-1; wCount >= 0; wCount--, rgbIn--)
            {
                blueOut[wCount] = (char_T)((int16_T)rgbIn->rgbtBlue - 128);
                greenOut[wCount] = (char_T)((int16_T)rgbIn->rgbtGreen - 128);
                redOut[wCount] = (char_T)((int16_T)rgbIn->rgbtRed - 128);
            }
            blueOut  += width;
            greenOut += width;
            redOut   += width;
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        blueOut += frameArea;
        greenOut += frameArea;
        redOut += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbIn--)
            {
                blueOut -= height;
                greenOut -= height;
                redOut -= height;

                *blueOut = (char_T)((int16_T)rgbIn->rgbtBlue - 128);
                *greenOut = (char_T)((int16_T)rgbIn->rgbtGreen - 128);
                *redOut = (char_T)((int16_T)rgbIn->rgbtRed - 128);
            }
            blueOut += (frameArea + 1);
            greenOut += (frameArea + 1);
            redOut += (frameArea + 1);
        }
    }
}


/*  Input:      (none) */
/*  Output:     black RGB24 video frame as Int8 matrix */
void EmptyRGB24VideoFrame_ToInt8(void* source, 
                                 void* target,
                                 int_T width,
                                 int_T height,
                                 VideoFrameOrientation rowOrColumn)
{
    (void)source; /* silence warnings */
    (void)rowOrColumn;

    memset(target, SCHAR_MIN, (width * height * 3));
}

                
/*  Input:      (none) */
/*  Output:     black RGB24 video frame as three Uint8 matrices */
void EmptyRGB24VideoFrame_ToInt8_Channels(void* source, 
                                          void* targetRed,
                                          void* targetGreen,
                                          void* targetBlue,
                                          int_T width,
                                          int_T height,
                                          VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;

    (void)source; /* silence warnings */
    (void)rowOrColumn;

    memset(targetRed, SCHAR_MIN, frameArea);
    memset(targetGreen, SCHAR_MIN, frameArea);
    memset(targetBlue, SCHAR_MIN, frameArea);
}





/* ///////////////////////// Int16 /////////////////////////////////////// */
                
/*  Input:      RGB24 video frame */
/*  Output:     Int16 matrix */
void CopyRGB24VideoFrame_ToInt16(void* source, 
                                 void* target,
                                 int_T width,
                                 int_T height,
                                 VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    int16_T* redOut = (int16_T*)target;
    int16_T* greenOut = redOut + frameArea;
    int16_T* blueOut = greenOut + frameArea;
    CopyRGB24VideoFrame_ToInt16_Channels(source, 
                                         redOut, greenOut, blueOut,
                                         width, height, rowOrColumn);
}

                
/*  Input:      RGB24 video frame */
/*  Output:     three Int16 matrices */
void CopyRGB24VideoFrame_ToInt16_Channels(void* source, 
                                          void* targetRed,
                                          void* targetGreen,
                                          void* targetBlue,
                                          int_T width,
                                          int_T height,
                                          VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    int16_T* redOut = (int16_T*)targetRed;
    int16_T* greenOut = (int16_T*)targetGreen;
    int16_T* blueOut = (int16_T*)targetBlue;
    real_T factor = 257.0;
    real_T bias = 32768.0;
    uint32_T rowBytes = width * 3;
    uint32_T result = rowBytes % 4;
    uint32_T stridePadding = result == 0 ? 0 : 4 - result;
    uint32_T byteOffsetFromStart = height * width * 3 + 
        (stridePadding * height) - 3;
    MM_RGBTRIPLE* rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)source) +
                                            byteOffsetFromStart);

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount;
        int_T hCount;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(wCount = width-1; wCount >= 0; wCount--, rgbIn--)
            {
                blueOut[wCount] = (int16_T)((real_T)rgbIn->rgbtBlue * factor - bias);
                greenOut[wCount] = 
                    (int16_T)((real_T)rgbIn->rgbtGreen * factor - bias);
                redOut[wCount] = (int16_T)((real_T)rgbIn->rgbtRed * factor - bias);
            }
            blueOut  += width;
            greenOut += width;
            redOut   += width;
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        blueOut += frameArea;
        greenOut += frameArea;
        redOut += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbIn--)
            {
                blueOut -= height;
                greenOut -= height;
                redOut -= height;

                *blueOut = (int16_T)((real_T)rgbIn->rgbtBlue * factor - bias);
                *greenOut = (int16_T)((real_T)rgbIn->rgbtGreen * factor - bias);
                *redOut = (int16_T)((real_T)rgbIn->rgbtRed * factor - bias);
            }
            blueOut += (frameArea + 1);
            greenOut += (frameArea + 1);
            redOut += (frameArea + 1);
        }
    }
}


/*  Input:      (none) */
/*  Output:     black RGB24 video frame as Int16 matrix */
void EmptyRGB24VideoFrame_ToInt16(void* source, 
                                  void* target,
                                  int_T width,
                                  int_T height,
                                  VideoFrameOrientation rowOrColumn)
{
    size_t frameArea = width * height * 3;
    int16_T* ptr = (int16_T*)target;
    size_t count;

    (void)source; /* silence warnings */
    (void)rowOrColumn;

    for(count = 0; count < frameArea; count++)
        *ptr++ = SHRT_MIN;
}

                
/*  Input:      (none) */
/*  Output:     black RGB24 video frame as three Uint16 matrices */
void EmptyRGB24VideoFrame_ToInt16_Channels(void* source, 
                                           void* targetRed,
                                           void* targetGreen,
                                           void* targetBlue,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn)
{
    size_t frameArea = width * height;
    int16_T* rPtr = (int16_T*)targetRed;
    int16_T* gPtr = (int16_T*)targetGreen;
    int16_T* bPtr = (int16_T*)targetBlue;
    size_t count;

    (void)source; /* silence warnings */
    (void)rowOrColumn;

    for(count = 0; count < frameArea; count++)
    {
        *rPtr++ = SHRT_MIN;
        *gPtr++ = SHRT_MIN;
        *bPtr++ = SHRT_MIN;
    }
}



/* //////////////////////// Uint16 //////////////////////////////////// */
                
/*  Input:      RGB24 video frame */
/*  Output:     Uint16 matrix */
void CopyRGB24VideoFrame_ToUint16(void* source, 
                                  void* target,
                                  int_T width,
                                  int_T height,
                                  VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    uint16_T* redOut = (uint16_T*)target;
    uint16_T* greenOut = redOut + frameArea;
    uint16_T* blueOut = greenOut + frameArea;
    CopyRGB24VideoFrame_ToUint16_Channels(source, 
                                          redOut, greenOut, blueOut,
                                          width, height, rowOrColumn);
}

                
/*  Input:      RGB24 video frame */
/*  Output:     three Uint16 matrices */
void CopyRGB24VideoFrame_ToUint16_Channels(void* source, 
                                           void* targetRed,
                                           void* targetGreen,
                                           void* targetBlue,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    uint16_T* redOut = (uint16_T*)targetRed;
    uint16_T* greenOut = (uint16_T*)targetGreen;
    uint16_T* blueOut = (uint16_T*)targetBlue;
    uint16_T val;
    uint32_T rowBytes = width * 3;
    uint32_T result = rowBytes % 4;
    uint32_T stridePadding = result == 0 ? 0 : 4 - result;
    uint32_T byteOffsetFromStart = height * width * 3 + (stridePadding * height) - 3;
    MM_RGBTRIPLE* rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)source) + byteOffsetFromStart);

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount;
        int_T hCount;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(wCount = width-1; wCount >= 0; wCount--, rgbIn--)
            {
                val = (uint16_T)rgbIn->rgbtBlue;
                blueOut[wCount] = (val << 8) | val;
                val = (uint16_T)rgbIn->rgbtGreen;
                greenOut[wCount] = (val << 8) | val;
                val = (uint16_T)rgbIn->rgbtRed;
                redOut[wCount] = (val << 8) | val;
            }
            blueOut  += width;
            greenOut += width;
            redOut   += width;
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        blueOut += frameArea;
        greenOut += frameArea;
        redOut += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbIn--)
            {
                blueOut -= height;
                greenOut -= height;
                redOut -= height;

                val = (uint16_T)rgbIn->rgbtBlue;
                *blueOut = (val << 8) | val;
                val = (uint16_T)rgbIn->rgbtGreen;
                *greenOut = (val << 8) | val;
                val = (uint16_T)rgbIn->rgbtRed;
                *redOut = (val << 8) | val;
            }
            blueOut += (frameArea + 1);
            greenOut += (frameArea + 1);
            redOut += (frameArea + 1);
        }
    }
}


/*  Input:      (none) */
/*  Output:     black RGB24 video frame as Uint16 matrix */
void EmptyRGB24VideoFrame_ToUint16(void* source, 
                                   void* target,
                                   int_T width,
                                   int_T height,
                                   VideoFrameOrientation rowOrColumn)
{
    (void)source; /* silence warnings */
    (void)rowOrColumn;

    memset(target, 0, (width * height * 3) * sizeof(uint16_T));
}

                
/*  Input:      (none) */
/*  Output:     black RGB24 video frame as three Uint16 matrices */
void EmptyRGB24VideoFrame_ToUint16_Channels(void* source, 
                                            void* targetRed,
                                            void* targetGreen,
                                            void* targetBlue,
                                            int_T width,
                                            int_T height,
                                            VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;

    (void)source; /* silence warnings */
    (void)rowOrColumn;

    memset(targetRed, 0, frameArea * sizeof(uint16_T));
    memset(targetGreen, 0, frameArea * sizeof(uint16_T));
    memset(targetBlue, 0, frameArea * sizeof(uint16_T));
}




/* ////////////////////////////// Int32 ////////////////////////////////// */
                
/*  Input:      RGB24 video frame */
/*  Output:     Int32 matrix */
void CopyRGB24VideoFrame_ToInt32(void* source, 
                                 void* target,
                                 int_T width,
                                 int_T height,
                                 VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    int32_T* redOut = (int32_T*)target;
    int32_T* greenOut = redOut + frameArea;
    int32_T* blueOut = greenOut + frameArea;
    CopyRGB24VideoFrame_ToInt32_Channels(source, 
                                         redOut, greenOut, blueOut,
                                         width, height, rowOrColumn);
}

                
/*  Input:      RGB24 video frame */
/*  Output:     three Int32 matrices */
void CopyRGB24VideoFrame_ToInt32_Channels(void* source, 
                                          void* targetRed,
                                          void* targetGreen,
                                          void* targetBlue,
                                          int_T width,
                                          int_T height,
                                          VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    int32_T* redOut = (int32_T*)targetRed;
    int32_T* greenOut = (int32_T*)targetGreen;
    int32_T* blueOut = (int32_T*)targetBlue;
    real_T factor = 16843009.0;
    real_T bias = 2147483648.0;
    uint32_T rowBytes = width * 3;
    uint32_T result = rowBytes % 4;
    uint32_T stridePadding = result == 0 ? 0 : 4 - result;
    uint32_T byteOffsetFromStart = height * width * 3 + (stridePadding * height) - 3;
    MM_RGBTRIPLE* rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)source) + byteOffsetFromStart);

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount;
        int_T hCount;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(wCount = width-1; wCount >= 0; wCount--, rgbIn--)
            {
                blueOut[wCount] = (int32_T)((real_T)rgbIn->rgbtBlue * factor - bias);
                greenOut[wCount] = (int32_T)((real_T)rgbIn->rgbtGreen * factor - bias);
                redOut[wCount] = (int32_T)((real_T)rgbIn->rgbtRed * factor - bias);
            }
            blueOut  += width;
            greenOut += width;
            redOut   += width;
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        blueOut += frameArea;
        greenOut += frameArea;
        redOut += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbIn--)
            {
                blueOut -= height;
                greenOut -= height;
                redOut -= height;

                *blueOut = (int32_T)((real_T)rgbIn->rgbtBlue * factor - bias);
                *greenOut = (int32_T)((real_T)rgbIn->rgbtGreen * factor - bias);
                *redOut = (int32_T)((real_T)rgbIn->rgbtRed * factor - bias);
            }
            blueOut += (frameArea + 1);
            greenOut += (frameArea + 1);
            redOut += (frameArea + 1);
        }
    }
}


/*  Input:      (none) */
/*  Output:     black RGB24 video frame as Int32 matrix */
void EmptyRGB24VideoFrame_ToInt32(void* source, 
                                  void* target,
                                  int_T width,
                                  int_T height,
                                  VideoFrameOrientation rowOrColumn)
{
    size_t frameArea = width * height * 3;
    int32_T* ptr = (int32_T*)target;
    size_t count;

    (void)source; /* silence warnings */
    (void)rowOrColumn;

    for(count = 0; count < frameArea; count++)
        *ptr++ = MIN_int32_T;
}

                
/*  Input:      (none) */
/*  Output:     black RGB24 video frame as three Uint32 matrices */
void EmptyRGB24VideoFrame_ToInt32_Channels(void* source, 
                                           void* targetRed,
                                           void* targetGreen,
                                           void* targetBlue,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn)
{
    size_t frameArea = width * height;
    int32_T* rPtr = (int32_T*)targetRed;
    int32_T* gPtr = (int32_T*)targetGreen;
    int32_T* bPtr = (int32_T*)targetBlue;
    size_t count;
        
    (void)source; /* silence warnings */
    (void)rowOrColumn;

    for(count = 0; count < frameArea; count++)
    {
        *rPtr++ = MIN_int32_T;
        *gPtr++ = MIN_int32_T;
        *bPtr++ = MIN_int32_T;
    }
}


/* /////////////////////////// Uint32 ///////////////////////////////////// */
                
/*  Input:      RGB24 video frame */
/*  Output:     Uint32 matrix */
void CopyRGB24VideoFrame_ToUint32(void* source, 
                                  void* target,
                                  int_T width,
                                  int_T height,
                                  VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    uint32_T* redOut = (uint32_T*)target;
    uint32_T* greenOut = redOut + frameArea;
    uint32_T* blueOut = greenOut + frameArea;
    CopyRGB24VideoFrame_ToUint32_Channels(source, 
                                          redOut, greenOut, blueOut,
                                          width, height, rowOrColumn);
}

                
/*  Input:      RGB24 video frame */
/*  Output:     three Uint32 matrices */
void CopyRGB24VideoFrame_ToUint32_Channels(void* source, 
                                           void* targetRed,
                                           void* targetGreen,
                                           void* targetBlue,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    uint32_T* redOut = (uint32_T*)targetRed;
    uint32_T* greenOut = (uint32_T*)targetGreen;
    uint32_T* blueOut = (uint32_T*)targetBlue;
    uint32_T val;
    uint32_T rowBytes = width * 3;
    uint32_T result = rowBytes % 4;
    uint32_T stridePadding = result == 0 ? 0 : 4 - result;
    uint32_T byteOffsetFromStart = height * width * 3 + (stridePadding * height) - 3;
    MM_RGBTRIPLE* rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)source) + byteOffsetFromStart);

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount;
        int_T hCount;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(wCount = width-1; wCount >= 0; wCount--, rgbIn--)
            {
                val = (uint32_T)rgbIn->rgbtBlue;
                val = (val << 8) | val;
                val = (val << 16) | val;
                blueOut[wCount] = (val << 16) | val;

                val = (uint32_T)rgbIn->rgbtGreen;
                val = (val << 8) | val;
                val = (val << 16) | val;
                greenOut[wCount] = (val << 16) | val;
                        
                val = (uint32_T)rgbIn->rgbtRed;
                val = (val << 8) | val;
                val = (val << 16) | val;
                redOut[wCount] = (val << 16) | val;
            }
            blueOut  += width;
            greenOut += width;
            redOut   += width;
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        blueOut += frameArea;
        greenOut += frameArea;
        redOut += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbIn--)
            {
                blueOut -= height;
                greenOut -= height;
                redOut -= height;

                val = (uint32_T)rgbIn->rgbtBlue;
                val = (val << 8) | val;
                val = (val << 16) | val;
                *blueOut = (val << 16) | val;

                val = (uint32_T)rgbIn->rgbtGreen;
                val = (val << 8) | val;
                val = (val << 16) | val;
                *greenOut = (val << 16) | val;
                                
                val = (uint32_T)rgbIn->rgbtRed;
                val = (val << 8) | val;
                val = (val << 16) | val;
                *redOut = (val << 16) | val;
            }
            blueOut += (frameArea + 1);
            greenOut += (frameArea + 1);
            redOut += (frameArea + 1);
        }
    }
}


/*  Input:      (none) */
/*  Output:     black RGB24 video frame as Uint32 matrix */
void EmptyRGB24VideoFrame_ToUint32(void* source, 
                                   void* target,
                                   int_T width,
                                   int_T height,
                                   VideoFrameOrientation rowOrColumn)
{
    (void)source; /* silence warnings */
    (void)rowOrColumn;

    memset(target, 0, (width * height * 3) * sizeof(uint32_T));
}

                
/*  Input:      (none) */
/*  Output:     black RGB24 video frame as three Uint16 matrices */
void EmptyRGB24VideoFrame_ToUint32_Channels(void* source, 
                                            void* targetRed,
                                            void* targetGreen,
                                            void* targetBlue,
                                            int_T width,
                                            int_T height,
                                            VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;

    (void)source; /* silence warnings */
    (void)rowOrColumn;

    memset(targetRed, 0, frameArea * sizeof(uint32_T));
    memset(targetGreen, 0, frameArea * sizeof(uint32_T));
    memset(targetBlue, 0, frameArea * sizeof(uint32_T));
}






/* ///////////////////////// Double //////////////////////////////////// */

/*  Input:      RGB24 video frame */
/*  Output:     Double matrix */
void CopyRGB24VideoFrame_ToDouble(void* source, 
                                  void* target,
                                  int_T width,
                                  int_T height,
                                  VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    real_T* redOut = (real_T*)target;
    real_T* greenOut = redOut + frameArea;
    real_T* blueOut = greenOut + frameArea;
    CopyRGB24VideoFrame_ToDouble_Channels(source, 
                                          redOut, greenOut, blueOut,
                                          width, height, rowOrColumn);
}
                
/*  Input:      RGB24 video frame */
/*  Output:     three Double matrices */
void CopyRGB24VideoFrame_ToDouble_Channels(void* source, 
                                           void* targetRed,
                                           void* targetGreen,
                                           void* targetBlue,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    real_T* redOut = (real_T*)targetRed;
    real_T* greenOut = (real_T*)targetGreen;
    real_T* blueOut = (real_T*)targetBlue;
    uint32_T rowBytes = width * 3;
    uint32_T result = rowBytes % 4;
    uint32_T stridePadding = result == 0 ? 0 : 4 - result;
    uint32_T byteOffsetFromStart = height * width * 3 + (stridePadding * height) - 3;
    MM_RGBTRIPLE* rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)source) + byteOffsetFromStart);

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount;
        int_T hCount;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(wCount = width-1; wCount >= 0; wCount--, rgbIn--)
            {
                blueOut[wCount]  = ((real_T)(rgbIn->rgbtBlue))  / DOUBLE_255;
                greenOut[wCount] = ((real_T)(rgbIn->rgbtGreen)) / DOUBLE_255;
                redOut[wCount]   = ((real_T)(rgbIn->rgbtRed))   / DOUBLE_255;
            }
            blueOut  += width;
            greenOut += width;
            redOut   += width;
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        blueOut += frameArea;
        greenOut += frameArea;
        redOut += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbIn--)
            {
                blueOut -= height;
                greenOut -= height;
                redOut -= height;

                *blueOut = ((real_T)(rgbIn->rgbtBlue)) / DOUBLE_255;
                *greenOut = ((real_T)(rgbIn->rgbtGreen)) / DOUBLE_255;
                *redOut = ((real_T)(rgbIn->rgbtRed)) / DOUBLE_255;
            }
            blueOut += (frameArea + 1);
            greenOut += (frameArea + 1);
            redOut += (frameArea + 1);
        }
    }
}


                
/*  Input:      (none) */
/*  Output:     black RGB24 video frame as Double matrix */
void EmptyRGB24VideoFrame_ToDouble(void* source, 
                                   void* target,
                                   int_T width,
                                   int_T height,
                                   VideoFrameOrientation rowOrColumn)
{
    real_T zero = 0.0;
    real_T* out = (real_T*) target;
    int_T count = 0;
    int_T framePixels = width * height * 3;

    (void)source; /* silence warnings */
    (void)rowOrColumn;

    for(; count < framePixels; count++)
        *out++ = zero;
}

                
/*  Input:      (none) */
/*  Output:     black RGB24 video frame as three Double matrices */
void EmptyRGB24VideoFrame_ToDouble_Channels(void* source, 
                                            void* targetRed,
                                            void* targetGreen,
                                            void* targetBlue,
                                            int_T width,
                                            int_T height,
                                            VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    real_T* outRed = (real_T*) targetRed;
    real_T* outGreen = (real_T*) targetGreen;
    real_T* outBlue = (real_T*) targetBlue;
    real_T zero = 0.0;
    int_T count;

    (void)source; /* silence warnings */
    (void)rowOrColumn;

    for(count = 0; count < frameArea; count++)
    {
        *outRed++ = zero;
        *outGreen++ = zero;
        *outBlue++ = zero;
    }
}




/* ////////////////////////////// Single ///////////////////////////////// */

/*  Input:      RGB24 video frame */
/*  Output:     Single matrix */
void CopyRGB24VideoFrame_ToSingle(void* source, 
                                  void* target,
                                  int_T width,
                                  int_T height,
                                  VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    real32_T* redOut = (real32_T*)target;
    real32_T* greenOut = redOut + frameArea;
    real32_T* blueOut = greenOut + frameArea;
    CopyRGB24VideoFrame_ToSingle_Channels(source, 
                                          redOut, greenOut, blueOut,
                                          width, height, rowOrColumn);
}

                
/*  Input:      RGB24 video frame */
/*  Output:     three Single matrices */
void CopyRGB24VideoFrame_ToSingle_Channels(void* source, 
                                           void* targetRed,
                                           void* targetGreen,
                                           void* targetBlue,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    real32_T* redOut = (real32_T*)targetRed;
    real32_T* greenOut = (real32_T*)targetGreen;
    real32_T* blueOut = (real32_T*)targetBlue;
    uint32_T rowBytes = width * 3;
    uint32_T result = rowBytes % 4;
    uint32_T stridePadding = result == 0 ? 0 : 4 - result;
    uint32_T byteOffsetFromStart = height * width * 3 + (stridePadding * height) - 3;
    MM_RGBTRIPLE* rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)source) + byteOffsetFromStart);

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount;
        int_T hCount;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(wCount = width-1; wCount >= 0; wCount--, rgbIn--)
            {
                blueOut[wCount]  = ((real32_T)(rgbIn->rgbtBlue))  / FLOAT_255;
                greenOut[wCount] = ((real32_T)(rgbIn->rgbtGreen)) / FLOAT_255;
                redOut[wCount]   = ((real32_T)(rgbIn->rgbtRed))   / FLOAT_255;
            }
            blueOut  += width;
            greenOut += width;
            redOut   += width;
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        blueOut  += frameArea;
        greenOut += frameArea;
        redOut   += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbIn--)
            {
                blueOut -= height;
                greenOut -= height;
                redOut -= height;

                *blueOut = ((real32_T)(rgbIn->rgbtBlue)) / FLOAT_255;
                *greenOut = ((real32_T)(rgbIn->rgbtGreen)) / FLOAT_255;
                *redOut = ((real32_T)(rgbIn->rgbtRed)) / FLOAT_255;
            }
            blueOut += (frameArea + 1);
            greenOut += (frameArea + 1);
            redOut += (frameArea + 1);
        }
    }
}


/*  Input:      (none) */
/*  Output:     black RGB24 video frame as Single matrix */
void EmptyRGB24VideoFrame_ToSingle(void* source, 
                                   void* target,
                                   int_T width,
                                   int_T height,
                                   VideoFrameOrientation rowOrColumn)
{
    real32_T zero = 0.0f;
    real32_T* out = (real32_T*) target;
    int_T count = 0;
    int_T framePixels = width * height * 3;

    (void)source; /* silence warnings */
    (void)rowOrColumn;

    for(; count < framePixels; count++)
        *out++ = zero;
}


                
/*  Input:      (none) */
/*  Output:     black RGB24 video frame as three Single matrices */
void EmptyRGB24VideoFrame_ToSingle_Channels(void* source, 
                                            void* targetRed,
                                            void* targetGreen,
                                            void* targetBlue,
                                            int_T width,
                                            int_T height,
                                            VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    real32_T* outRed = (real32_T*) targetRed;
    real32_T* outGreen = (real32_T*) targetGreen;
    real32_T* outBlue = (real32_T*) targetBlue;
    real32_T zero = 0.0f;
    int_T count;

    (void)source; /* silence warnings */
    (void)rowOrColumn;

    for(count = 0; count < frameArea; count++)
    {
        *outRed++ = zero;
        *outGreen++ = zero;
        *outBlue++ = zero;
    }
}


#define NUM_DTYPES      9               /* right now, anyway */

static COPY_RGB24_FUNC rgb24CopyFcns[] = 
{
    /*  VideoDataType_Double = 0,       double  */
    CopyRGB24VideoFrame_ToDouble,
    /*  VideoDataType_Single,           float  */
    CopyRGB24VideoFrame_ToSingle,
    /*  VideoDataType_Int8,             char_T */
    CopyRGB24VideoFrame_ToInt8,
    /*  VideoDataType_Uint8,            uint8_T */
    CopyRGB24VideoFrame_ToUint8,
    /*  VideoDataType_Int16,            int16_T */
    CopyRGB24VideoFrame_ToInt16,
    /*  VideoDataType_Uint16,           uint16_T */
    CopyRGB24VideoFrame_ToUint16,
    /*  VideoDataType_Int32,            int32_T */
    CopyRGB24VideoFrame_ToInt32,
    /*  VideoDataType_Uint32,           uint32_T */
    CopyRGB24VideoFrame_ToUint32,
    /*  VideoDataType_Boolean           bool */
    (COPY_RGB24_FUNC) NULL
};

static COPY_RGB24_CHANS_FUNC rgb24ChannelsCopyFcns[] = 
{
    /*  VideoDataType_Double = 0,       double */
    CopyRGB24VideoFrame_ToDouble_Channels,
    /*  VideoDataType_Single,            float */
    CopyRGB24VideoFrame_ToSingle_Channels,
    /*  VideoDataType_Int8,             char_T */
    CopyRGB24VideoFrame_ToInt8_Channels,
    /*  VideoDataType_Uint8,            uint8_T */
    CopyRGB24VideoFrame_ToUint8_Channels,
    /*  VideoDataType_Int16,             int16_T */
    CopyRGB24VideoFrame_ToInt16_Channels,
    /*  VideoDataType_Uint16,            uint16_T */
    CopyRGB24VideoFrame_ToUint16_Channels,
    /*  VideoDataType_Int32,             int32_T */
    CopyRGB24VideoFrame_ToInt32_Channels,
    /*  VideoDataType_Uint32,            uint32_T */
    CopyRGB24VideoFrame_ToUint32_Channels,
    /*  VideoDataType_Boolean            bool */
    (COPY_RGB24_CHANS_FUNC) NULL
};



static COPY_RGB24_FUNC rgb24EmptyFcns[] = 
{
    /*  VideoDataType_Double = 0,        double */
    EmptyRGB24VideoFrame_ToDouble,
    /*  VideoDataType_Single,            float */
    EmptyRGB24VideoFrame_ToSingle,
    /*  VideoDataType_Int8,              char_T */
    EmptyRGB24VideoFrame_ToInt8,
    /*  VideoDataType_Uint8,             uint8_T */
    EmptyRGB24VideoFrame_ToUint8,
    /*  VideoDataType_Int16,             int16_T */
    EmptyRGB24VideoFrame_ToInt16,
    /*  VideoDataType_Uint16,            uint16_T */
    EmptyRGB24VideoFrame_ToUint16,
    /*  VideoDataType_Int32,             int32_T */
    EmptyRGB24VideoFrame_ToInt32,
    /*  VideoDataType_Uint32,            uint32_T */
    EmptyRGB24VideoFrame_ToUint32,
    /*  VideoDataType_Boolean            bool */
    (COPY_RGB24_FUNC) NULL
};

static COPY_RGB24_CHANS_FUNC rgb24ChannelsEmptyFcns[] = 
{
    /*  VideoDataType_Double = 0,        double */
    EmptyRGB24VideoFrame_ToDouble_Channels,
    /*  VideoDataType_Single,            float */
    EmptyRGB24VideoFrame_ToSingle_Channels,
    /*  VideoDataType_Int8,              char_T */
    EmptyRGB24VideoFrame_ToInt8_Channels,
    /*  VideoDataType_Uint8,             uint8_T */
    EmptyRGB24VideoFrame_ToUint8_Channels,
    /*  VideoDataType_Int16,             int16_T */
    EmptyRGB24VideoFrame_ToInt16_Channels,
    /*  VideoDataType_Uint16,            uint16_T */
    EmptyRGB24VideoFrame_ToUint16_Channels,
    /*  VideoDataType_Int32,             int32_T */
    EmptyRGB24VideoFrame_ToInt32_Channels,
    /*  VideoDataType_Uint32,            uint32_T */
    EmptyRGB24VideoFrame_ToUint32_Channels,
    /*  VideoDataType_Boolean            bool */
    (COPY_RGB24_CHANS_FUNC) NULL
};



COPY_RGB24_FUNC MWDSP_GetRGB24CopyFcn(VideoDataType dType)
{
    int_T offset = dType;
    if(offset >= 0 && offset < NUM_DTYPES)
        return rgb24CopyFcns[offset];
    else
        return (COPY_RGB24_FUNC) NULL;
}

COPY_RGB24_CHANS_FUNC MWDSP_GetRGB24ChannelsCopyFcn(VideoDataType dType)
{
    int_T offset = dType;
    if(offset >= 0 && offset < NUM_DTYPES)
        return rgb24ChannelsCopyFcns[offset];
    else
        return (COPY_RGB24_CHANS_FUNC) NULL;
}

COPY_RGB24_FUNC MWDSP_GetRGB24EmptyFcn(VideoDataType dType)
{
    int_T offset = dType;
    if(offset >= 0 && offset < NUM_DTYPES)
        return rgb24EmptyFcns[offset];
    else
        return (COPY_RGB24_FUNC) NULL;
}

COPY_RGB24_CHANS_FUNC MWDSP_GetRGB24ChannelsEmptyFcn(VideoDataType dType)
{
    int_T offset = dType;
    if(offset >= 0 && offset < NUM_DTYPES)
        return rgb24ChannelsEmptyFcns[offset];
    else
        return (COPY_RGB24_CHANS_FUNC) NULL;
}

#endif /* !INTEGER_CODE */

/* [EOF] mmrgb24convert_rt.c */
