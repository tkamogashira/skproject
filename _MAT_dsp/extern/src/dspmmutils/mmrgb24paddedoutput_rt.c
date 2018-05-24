/*
 * mmrgb24paddedoutput_rt.c.c:  contains routines for outputting video frames
 * after padding. 
 *
 * Copyright 2005-2013 The MathWorks, Inc.
 */

/* ///////////////////////////////////////////////////////////////////////////// */
/*  RGB24 PADDED VIDEO OUTPUT FUNCTIONS -                                        */
/*  - assumes space is allocated for DWORD-aligned (4-byte multiple) row stride  */
/*    (DirectShow assumes this)                                                  */
/* /////////////////////////////////////////////////////////////////////// ///// */

#ifdef MW_DSP_RT
#include "src/dspmmutils_rt.h"
#else
#include "dspmmutils_rt.h"
#endif

#if (!defined(INTEGER_CODE) || !INTEGER_CODE)

#define DOUBLE_255      255.0
#define FLOAT_255       255.0f
#define UINT8_255       255

/*  bwherry 7/20/2004                                                                        */
/*    Changed around the way this is done.  We don't really need to make the image bigger    */
/*    (as was done before), we just need to pad the row strides to DWORD boundaries. That's  */
/*    what the stridePadding stuff is all about.                                             */
/*    Look here for more info:                                                               */
/*      http://msdn.microsoft.com/library/default.asp?url=/library/en-us/directx9_c/directx/htm/stride.asp */


/* ////////////////////////////////// Uint8 //////////////////////////////////// */
                
/*  Input:      Uint8 matrix */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromUint8(const void* input,
                                                                         void* output,
                                                                         int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const uint8_T* redIn = (const uint8_T*)input;
    const uint8_T* greenIn = redIn + frameArea;
    const uint8_T* blueIn = greenIn + frameArea;

    OutputPaddedRGB24VideoFrame_FromUint8_Channels(redIn, greenIn, blueIn,
                                                   output, width, height,
                                                   rowOrColumn);
}


                
/*  Input:      three Uint8 matrices */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromUint8_Channels(const void* sourceRed,
                                                    const void* sourceGreen,
                                                    const void* sourceBlue,
                                                    void* output,
                                                    int_T width,
                                                    int_T height,
                                                    VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const uint8_T* redIn = (const uint8_T*)sourceRed;
    const uint8_T* greenIn = (const uint8_T*)sourceGreen;
    const uint8_T* blueIn = (const uint8_T*)sourceBlue;
    uint32_T rowBytes = width * 3;
    uint32_T result = rowBytes % 4;
    uint32_T stridePadding = result == 0 ? 0 : 4 - result;
    uint32_T byteOffsetFromStart = height * width * 3 + (stridePadding * height) - 3;
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)output) + byteOffsetFromStart);

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount, hCount;

        rgbOut++;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding)-width;
            for(wCount = 0; wCount < width; wCount++)
            {
                rgbOut[wCount].rgbtBlue  = *blueIn++;
                rgbOut[wCount].rgbtGreen = *greenIn++;
                rgbOut[wCount].rgbtRed   = *redIn++;
            }
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;
        
        blueIn += frameArea;
        greenIn += frameArea;
        redIn += frameArea;

        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbOut--)
            {
                blueIn -= height;
                greenIn -= height;
                redIn -= height;

                rgbOut->rgbtBlue = *blueIn;
                rgbOut->rgbtGreen = *greenIn;
                rgbOut->rgbtRed = *redIn;
            }
            blueIn += (frameArea + 1);
            greenIn += (frameArea + 1);
            redIn += (frameArea + 1);
        }
    }
}


/* ////////////////////////////////// Int8 //////////////////////////////////// */
                
