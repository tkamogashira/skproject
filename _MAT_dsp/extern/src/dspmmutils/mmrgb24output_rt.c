/*
 * mmrgb24output_rt.c.c:  contains routines for outputting video frame
 *
 * Copyright 2005-2013 The MathWorks, Inc.
 */

#ifdef MW_DSP_RT
#include "src/dspmmutils_rt.h"
#else
#include "dspmmutils_rt.h"
#endif

#if (!defined(INTEGER_CODE) || !INTEGER_CODE)

#define DOUBLE_255	255.0
#define FLOAT_255	255.0f
#define UINT8_255	255


/* ////////////////////////////////// Uint8 //////////////////////////////////// */
		
/*  Input:	Uint8 matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromUint8(const void* input,
                                     void* output,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const uint8_T* redIn = (const uint8_T*)input;
    const uint8_T* greenIn = redIn + frameArea;
    const uint8_T* blueIn = greenIn + frameArea;

    OutputRGB24VideoFrame_FromUint8_Channels(redIn, greenIn, blueIn,
                                             output, width, height,
                                             rowOrColumn);
}


		
/*  Input:	three Uint8 matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromUint8_Channels(const void* sourceRed,
                                              const void* sourceGreen,
                                              const void* sourceBlue,
                                              void* output,
                                              int_T width,
                                              int_T height,
                                              VideoFrameOrientation rowOrColumn)
{
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)output;
    int_T frameArea = width * height;
    const uint8_T* redIn   = (const uint8_T*)sourceRed;
    const uint8_T* greenIn = (const uint8_T*)sourceGreen;
    const uint8_T* blueIn  = (const uint8_T*)sourceBlue;
    int_T hCount;
    int_T vCount;

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        rgbOut += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut -= width;
            for(vCount = 0; vCount < width; vCount++)
            {
                rgbOut[vCount].rgbtBlue  = *blueIn++;
                rgbOut[vCount].rgbtGreen = *greenIn++;
                rgbOut[vCount].rgbtRed   = *redIn++;
            }
        }
    }
    else /*  VideoFrame_ColumnMajor */
    {
        blueIn  += frameArea;
        greenIn += frameArea;
        redIn   += frameArea;

        rgbOut += (frameArea - 1);
        for(hCount = 0; hCount < height; hCount++)
        {
            for(vCount = 0; vCount < width; vCount++, rgbOut--)
            {
                blueIn  -= height;
                greenIn -= height;
                redIn   -= height;

                rgbOut->rgbtBlue  = *blueIn;
                rgbOut->rgbtGreen = *greenIn;
                rgbOut->rgbtRed   = *redIn;
            }
            blueIn += (frameArea + 1);
            greenIn += (frameArea + 1);
            redIn += (frameArea + 1);
        }
    }
}


/* ////////////////////////////////// Int8 //////////////////////////////////// */
		