/*  Input:      Int8 matrix */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromInt8(const void* input,
                                          void* output,
                                          int_T width,
                                          int_T height,
                                          VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const char_T* redIn = (const char_T*)input;
    const char_T* greenIn = redIn + frameArea;
    const char_T* blueIn = greenIn + frameArea;

    OutputPaddedRGB24VideoFrame_FromInt8_Channels(redIn, greenIn, blueIn,
                                                  output, width, height,
                                                  rowOrColumn);
}


                
/*  Input:      three Int8 matrices */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromInt8_Channels(const void* sourceRed,
                                                   const void* sourceGreen,
                                                   const void* sourceBlue,
                                                   void* output,
                                                   int_T width,
                                                   int_T height,
                                                   VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const char_T* redIn = (const char_T*)sourceRed;
    const char_T* greenIn = (const char_T*)sourceGreen;
    const char_T* blueIn = (const char_T*)sourceBlue;
    uint32_T rowBytes = width * 3;
    uint32_T result = rowBytes % 4;
    uint32_T stridePadding = result == 0 ? 0 : 4 - result;
    uint32_T byteOffsetFromStart = height * width * 3 + (stridePadding * height) - 3;
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)output) + byteOffsetFromStart);

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount, hCount;

        rgbOut++;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding)-width;
            for(wCount = 0; wCount < width; wCount++)
            {
                rgbOut[wCount].rgbtBlue = (uint8_T)((int16_T)*blueIn + 128);
                rgbOut[wCount].rgbtGreen = (uint8_T)((int16_T)*greenIn + 128);
                rgbOut[wCount].rgbtRed = (uint8_T)((int16_T)*redIn + 128);
                blueIn++;
                greenIn++;
                redIn++;
            }
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        blueIn += frameArea;
        greenIn += frameArea;
        redIn += frameArea;

        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbOut--)
            {
                blueIn -= height;
                greenIn -= height;
                redIn -= height;

                rgbOut->rgbtBlue = (uint8_T)((int16_T)*blueIn + 128);
                rgbOut->rgbtGreen = (uint8_T)((int16_T)*greenIn + 128);
                rgbOut->rgbtRed = (uint8_T)((int16_T)*redIn + 128);
            }
            blueIn += (frameArea + 1);
            greenIn += (frameArea + 1);
            redIn += (frameArea + 1);
        }
    }
}



/* ////////////////////////////////// Int16 //////////////////////////////////// */
                
/*  Input:      Int16 matrix */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromInt16(const void* input,
                                           void* output,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const int16_T* redIn = (const int16_T*)input;
    const int16_T* greenIn = redIn + frameArea;
    const int16_T* blueIn = greenIn + frameArea;

    OutputPaddedRGB24VideoFrame_FromInt16_Channels(redIn, greenIn, blueIn,
                                                   output, width, height,
                                                   rowOrColumn);
}


                
/*  Input:      three Int16 matrices */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromInt16_Channels(const void* sourceRed,
                                                    const void* sourceGreen,
                                                    const void* sourceBlue,
                                                    void* output,
                                                    int_T width,
                                                    int_T height,
                                                    VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const int16_T* redIn = (const int16_T*)sourceRed;
    const int16_T* greenIn = (const int16_T*)sourceGreen;
    const int16_T* blueIn = (const int16_T*)sourceBlue;
    real_T factor = 1.0 / 257.0;
    real_T bias = 32768.0;
    uint32_T rowBytes = width * 3;
    uint32_T result = rowBytes % 4;
    uint32_T stridePadding = result == 0 ? 0 : 4 - result;
    uint32_T byteOffsetFromStart = height * width * 3 + (stridePadding * height) - 3;
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)output) + byteOffsetFromStart);

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount, hCount;

        rgbOut++;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding)-width;
            for(wCount = 0; wCount < width; wCount++)
            {
                rgbOut[wCount].rgbtBlue  = (uint8_T)(((real_T)*blueIn + bias)  * factor + 0.5);
                rgbOut[wCount].rgbtGreen = (uint8_T)(((real_T)*greenIn + bias) * factor + 0.5);
                rgbOut[wCount].rgbtRed   = (uint8_T)(((real_T)*redIn + bias)   * factor + 0.5);
                blueIn++; greenIn++; redIn++;
            }
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        blueIn += frameArea;
        greenIn += frameArea;
        redIn += frameArea;

        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbOut--)
            {
                blueIn -= height;
                greenIn -= height;
                redIn -= height;

                rgbOut->rgbtBlue = (uint8_T)(((real_T)*blueIn + bias) * factor + 0.5);
                rgbOut->rgbtGreen =(uint8_T)(((real_T)*greenIn + bias) * factor + 0.5);
                rgbOut->rgbtRed = (uint8_T)(((real_T)*redIn + bias) * factor + 0.5);
            }
            blueIn += (frameArea + 1);
            greenIn += (frameArea + 1);
            redIn += (frameArea + 1);
        }
    }
}





/* ////////////////////////////////// Uint16 //////////////////////////////////// */
                
/*  Input:      Uint16 matrix */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromUint16(const void* input,
                                            void* output,
                                            int_T width,
                                            int_T height,
                                            VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const uint16_T* redIn = (const uint16_T*)input;
    const uint16_T* greenIn = redIn + frameArea;
    const uint16_T* blueIn = greenIn + frameArea;

    OutputPaddedRGB24VideoFrame_FromUint16_Channels(redIn, greenIn, blueIn,
                                                    output, width, height,
                                                    rowOrColumn);
}


                
/*  Input:      three Uint16 matrices */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromUint16_Channels(const void* sourceRed,
                                                     const void* sourceGreen,
                                                     const void* sourceBlue,
                                                     void* output,
                                                     int_T width,
                                                     int_T height,
                                                     VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const uint16_T* redIn = (const uint16_T*)sourceRed;
    const uint16_T* greenIn = (const uint16_T*)sourceGreen;
    const uint16_T* blueIn = (const uint16_T*)sourceBlue;
    real_T factor = 1.0 / 257.0;
    uint32_T rowBytes = width * 3;
    uint32_T result = rowBytes % 4;
    uint32_T stridePadding = result == 0 ? 0 : 4 - result;
    uint32_T byteOffsetFromStart = height * width * 3 + (stridePadding * height) - 3;
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)output) + byteOffsetFromStart);

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount, hCount;

        rgbOut++;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding)-width;
            for(wCount = 0; wCount < width; wCount++)
            {
                rgbOut[wCount].rgbtBlue  = (uint8_T)((real_T)*blueIn  * factor + 0.5);
                rgbOut[wCount].rgbtGreen = (uint8_T)((real_T)*greenIn * factor + 0.5);
                rgbOut[wCount].rgbtRed   = (uint8_T)((real_T)*redIn   * factor + 0.5);
                blueIn++; greenIn++; redIn++;
            }
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        blueIn += frameArea;
        greenIn += frameArea;
        redIn += frameArea;

        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbOut--)
            {
                blueIn -= height;
                greenIn -= height;
                redIn -= height;

                rgbOut->rgbtBlue = (uint8_T)((real_T)*blueIn * factor + 0.5);
                rgbOut->rgbtGreen = (uint8_T)((real_T)*greenIn * factor + 0.5);
                rgbOut->rgbtRed = (uint8_T)((real_T)*redIn * factor + 0.5);
            }
            blueIn += (frameArea + 1);
            greenIn += (frameArea + 1);
            redIn += (frameArea + 1);
        }
    }
}





/* ////////////////////////////////// Int32 //////////////////////////////////// */
                
/*  Input:      Int32 matrix */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromInt32(const void* input,
                                           void* output,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const int32_T* redIn = (const int32_T*)input;
    const int32_T* greenIn = redIn + frameArea;
    const int32_T* blueIn = greenIn + frameArea;

    OutputPaddedRGB24VideoFrame_FromInt32_Channels(redIn, greenIn, blueIn,
                                                   output, width, height,
                                                   rowOrColumn);
}


                
/*  Input:      three Int32 matrices */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromInt32_Channels(const void* sourceRed,
                                                    const void* sourceGreen,
                                                    const void* sourceBlue,
                                                    void* output,
                                                    int_T width,
                                                    int_T height,
                                                    VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const int32_T* redIn = (const int32_T*)sourceRed;
    const int32_T* greenIn = (const int32_T*)sourceGreen;
    const int32_T* blueIn = (const int32_T*)sourceBlue;
    real_T factor = 1.0 / 16843009.0;
    real_T bias = 2147483648.0;
    uint32_T rowBytes = width * 3;
    uint32_T result = rowBytes % 4;
    uint32_T stridePadding = result == 0 ? 0 : 4 - result;
    uint32_T byteOffsetFromStart = height * width * 3 + (stridePadding * height) - 3;
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)output) + byteOffsetFromStart);

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount, hCount;

        rgbOut++;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding)-width;
            for(wCount = 0; wCount < width; wCount++)
            {
                rgbOut[wCount].rgbtBlue  = (uint8_T)(((real_T)*blueIn + bias) * factor + 0.5);
                rgbOut[wCount].rgbtGreen = (uint8_T)(((real_T)*greenIn + bias) * factor + 0.5);
                rgbOut[wCount].rgbtRed   = (uint8_T)(((real_T)*redIn + bias) * factor + 0.5);
                blueIn++; greenIn++; redIn++;
            }
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        blueIn += frameArea;
        greenIn += frameArea;
        redIn += frameArea;

        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbOut--)
            {
                blueIn -= height;
                greenIn -= height;
                redIn -= height;

                rgbOut->rgbtBlue = (uint8_T)(((real_T)*blueIn + bias) * factor + 0.5);
                rgbOut->rgbtGreen = (uint8_T)(((real_T)*greenIn + bias) * factor + 0.5);
                rgbOut->rgbtRed = (uint8_T)(((real_T)*redIn + bias) * factor + 0.5);
            }
            blueIn += (frameArea + 1);
            greenIn += (frameArea + 1);
            redIn += (frameArea + 1);
        }
    }
}