/*  Input:	Int8 matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromInt8(const void* input,
                                    void* output,
                                    int_T width,
                                    int_T height,
                                    VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const char_T* redIn = (const char_T*)input;
    const char_T* greenIn = redIn + frameArea;
    const char_T* blueIn = greenIn + frameArea;

    OutputRGB24VideoFrame_FromInt8_Channels(redIn, greenIn, blueIn,
                                            output, width, height,
                                            rowOrColumn);
}


		
/*  Input:	three Int8 matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromInt8_Channels(const void* sourceRed,
                                             const void* sourceGreen,
                                             const void* sourceBlue,
                                             void* output,
                                             int_T width,
                                             int_T height,
                                             VideoFrameOrientation rowOrColumn)
{
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)output;
    int_T frameArea = width * height;
    const char_T* redIn = (const char_T*)sourceRed;
    const char_T* greenIn = (const char_T*)sourceGreen;
    const char_T* blueIn = (const char_T*)sourceBlue;
    int_T hCount;
    int_T vCount;

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        rgbOut += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut -= width;
            for(vCount = 0; vCount < width; vCount++)
            {
                rgbOut[vCount].rgbtBlue  = (uint8_T)((int16_T)*blueIn  + 128);
                rgbOut[vCount].rgbtGreen = (uint8_T)((int16_T)*greenIn + 128);
                rgbOut[vCount].rgbtRed   = (uint8_T)((int16_T)*redIn   + 128);
                blueIn++;
                greenIn++;
                redIn++;
            }
        }
    }
    else	/*  VideoFrame_ColumnMajor */
    {
        blueIn += frameArea;
        greenIn += frameArea;
        redIn += frameArea;

        rgbOut += (frameArea - 1);
        for(hCount = 0; hCount < height; hCount++)
        {
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
		
/*  Input:	Int16 matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromInt16(const void* input,
                                     void* output,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const int16_T* redIn = (const int16_T*)input;
    const int16_T* greenIn = redIn + frameArea;
    const int16_T* blueIn = greenIn + frameArea;

    OutputRGB24VideoFrame_FromInt16_Channels(redIn, greenIn, blueIn,
                                             output, width, height,
                                             rowOrColumn);
}


		
/*  Input:	three Int16 matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromInt16_Channels(const void* sourceRed,
                                              const void* sourceGreen,
                                              const void* sourceBlue,
                                              void* output,
                                              int_T width,
                                              int_T height,
                                              VideoFrameOrientation rowOrColumn)
{
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)output;
    int_T frameArea = width * height;
    const int16_T* redIn = (const int16_T*)sourceRed;
    const int16_T* greenIn = (const int16_T*)sourceGreen;
    const int16_T* blueIn = (const int16_T*)sourceBlue;
    int_T hCount;
    int_T vCount;
    real_T factor = 1.0 / 257.0;
    real_T bias = 32768.0;

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        rgbOut += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut -= width;
            for(vCount = 0; vCount < width; vCount++)
            {
                rgbOut[vCount].rgbtBlue  = (uint8_T)(((real_T)*blueIn + bias) * factor + 0.5);
                rgbOut[vCount].rgbtGreen = (uint8_T)(((real_T)*greenIn + bias) * factor + 0.5);
                rgbOut[vCount].rgbtRed   = (uint8_T)(((real_T)*redIn + bias) * factor + 0.5);
                blueIn++;
                greenIn++;
                redIn++;
            }
        }
    }
    else	/*  VideoFrame_ColumnMajor */
    {
        blueIn += frameArea;
        greenIn += frameArea;
        redIn += frameArea;

        rgbOut += (frameArea - 1);
        for(hCount = 0; hCount < height; hCount++)
        {
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
		
/*  Input:	Uint16 matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromUint16(const void* input,
                                      void* output,
                                      int_T width,
                                      int_T height,
                                      VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const uint16_T* redIn = (const uint16_T*)input;
    const uint16_T* greenIn = redIn + frameArea;
    const uint16_T* blueIn = greenIn + frameArea;

    OutputRGB24VideoFrame_FromUint16_Channels(redIn, greenIn, blueIn,
                                              output, width, height,
                                              rowOrColumn);
}


		
/*  Input:	three Uint16 matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromUint16_Channels(const void* sourceRed,
                                               const void* sourceGreen,
                                               const void* sourceBlue,
                                               void* output,
                                               int_T width,
                                               int_T height,
                                               VideoFrameOrientation rowOrColumn)
{
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)output;
    int_T frameArea = width * height;
    const uint16_T* redIn = (const uint16_T*)sourceRed;
    const uint16_T* greenIn = (const uint16_T*)sourceGreen;
    const uint16_T* blueIn = (const uint16_T*)sourceBlue;
    int_T hCount;
    int_T vCount;
    real_T factor = 1.0 / 257.0;
    
    if(rowOrColumn == VideoFrame_RowMajor)
    {
        rgbOut += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut -= width;
            for(vCount = 0; vCount < width; vCount++)
            {
                rgbOut[vCount].rgbtBlue  = (uint8_T)((real_T)*blueIn  * factor + 0.5);
                rgbOut[vCount].rgbtGreen = (uint8_T)((real_T)*greenIn * factor + 0.5);
                rgbOut[vCount].rgbtRed   = (uint8_T)((real_T)*redIn   * factor + 0.5);
                blueIn++; greenIn++; redIn++;
            }
        }
    }
    else	/*  VideoFrame_ColumnMajor */
    {
        blueIn  += frameArea;
        greenIn += frameArea;
        redIn   += frameArea;

        rgbOut += (frameArea - 1);
        for(hCount = 0; hCount < height; hCount++)
        {
            for(vCount = 0; vCount < width; vCount++, rgbOut--)
            {
                blueIn  -= height;
                greenIn -= height;
                redIn   -= height;

                rgbOut->rgbtBlue  = (uint8_T)((real_T)*blueIn * factor + 0.5);
                rgbOut->rgbtGreen = (uint8_T)((real_T)*greenIn * factor + 0.5);
                rgbOut->rgbtRed   = (uint8_T)((real_T)*redIn * factor + 0.5);
            }
            blueIn  += (frameArea + 1);
            greenIn += (frameArea + 1);
            redIn   += (frameArea + 1);
        }
    }
}

/* ////////////////////////////////// Int32 //////////////////////////////////// */
		
/*  Input:	Int32 matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromInt32(const void* input,
                                     void* output,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const int32_T* redIn = (const int32_T*)input;
    const int32_T* greenIn = redIn + frameArea;
    const int32_T* blueIn = greenIn + frameArea;

    OutputRGB24VideoFrame_FromInt32_Channels(redIn, greenIn, blueIn,
                                             output, width, height,
                                             rowOrColumn);
}


		
/*  Input:	three Int32 matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromInt32_Channels(const void* sourceRed,
                                              const void* sourceGreen,
                                              const void* sourceBlue,
                                              void* output,
                                              int_T width,
                                              int_T height,
                                              VideoFrameOrientation rowOrColumn)
{
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)output;
    int_T frameArea = width * height;
    const int32_T* redIn   = (const int32_T*)sourceRed;
    const int32_T* greenIn = (const int32_T*)sourceGreen;
    const int32_T* blueIn  = (const int32_T*)sourceBlue;
    int_T hCount;
    int_T vCount;

    real_T factor = 1.0 / 16843009.0;
    real_T bias = 2147483648.0;

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        rgbOut += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut -= width;
            for(vCount = 0; vCount < width; vCount++)
            {
                rgbOut[vCount].rgbtBlue  = (uint8_T)(((real_T)*blueIn + bias)  * factor + 0.5);
                rgbOut[vCount].rgbtGreen = (uint8_T)(((real_T)*greenIn + bias) * factor + 0.5);
                rgbOut[vCount].rgbtRed   = (uint8_T)(((real_T)*redIn + bias)   * factor + 0.5);
                blueIn++; greenIn++; redIn++;
            }
        }
    }
    else	/*  VideoFrame_ColumnMajor */
    {
        blueIn  += frameArea;
        greenIn += frameArea;
        redIn   += frameArea;

        rgbOut += (frameArea - 1);
        for(hCount = 0; hCount < height; hCount++)
        {
            for(vCount = 0; vCount < width; vCount++, rgbOut--)
            {
                blueIn  -= height;
                greenIn -= height;
                redIn   -= height;

                rgbOut->rgbtBlue  = (uint8_T)(((real_T)*blueIn + bias) * factor + 0.5);
                rgbOut->rgbtGreen = (uint8_T)(((real_T)*greenIn + bias) * factor + 0.5);
                rgbOut->rgbtRed   = (uint8_T)(((real_T)*redIn + bias) * factor + 0.5);
            }
            blueIn  += (frameArea + 1);
            greenIn += (frameArea + 1);
            redIn   += (frameArea + 1);
        }
    }
}





/* ////////////////////////////////// Uint32 //////////////////////////////////// */
		
/*  Input:	Uint32 matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromUint32(const void* input,
                                      void* output,
                                      int_T width,
                                      int_T height,
                                      VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const uint32_T* redIn = (const uint32_T*)input;
    const uint32_T* greenIn = redIn + frameArea;
    const uint32_T* blueIn = greenIn + frameArea;

    OutputRGB24VideoFrame_FromUint32_Channels(redIn, greenIn, blueIn,
                                              output, width, height,
                                              rowOrColumn);
}


		
/*  Input:	three Uint32 matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromUint32_Channels(const void* sourceRed,
                                               const void* sourceGreen,
                                               const void* sourceBlue,
                                               void* output,
                                               int_T width,
                                               int_T height,
                                               VideoFrameOrientation rowOrColumn)
{
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)output;
    int_T frameArea = width * height;
    const uint32_T* redIn = (const uint32_T*)sourceRed;
    const uint32_T* greenIn = (const uint32_T*)sourceGreen;
    const uint32_T* blueIn = (const uint32_T*)sourceBlue;
    int_T hCount;
    int_T vCount;
    real_T factor = 1.0 / 16843009.0;

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        rgbOut += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut -= width;
            for(vCount = 0; vCount < width; vCount++)
            {
                rgbOut[vCount].rgbtBlue  = (uint8_T)(((real_T)*blueIn)  * factor + 0.5);
                rgbOut[vCount].rgbtGreen = (uint8_T)(((real_T)*greenIn) * factor + 0.5);
                rgbOut[vCount].rgbtRed   = (uint8_T)(((real_T)*redIn)   * factor + 0.5);
                blueIn++;
                greenIn++;
                redIn++;
            }
        }
    }
    else	/*  VideoFrame_ColumnMajor */
    {
        blueIn  += frameArea;
        greenIn += frameArea;
        redIn   += frameArea;

        rgbOut += (frameArea - 1);
        for(hCount = 0; hCount < height; hCount++)
        {
            for(vCount = 0; vCount < width; vCount++, rgbOut--)
            {
                blueIn  -= height;
                greenIn -= height;
                redIn   -= height;

                rgbOut->rgbtBlue  = (uint8_T)(((real_T)*blueIn)  * factor + 0.5);
                rgbOut->rgbtGreen = (uint8_T)(((real_T)*greenIn) * factor + 0.5);
                rgbOut->rgbtRed   = (uint8_T)(((real_T)*redIn)   * factor + 0.5);
            }
            blueIn  += (frameArea + 1);
            greenIn += (frameArea + 1);
            redIn   += (frameArea + 1);
        }
    }
}

/* ////////////////////////////////// real_T //////////////////////////////////// */

/*  Input:	real_T matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromDouble(const void* input,
                                      void* output,
                                      int_T width,
                                      int_T height,
                                      VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const real_T* redIn = (const real_T*)input;
    const real_T* greenIn = redIn + frameArea;
    const real_T* blueIn = greenIn + frameArea;

    OutputRGB24VideoFrame_FromDouble_Channels(redIn, greenIn, blueIn,
                                              output, width, height,
                                              rowOrColumn);
}


		
/*  Input:	three real_T matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromDouble_Channels(const void* sourceRed,
                                               const void* sourceGreen,
                                               const void* sourceBlue,
                                               void* output,
                                               int_T width,
                                               int_T height,
                                               VideoFrameOrientation rowOrColumn)
{
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)output;
    int_T frameArea = width * height;
    const real_T* redIn = (const real_T*)sourceRed;
    const real_T* greenIn = (const real_T*)sourceGreen;
    const real_T* blueIn = (const real_T*)sourceBlue;
    int_T hCount;
    int_T vCount;
    
    if(rowOrColumn == VideoFrame_RowMajor)
    {
        rgbOut  += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut -= width;
            for(vCount = 0; vCount < width; vCount++)
            {
                if(*blueIn > 1.0)
                    rgbOut[vCount].rgbtBlue = UINT8_255;
                else if(*blueIn < 0.0)
                    rgbOut[vCount].rgbtBlue = 0;
                else
                    rgbOut[vCount].rgbtBlue = (uint8_T) ((*blueIn * DOUBLE_255) + 0.5);
                
                if(*greenIn > 1.0)
                    rgbOut[vCount].rgbtGreen = UINT8_255;
                else if(*greenIn < 0.0)
                    rgbOut[vCount].rgbtGreen = 0;
                else
                    rgbOut[vCount].rgbtGreen = (uint8_T) ((*greenIn * DOUBLE_255) + 0.5);
                
                if(*redIn > 1.0)
                    rgbOut[vCount].rgbtRed = UINT8_255;
                else if(*redIn < 0.0)
                    rgbOut[vCount].rgbtRed = 0;
                else
                    rgbOut[vCount].rgbtRed = (uint8_T) ((*redIn * DOUBLE_255) + 0.5);
                
                blueIn++; greenIn++; redIn++;
            }
        }
    }
    else	/*  VideoFrame_ColumnMajor */
    {
        blueIn  += frameArea;
        greenIn += frameArea;
        redIn   += frameArea;

        rgbOut  += (frameArea - 1);
        for(hCount = 0; hCount < height; hCount++)
        {
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
		
/*  Input:	Single matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromSingle(const void* input,
                                      void* output,
                                      int_T width,
                                      int_T height,
                                      VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const real32_T* redIn = (const real32_T*)input;
    const real32_T* greenIn = redIn + frameArea;
    const real32_T* blueIn = greenIn + frameArea;

    OutputRGB24VideoFrame_FromSingle_Channels(redIn, greenIn, blueIn,
                                              output, width, height,
                                              rowOrColumn);
}


		
/*  Input:	three Single matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromSingle_Channels(const void* sourceRed,
                                               const void* sourceGreen,
                                               const void* sourceBlue,
                                               void* output,
                                               int_T width,
                                               int_T height,
                                               VideoFrameOrientation rowOrColumn)
{
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)output;
    int_T frameArea = width * height;
    const real32_T* redIn = (const real32_T*)sourceRed;
    const real32_T* greenIn = (const real32_T*)sourceGreen;
    const real32_T* blueIn = (const real32_T*)sourceBlue;
    int_T hCount;
    int_T vCount;

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        rgbOut += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut -= width;
            for(vCount = 0; vCount < width; vCount++)
            {
                if(*blueIn > 1.0)
                    rgbOut[vCount].rgbtBlue = UINT8_255;
                else if(*blueIn < 0.0)
                    rgbOut[vCount].rgbtBlue = 0;
                else
                    rgbOut[vCount].rgbtBlue = (uint8_T) ((*blueIn * FLOAT_255) + 0.5);
                
                if(*greenIn > 1.0)
                    rgbOut[vCount].rgbtGreen = UINT8_255;
                else if(*greenIn < 0.0)
                    rgbOut[vCount].rgbtGreen = 0;
                else
                    rgbOut[vCount].rgbtGreen = (uint8_T) ((*greenIn * FLOAT_255) + 0.5);
                
                if(*redIn > 1.0)
                    rgbOut[vCount].rgbtRed = UINT8_255;
                else if(*redIn < 0.0)
                    rgbOut[vCount].rgbtRed = 0;
                else
                    rgbOut[vCount].rgbtRed = (uint8_T) ((*redIn * FLOAT_255) + 0.5);
                
                blueIn++; greenIn++; redIn++;
            }
        }
    }
    else	/*  VideoFrame_ColumnMajor */
    {
        blueIn += frameArea;
        greenIn += frameArea;
        redIn += frameArea;

        rgbOut += (frameArea - 1);
        for(hCount = 0; hCount < height; hCount++)
        {
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

		
/*  Input:	Boolean matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromBoolean(const void* input,
                                       void* output,
                                       int_T width,
                                       int_T height,
                                       VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    const uint8_T* redIn = (const uint8_T*)input;
    const uint8_T* greenIn = redIn + frameArea;
    const uint8_T* blueIn = greenIn + frameArea;

    OutputRGB24VideoFrame_FromBoolean_Channels(redIn, greenIn, blueIn,
                                               output, width, height,
                                               rowOrColumn);
}


		
/*  Input:	three Boolean matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromBoolean_Channels(const void* sourceRed,
                                                const void* sourceGreen,
                                                const void* sourceBlue,
                                                void* output,
                                                int_T width,
                                                int_T height,
                                                VideoFrameOrientation rowOrColumn)
{
    MM_RGBTRIPLE* rgbOut = (MM_RGBTRIPLE*)output;
    int_T frameArea = width * height;
    const uint8_T* redIn = (const uint8_T*)sourceRed;
    const uint8_T* greenIn = (const uint8_T*)sourceGreen;
    const uint8_T* blueIn = (const uint8_T*)sourceBlue;
    int_T hCount;
    int_T vCount;

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        rgbOut += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbOut -= width;
            for(vCount = 0; vCount < width; vCount++)
            {
                rgbOut[vCount].rgbtBlue = *blueIn * 255;
                rgbOut[vCount].rgbtGreen = *greenIn * 255;
                rgbOut[vCount].rgbtRed = *redIn * 255;
                blueIn++; greenIn++; redIn++;
            }
        }
    }
    else	/*  VideoFrame_ColumnMajor */
    {
        blueIn += frameArea;
        greenIn += frameArea;
        redIn += frameArea;

        rgbOut += (frameArea - 1);
        for(hCount = 0; hCount < height; hCount++)
        {
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


#define NUM_DTYPES	9				/* right now, anyway */


static OUTPUT_RGB24_FUNC rgb24OutputFcns[] = 
{
    /*  VideoDataType_real_T = 0,	 real_T */ 
    OutputRGB24VideoFrame_FromDouble,
    /*  VideoDataType_Single,		 real32_T */ 
    OutputRGB24VideoFrame_FromSingle,
    /*  VideoDataType_Int8,			 uint8_T */ 
    OutputRGB24VideoFrame_FromInt8,
    /*  VideoDataType_Uint8,		 uint8_T */ 
    OutputRGB24VideoFrame_FromUint8,
    /*  VideoDataType_Int16,		 int16_T */ 
    OutputRGB24VideoFrame_FromInt16,
    /*  VideoDataType_Uint16,		 uint16_T */ 
    OutputRGB24VideoFrame_FromUint16,
    /*  VideoDataType_Int32,		 int32_T */ 
    OutputRGB24VideoFrame_FromInt32,
    /*  VideoDataType_Uint32,		 uint32_T */ 
    OutputRGB24VideoFrame_FromUint32,
    /*  VideoDataType_Boolean		 bool */ 
    OutputRGB24VideoFrame_FromBoolean
};

static OUTPUT_RGB24_CHANS_FUNC rgb24ChannelsOutputFcns[] = 
{
    /*  VideoDataType_real_T = 0,	 real_T */ 
    OutputRGB24VideoFrame_FromDouble_Channels,
    /*  VideoDataType_Single,		 real32_T */ 
    OutputRGB24VideoFrame_FromSingle_Channels,
    /*  VideoDataType_Int8,	         uint8_T */ 
    OutputRGB24VideoFrame_FromInt8_Channels,
    /*  VideoDataType_Uint8,		 uint8_T */ 
    OutputRGB24VideoFrame_FromUint8_Channels,
    /*  VideoDataType_Int16,             int16_T */ 
    OutputRGB24VideoFrame_FromInt16_Channels,
    /*  VideoDataType_Uint16,		 uint16_T */
    OutputRGB24VideoFrame_FromUint16_Channels,
    /*  VideoDataType_Int32,		 int32_T */ 
    OutputRGB24VideoFrame_FromInt32_Channels,
    /*  VideoDataType_Uint32,		 uint32_T */ 
    OutputRGB24VideoFrame_FromUint32_Channels,
    /*  VideoDataType_Boolean		 bool */ 
    OutputRGB24VideoFrame_FromBoolean_Channels
};



OUTPUT_RGB24_FUNC MWDSP_GetRGB24OutputFcn(VideoDataType dType)
{
    int_T offset = dType;
    if(offset >= 0 && offset < NUM_DTYPES)
        return rgb24OutputFcns[offset];
    else
        return (OUTPUT_RGB24_FUNC) NULL;
}

OUTPUT_RGB24_CHANS_FUNC MWDSP_GetRGB24ChannelsOutputFcn(VideoDataType dType)
{
    int_T offset = dType;
    if(offset >= 0 && offset < NUM_DTYPES)
        return rgb24ChannelsOutputFcns[offset];
    else
        return (OUTPUT_RGB24_CHANS_FUNC) NULL;
}

#endif /* !INTEGER_CODE */

/* [EOF] mmrgb24output_rt.c */