/* ////////////////////////////////// Uint32 //////////////////////////////////// */
                
/*  Input:      Uint32 matrix */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromUint32(const void* input,
                                            void* output,
                                            int_T width,
                                            int_T height,
                                            VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const uint32_T* redIn = (const uint32_T*)input;
    const uint32_T* greenIn = redIn + frameArea;
    const uint32_T* blueIn = greenIn + frameArea;

    OutputPaddedRGB24VideoFrame_FromUint32_Channels(redIn, greenIn, blueIn,
                                                    output, width, height,
                                                    rowOrColumn);
}


                
/*  Input:      three Uint32 matrices */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromUint32_Channels(const void* sourceRed,
                                                     const void* sourceGreen,
                                                     const void* sourceBlue,
                                                     void* output,
                                                     int_T width,
                                                     int_T height,
                                                     VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const uint32_T* redIn = (const uint32_T*)sourceRed;
    const uint32_T* greenIn = (const uint32_T*)sourceGreen;
    const uint32_T* blueIn = (const uint32_T*)sourceBlue;
    real_T factor = 1.0 / 16843009.0;
    uint32_T rowBytes = width * 3;
    uint32_T result = rowBytes % 4;
    uint32_T stridePadding = result == 0 ? 0 : 4 - result;
    uint32_T byteOffsetFromStart = height * width * 3 + (stridePadding * height) - 3;
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)output) + byteOffsetFromStart);

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount, hCount;

        rgbOut++;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding)-width;
            for(wCount = 0; wCount < width; wCount++)
            {
                rgbOut[wCount].rgbtBlue  = (uint8_T)(((real_T)*blueIn)  * factor + 0.5);
                rgbOut[wCount].rgbtGreen = (uint8_T)(((real_T)*greenIn) * factor + 0.5);
                rgbOut[wCount].rgbtRed   = (uint8_T)(((real_T)*redIn)   * factor + 0.5);
                blueIn++; greenIn++; redIn++;
            }
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        blueIn += frameArea;
        greenIn += frameArea;
        redIn += frameArea;

        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbOut--)
            {
                blueIn -= height;
                greenIn -= height;
                redIn -= height;

                rgbOut->rgbtBlue = (uint8_T)(((real_T)*blueIn) * factor + 0.5);
                rgbOut->rgbtGreen = (uint8_T)(((real_T)*greenIn) * factor + 0.5);
                rgbOut->rgbtRed = (uint8_T)(((real_T)*redIn) * factor + 0.5);
            }
            blueIn += (frameArea + 1);
            greenIn += (frameArea + 1);
            redIn += (frameArea + 1);
        }
    }
}






/* ////////////////////////////////// Double //////////////////////////////////// */

                
/*  Input:      Double matrix */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromDouble(const void* input,
                                            void* output,
                                            int_T width,
                                            int_T height,
                                            VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const real_T* redIn = (const real_T*)input;
    const real_T* greenIn = redIn + frameArea;
    const real_T* blueIn = greenIn + frameArea;

    OutputPaddedRGB24VideoFrame_FromDouble_Channels(redIn, greenIn, blueIn,
                                                    output, width, height,
                                                    rowOrColumn);
}


                
/*  Input:      three Double matrices */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromDouble_Channels(const void* sourceRed,
                                                     const void* sourceGreen,
                                                     const void* sourceBlue,
                                                     void* output,
                                                     int_T width,
                                                     int_T height,
                                                     VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const real_T* redIn = (const real_T*)sourceRed;
    const real_T* greenIn = (const real_T*)sourceGreen;
    const real_T* blueIn = (const real_T*)sourceBlue;
    uint32_T rowBytes = width * 3;
    uint32_T result = rowBytes % 4;
    uint32_T stridePadding = result == 0 ? 0 : 4 - result;
    uint32_T byteOffsetFromStart = height * width * 3 + (stridePadding * height) - 3;
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)output) + byteOffsetFromStart);

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount, hCount;

        rgbOut++;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding)-width;
            for(wCount = 0; wCount < width; wCount++)
            {
                if(*blueIn > 1.0)
                    rgbOut[wCount].rgbtBlue = UINT8_255;
                else if(*blueIn < 0.0)
                    rgbOut[wCount].rgbtBlue = 0;
                else
                    rgbOut[wCount].rgbtBlue = (uint8_T) ((*blueIn * DOUBLE_255) + 0.5);

                if(*greenIn > 1.0)
                    rgbOut[wCount].rgbtGreen = UINT8_255;
                else if(*greenIn < 0.0)
                    rgbOut[wCount].rgbtGreen = 0;
                else
                    rgbOut[wCount].rgbtGreen = (uint8_T) ((*greenIn * DOUBLE_255) + 0.5);

                if(*redIn > 1.0)
                    rgbOut[wCount].rgbtRed = UINT8_255;
                else if(*redIn < 0.0)
                    rgbOut[wCount].rgbtRed = 0;
                else
                    rgbOut[wCount].rgbtRed = (uint8_T) ((*redIn * DOUBLE_255) + 0.5);

                blueIn++; greenIn++; redIn++;
            }
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;
        blueIn += frameArea;
        greenIn += frameArea;
        redIn += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbOut--)
            {
                blueIn -= height;
                greenIn -= height;
                redIn -= height;

                if(*blueIn > 1.0)
                    rgbOut->rgbtBlue = UINT8_255;
                else if(*blueIn < 0.0)
                    rgbOut->rgbtBlue = 0;
                else
                    rgbOut->rgbtBlue = (uint8_T) ((*blueIn * DOUBLE_255) + 0.5);

                if(*greenIn > 1.0)
                    rgbOut->rgbtGreen = UINT8_255;
                else if(*greenIn < 0.0)
                    rgbOut->rgbtGreen = 0;
                else
                    rgbOut->rgbtGreen = (uint8_T) ((*greenIn * DOUBLE_255) + 0.5);

                if(*redIn > 1.0)
                    rgbOut->rgbtRed = UINT8_255;
                else if(*redIn < 0.0)
                    rgbOut->rgbtRed = 0;
                else
                    rgbOut->rgbtRed = (uint8_T) ((*redIn * DOUBLE_255) + 0.5);
            }
            blueIn += (frameArea + 1);
            greenIn += (frameArea + 1);
            redIn += (frameArea + 1);
        }
    }
}


/* ////////////////////////////////// Single //////////////////////////////////// */
                
/*  Input:      Single matrix */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromSingle(const void* input,
                                            void* output,
                                            int_T width,
                                            int_T height,
                                            VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const real32_T* redIn = (const real32_T*)input;
    const real32_T* greenIn = redIn + frameArea;
    const real32_T* blueIn = greenIn + frameArea;

    OutputPaddedRGB24VideoFrame_FromSingle_Channels(redIn, greenIn, blueIn,
                                                    output, width, height,
                                                    rowOrColumn);
}


                
/*  Input:      three Single matrices */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromSingle_Channels(const void* sourceRed,
                                                     const void* sourceGreen,
                                                     const void* sourceBlue,
                                                     void* output,
                                                     int_T width,
                                                     int_T height,
                                                     VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const real32_T* redIn = (const real32_T*)sourceRed;
    const real32_T* greenIn = (const real32_T*)sourceGreen;
    const real32_T* blueIn = (const real32_T*)sourceBlue;
    uint32_T rowBytes = width * 3;
    uint32_T result = rowBytes % 4;
    uint32_T stridePadding = result == 0 ? 0 : 4 - result;
    uint32_T byteOffsetFromStart = height * width * 3 + (stridePadding * height) - 3;
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)output) + byteOffsetFromStart);

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount, hCount;

        rgbOut++;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding)-width;
            for(wCount = 0; wCount < width; wCount++)
            {
                if(*blueIn > 1.0)
                    rgbOut[wCount].rgbtBlue = UINT8_255;
                else if(*blueIn < 0.0)
                    rgbOut[wCount].rgbtBlue = 0;
                else
                    rgbOut[wCount].rgbtBlue = (uint8_T) ((*blueIn * FLOAT_255) + 0.5);

                if(*greenIn > 1.0)
                    rgbOut[wCount].rgbtGreen = UINT8_255;
                else if(*greenIn < 0.0)
                    rgbOut[wCount].rgbtGreen = 0;
                else
                    rgbOut[wCount].rgbtGreen = (uint8_T) ((*greenIn * FLOAT_255) + 0.5);

                if(*redIn > 1.0)
                    rgbOut[wCount].rgbtRed = UINT8_255;
                else if(*redIn < 0.0)
                    rgbOut[wCount].rgbtRed = 0;
                else
                    rgbOut[wCount].rgbtRed = (uint8_T) ((*redIn * FLOAT_255) + 0.5);

                blueIn++; greenIn++; redIn++;
            }
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;
        blueIn += frameArea;
        greenIn += frameArea;
        redIn += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbOut--)
            {
                blueIn -= height;
                greenIn -= height;
                redIn -= height;

                if(*blueIn > 1.0)
                    rgbOut->rgbtBlue = UINT8_255;
                else if(*blueIn < 0.0)
                    rgbOut->rgbtBlue = 0;
                else
                    rgbOut->rgbtBlue = (uint8_T) ((*blueIn * FLOAT_255) + 0.5);

                if(*greenIn > 1.0)
                    rgbOut->rgbtGreen = UINT8_255;
                else if(*greenIn < 0.0)
                    rgbOut->rgbtGreen = 0;
                else
                    rgbOut->rgbtGreen = (uint8_T) ((*greenIn * FLOAT_255) + 0.5);

                if(*redIn > 1.0)
                    rgbOut->rgbtRed = UINT8_255;
                else if(*redIn < 0.0)
                    rgbOut->rgbtRed = 0;
                else
                    rgbOut->rgbtRed = (uint8_T) ((*redIn * FLOAT_255) + 0.5);
            }
            blueIn += (frameArea + 1);
            greenIn += (frameArea + 1);
            redIn += (frameArea + 1);
        }
    }
}


/* ////////////////////////////////// Boolean //////////////////////////////////// */

                
/*  Input:      Boolean matrix */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromBoolean(const void* input,
                                             void* output,
                                             int_T width,
                                             int_T height,
                                             VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const uint8_T* redIn = (const uint8_T*)input;
    const uint8_T* greenIn = redIn + frameArea;
    const uint8_T* blueIn = greenIn + frameArea;

    OutputPaddedRGB24VideoFrame_FromBoolean_Channels(redIn, greenIn, blueIn, 
                                                     output, width, height, rowOrColumn);
}


                
/*  Input:      three Boolean matrices */
/*  Output:     Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromBoolean_Channels(const void* sourceRed,
                                                      const void* sourceGreen,
                                                      const void* sourceBlue,
                                                      void* output,
                                                      int_T width,
                                                      int_T height,
                                                      VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const uint8_T* redIn = (const uint8_T*)sourceRed;
    const uint8_T* greenIn = (const uint8_T*)sourceGreen;
    const uint8_T* blueIn = (const uint8_T*)sourceBlue;
    uint32_T rowBytes = width * 3;
    uint32_T result = rowBytes % 4;
    uint32_T stridePadding = result == 0 ? 0 : 4 - result;
    uint32_T byteOffsetFromStart = height * width * 3 + (stridePadding * height) - 3;
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)output) + byteOffsetFromStart);

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount, hCount;

        rgbOut++;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding)-width;
            for(wCount = 0; wCount < width; wCount++)
            {
                rgbOut[wCount].rgbtBlue = *blueIn * 255;
                rgbOut[wCount].rgbtGreen = *greenIn * 255;
                rgbOut[wCount].rgbtRed = *redIn * 255;
                blueIn++; greenIn++; redIn++;
            }
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;
        blueIn += frameArea;
        greenIn += frameArea;
        redIn += frameArea;

        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut = (MM_RGBTRIPLE*)(((uint8_T*)rgbOut) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbOut--)
            {
                blueIn -= height;
                greenIn -= height;
                redIn -= height;

                rgbOut->rgbtBlue = *blueIn * 255;
                rgbOut->rgbtGreen = *greenIn * 255;
                rgbOut->rgbtRed = *redIn * 255;
            }
            blueIn += (frameArea + 1);
            greenIn += (frameArea + 1);
            redIn += (frameArea + 1);
        }
    }
}


#define NUM_DTYPES 9 /* right now, anyway */


static OUTPUT_RGB24_FUNC rgb24PaddedOutputFcns[] = 
{
    /*  VideoDataType_Double = 0,        real_T */ 
    OutputPaddedRGB24VideoFrame_FromDouble,
    /*  VideoDataType_Single,            real32_T */ 
    OutputPaddedRGB24VideoFrame_FromSingle,
    /*  VideoDataType_Int8,              char_T */ 
    OutputPaddedRGB24VideoFrame_FromInt8,
    /*  VideoDataType_Uint8,             uint8_T */ 
    OutputPaddedRGB24VideoFrame_FromUint8,
    /*  VideoDataType_Int16,             int16_T */ 
    OutputPaddedRGB24VideoFrame_FromInt16,
    /*  VideoDataType_Uint16,            uint16_T */ 
    OutputPaddedRGB24VideoFrame_FromUint16,
    /*  VideoDataType_Int32,             int32_T */ 
    OutputPaddedRGB24VideoFrame_FromInt32,
    /*  VideoDataType_Uint32,            uint32_T */ 
    OutputPaddedRGB24VideoFrame_FromUint32,
    /*  VideoDataType_Boolean            bool */ 
    OutputPaddedRGB24VideoFrame_FromBoolean
};

static OUTPUT_RGB24_CHANS_FUNC rgb24ChannelsPaddedOutputFcns[] = 
{
    /*  VideoDataType_Double = 0,        real_T */ 
    OutputPaddedRGB24VideoFrame_FromDouble_Channels,
    /*  VideoDataType_Single,            real32_T */ 
    OutputPaddedRGB24VideoFrame_FromSingle_Channels,
    /*  VideoDataType_Int8,              char_T */ 
    OutputPaddedRGB24VideoFrame_FromInt8_Channels,
    /*  VideoDataType_Uint8,             uint8_T */ 
    OutputPaddedRGB24VideoFrame_FromUint8_Channels,
    /*  VideoDataType_Int16,             int16_T */ 
    OutputPaddedRGB24VideoFrame_FromInt16_Channels,
    /*  VideoDataType_Uint16,            uint16_T */ 
    OutputPaddedRGB24VideoFrame_FromUint16_Channels,
    /*  VideoDataType_Int32,             int32_T */ 
    OutputPaddedRGB24VideoFrame_FromInt32_Channels,
    /*  VideoDataType_Uint32,            uint32_T */ 
    OutputPaddedRGB24VideoFrame_FromUint32_Channels,
    /*  VideoDataType_Boolean            bool */ 
    OutputPaddedRGB24VideoFrame_FromBoolean_Channels
};



OUTPUT_RGB24_FUNC MWDSP_GetPaddedRGB24OutputFcn(VideoDataType dType)
{
    int_T offset = dType;
    if(offset >= 0 && offset < NUM_DTYPES)
        return rgb24PaddedOutputFcns[offset];
    else
        return (OUTPUT_RGB24_FUNC) NULL;
}

OUTPUT_RGB24_CHANS_FUNC MWDSP_GetPaddedRGB24ChannelsOutputFcn(VideoDataType dType)
{
    int_T offset = dType;
    if(offset >= 0 && offset < NUM_DTYPES)
        return rgb24ChannelsPaddedOutputFcns[offset];
    else
        return (OUTPUT_RGB24_CHANS_FUNC) NULL;
}

#endif /* !INTEGER_CODE */

/* [EOF] mmrgb24paddedconvert_rt.c */

