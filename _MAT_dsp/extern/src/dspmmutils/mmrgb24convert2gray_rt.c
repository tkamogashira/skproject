/*
 * mmrgb24convert2gray.c:  contains routines for 1.)RGB24 -> intensity 
 *     video conversion functions 2.) setting a buffer to empty (black) 
 *     intensity
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

/*  coefficients used to convert the incoming RGB to intensity */
/*  these numbers came from IPT's rgb2gray.m: */
/*  >> T = inv([1.0 0.956 0.621; 1.0 -0.272 -0.647; 1.0 -1.106 1.703]); */
/*  >> rgbToGrayCoeffs = T(1,:) */
#define RED_COEF        0.29893602129378 
#define GREEN_COEF      0.58704307445112 
#define BLUE_COEF       0.11402090425510

#define CONVERT_RGB24_TO_INTENSITY (rgbIn->rgbtRed   * RED_COEF   + \
                                    rgbIn->rgbtGreen * GREEN_COEF + \
                                    rgbIn->rgbtBlue  * BLUE_COEF)

#define CONVERT_RGB24_TO_INTENSITY_RM (rgbIn[wCount].rgbtRed   * RED_COEF   + \
                                       rgbIn[wCount].rgbtGreen * GREEN_COEF + \
                                       rgbIn[wCount].rgbtBlue  * BLUE_COEF)

#define EVALUATE_STRIDE_PADDING \
    uint32_T rowBytes = width * 3; \
    uint32_T result = rowBytes % 4; \
    uint32_T stridePadding = result == 0 ? 0 : 4 - result; \
    uint32_T byteOffsetFromStart = height * width * 3 + (stridePadding * height) - 3; \
    MM_RGBTRIPLE* rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)source) + byteOffsetFromStart);

/* ////////////////////////////// Uint8 /////////////////////////////////////////// */
                
/*  Input:      RGB24 video frame */
/*  Output:     Uint8 intensity matrix */
void ConvertRGB24VideoFrame_ToIUint8(void* source, 
                                     void* target,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    uint8_T* out = (uint8_T*)target;
    EVALUATE_STRIDE_PADDING;

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount;
        int_T hCount;

        rgbIn++;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding) - width;
            for(wCount = 0; wCount < width; wCount++)
            {
                *out++ = (uint8_T) (CONVERT_RGB24_TO_INTENSITY_RM + 0.5);
            }
        }
    }
    else    /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        out += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbIn--)
            {
                out -= height;
                *out = (uint8_T) (CONVERT_RGB24_TO_INTENSITY + 0.5);
            }
            out += (frameArea + 1);
        }
    }
}


/*  Input:      (none) */
/*  Output:     black intensity video frame as Uint8 matrix */
void EmptyIntensityVideoFrame_Uint8(void* source, 
                                    void* target,
                                    int_T width,
                                    int_T height,
                                    VideoFrameOrientation rowOrColumn)
{
    (void)source; /* avoid warnings */
    (void)rowOrColumn;
    memset(target, 0, (width * height));
}


/* ////////////////////////////// Int8 /////////////////////////////////////////// */
                
/*  Input:      RGB24 video frame */
/*  Output:     Int8 intensity matrix */
void ConvertRGB24VideoFrame_ToIInt8(void* source, 
                                    void* target,
                                    int_T width,
                                    int_T height,
                                    VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    char_T* out = (char_T*)target;
    int16_T temp;

    EVALUATE_STRIDE_PADDING;

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount;
        int_T hCount;

        rgbIn++;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding)-width;
            for(wCount = 0; wCount < width; wCount++)
            {
                temp = (int16_T) (CONVERT_RGB24_TO_INTENSITY_RM + 0.5);
                *out++ = (char_T)(temp - 128);
            }
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        out += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbIn--)
            {
                out -= height;
                temp = (int16_T) (CONVERT_RGB24_TO_INTENSITY + 0.5);
                *out = (char_T)(temp - 128);
            }
            out += (frameArea + 1);
        }
    }
}

/*  Input:      (none) */
/*  Output:     black intensity video frame as Int8 matrix */
void EmptyIntensityVideoFrame_Int8(void* source, 
                                   void* target,
                                   int_T width,
                                   int_T height,
                                   VideoFrameOrientation rowOrColumn)
{
    (void)source; /* avoid warnings */
    (void)rowOrColumn;
    memset(target, SCHAR_MIN, (width * height));
}


/* ////////////////////////////// Int16 /////////////////////////////////////////// */
                
/*  Input:      RGB24 video frame */
/*  Output:     Int16 intensity matrix */
void ConvertRGB24VideoFrame_ToIInt16(void* source, 
                                     void* target,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    int16_T* out = (int16_T*)target;
    real_T factor = 257.0;
    real_T bias = 32768.0;
    real_T temp;
    EVALUATE_STRIDE_PADDING;

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount;
        int_T hCount;

        rgbIn++;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding)-width;
            for(wCount = 0; wCount < width; wCount++)
            {
                temp = CONVERT_RGB24_TO_INTENSITY_RM;
                *out++ = (int16_T)(temp * factor - bias);
            }
        }
    }
    else    /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        out += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbIn--)
            {
                out -= height;

                temp = CONVERT_RGB24_TO_INTENSITY;
                *out = (int16_T)(temp * factor - bias);
            }
            out += (frameArea + 1);
        }
    }
}

/*  Input:      (none) */
/*  Output:     black intensity video frame as Int16 matrix */
void EmptyIntensityVideoFrame_Int16(void* source, 
                                    void* target,
                                    int_T width,
                                    int_T height,
                                    VideoFrameOrientation rowOrColumn)
{
    size_t frameArea = width * height;
    int16_T* ptr = (int16_T*)target;
    size_t count;

    (void)source; /* avoid warnings */
    (void)rowOrColumn;

    for(count = 0; count < frameArea; count++)
        *ptr++ = SHRT_MIN;
}


/* ////////////////////////////// Uint16 /////////////////////////////////////////// */
                
/*  Input:      RGB24 video frame */
/*  Output:     Uint16 intensity matrix */
void ConvertRGB24VideoFrame_ToIUint16(void* source, 
                                      void* target,
                                      int_T width,
                                      int_T height,
                                      VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    uint16_T* out = (uint16_T*)target;
    uint16_T temp;
    EVALUATE_STRIDE_PADDING;

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount;
        int_T hCount;

        rgbIn++;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding)-width;
            for(wCount = 0; wCount < width; wCount++)
            {
                temp = (uint16_T) (CONVERT_RGB24_TO_INTENSITY_RM + 0.5);
                *out++ = (temp << 8) | temp;
            }
        }
    }
    else    /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        out += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbIn--)
            {
                out -= height;

                temp = (uint16_T) (CONVERT_RGB24_TO_INTENSITY + 0.5);
                *out = (temp << 8) | temp;
            }
            out += (frameArea + 1);
        }
    }
}


/*  Input:      (none) */
/*  Output:     black intensity video frame as Uint16 matrix */
void EmptyIntensityVideoFrame_Uint16(void* source, 
                                     void* target,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn)
{
    (void)source; /* avoid warnings */
    (void)rowOrColumn;

    memset(target, 0, (width * height) * sizeof(uint16_T));
}


/* ////////////////////////////// Int32 /////////////////////////////////////////// */
                
/*  Input:      RGB24 video frame */
/*  Output:     Int32 intensity matrix */
void ConvertRGB24VideoFrame_ToIInt32(void* source, 
                                     void* target,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    int32_T* out = (int32_T*)target;
    real_T factor = 16843009.0;
    real_T bias = 2147483648.0;
    real_T temp;
    EVALUATE_STRIDE_PADDING;

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount;
        int_T hCount;

        rgbIn++;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding)-width;
            for(wCount = 0; wCount < width; wCount++)
            {
                temp = CONVERT_RGB24_TO_INTENSITY_RM;
                *out++ = (int32_T)(temp * factor - bias);
            }
        }
    }
    else    /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        out += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbIn--)
            {
                out -= height;

                temp = CONVERT_RGB24_TO_INTENSITY;
                *out = (int32_T)(temp * factor - bias);
            }
            out += (frameArea + 1);
        }
    }
}


/*  Input:      (none) */
/*  Output:     black intensity video frame as Int32 matrix */
void EmptyIntensityVideoFrame_Int32(void* source, 
                                    void* target,
                                    int_T width,
                                    int_T height,
                                    VideoFrameOrientation rowOrColumn)
{
    size_t frameArea = width * height;
    int32_T* ptr = (int32_T*)target;
    size_t count;

    (void)source; /* avoid warnings */
    (void)rowOrColumn;

    for(count = 0; count < frameArea; count++)
        *ptr++ = MIN_int32_T;
}


/* ////////////////////////////// Uint32 /////////////////////////////////////////// */
                
/*  Input:      RGB24 video frame */
/*  Output:     Uint32 intensity matrix */
void ConvertRGB24VideoFrame_ToIUint32(void* source, 
                                      void* target,
                                      int_T width,
                                      int_T height,
                                      VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    uint32_T* out = (uint32_T*)target;
    uint32_T temp;
    EVALUATE_STRIDE_PADDING;
        
    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount;
        int_T hCount;
        
        rgbIn++;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding)-width;
            for(wCount = 0; wCount < width; wCount++)
            {
                temp = (uint32_T) (CONVERT_RGB24_TO_INTENSITY_RM + 0.5);
                temp = (temp << 8) | temp;
                temp = (temp << 16) | temp;
                *out++ = (temp << 16) | temp;
            }
        }
    }
    else        /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        out += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbIn--)
            {
                out -= height;

                temp = (uint32_T) (CONVERT_RGB24_TO_INTENSITY + 0.5);
                temp = (temp << 8) | temp;
                temp = (temp << 16) | temp;
                *out = (temp << 16) | temp;
            }
            out += (frameArea + 1);
        }
    }
}


/*  Input:      (none) */
/*  Output:     black intensity video frame as Uint32 matrix */
void EmptyIntensityVideoFrame_Uint32(void* source, 
                                     void* target,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn)
{
    (void)source; /* avoid warnings */
    (void)rowOrColumn;

    memset(target, 0, (width * height) * sizeof(uint32_T));
}


/* ////////////////////////////// Double /////////////////////////////////////////// */

/*  Input:      RGB24 video frame */
/*  Output:     Double intensity matrix */
void ConvertRGB24VideoFrame_ToIDouble(void* source, 
                                      void* target,
                                      int_T width,
                                      int_T height,
                                      VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    real_T* out = (real_T*)target;
    EVALUATE_STRIDE_PADDING;

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount;
        int_T hCount;

        rgbIn++;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding)-width;
            for(wCount = 0; wCount < width; wCount++)
            {
                *out++ = (CONVERT_RGB24_TO_INTENSITY_RM) / DOUBLE_255;
            }
        }
    }
    else    /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        out += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbIn--)
            {
                out -= height;

                *out = (CONVERT_RGB24_TO_INTENSITY) / DOUBLE_255;
            }
            out += (frameArea + 1);
        }
    }
}



/*  Input:      (none) */
/*  Output:     black intensity video frame as Double matrix */
void EmptyIntensityVideoFrame_Double(void* source, 
                                     void* target,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn)
{
    real_T zero = 0.0;
    real_T* out = (real_T*) target;
    int_T count = 0;
    int_T framePixels = width * height;

    (void)source; /* avoid warnings */
    (void)rowOrColumn;

    for(; count < framePixels; count++)
        *out++ = zero;
}


/* ////////////////////////////// Single /////////////////////////////////////////// */

/*  Input:      RGB24 video frame */
/*  Output:     Single intensity matrix */
void ConvertRGB24VideoFrame_ToISingle(void* source, 
                                      void* target,
                                      int_T width,
                                      int_T height,
                                      VideoFrameOrientation rowOrColumn)
{
    int_T frameArea = width * height;
    real32_T* out = (real32_T*)target;
    EVALUATE_STRIDE_PADDING;

    if(rowOrColumn == VideoFrame_RowMajor)
    {
        int_T wCount;
        int_T hCount;

        rgbIn++;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding)-width;
            for(wCount = 0; wCount < width; wCount++)
            {
                *out++ = ((real32_T)CONVERT_RGB24_TO_INTENSITY_RM) / FLOAT_255;
            }
        }
    }
    else    /*  VideoFrame_ColumnMajor */
    {
        int_T hCount;
        int_T vCount;

        out += frameArea;
        for(hCount = 0; hCount < height; hCount++)
        {
            rgbIn = (MM_RGBTRIPLE*)(((uint8_T*)rgbIn) - stridePadding);
            for(vCount = 0; vCount < width; vCount++, rgbIn--)
            {
                out -= height;

                *out = ((real32_T)CONVERT_RGB24_TO_INTENSITY) / FLOAT_255;
            }
            out += (frameArea + 1);
        }
    }
}



/*  Input:      (none) */
/*  Output:     black intensity video frame as Single matrix */
void EmptyIntensityVideoFrame_Single(void* source, 
                                     void* target,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn)
{
    real32_T zero = 0.0f;
    real32_T* out = (real32_T*) target;
    int_T count = 0;
    int_T framePixels = width * height;

    (void)source; /* avoid warnings */
    (void)rowOrColumn;

    for(; count < framePixels; count++)
        *out++ = zero;
}


#define NUM_DTYPES      9                               /* right now, anyway */

static COPY_RGB24_FUNC rgb24ToIntensityCopyFcns[] = 
{
    /*  VideoDataType_Double = 0,        double */
    ConvertRGB24VideoFrame_ToIDouble,
    /*  VideoDataType_Single,            real32_T */
    ConvertRGB24VideoFrame_ToISingle,
    /*  VideoDataType_Int8,                      char_T */
    ConvertRGB24VideoFrame_ToIInt8,
    /*  VideoDataType_Uint8,             uint8_T */
    ConvertRGB24VideoFrame_ToIUint8,
    /*  VideoDataType_Int16,             int16_T */
    ConvertRGB24VideoFrame_ToIInt16,
    /*  VideoDataType_Uint16,            uint16_T */
    ConvertRGB24VideoFrame_ToIUint16,
    /*  VideoDataType_Int32,             int32_T */
    ConvertRGB24VideoFrame_ToIInt32,
    /*  VideoDataType_Uint32,            uint32_T */
    ConvertRGB24VideoFrame_ToIUint32,
    /*  VideoDataType_Boolean            bool */
    (COPY_RGB24_FUNC) NULL
};



static COPY_RGB24_FUNC intensityEmptyFcns[] = 
{
    /*  VideoDataType_Double = 0, double */
    EmptyIntensityVideoFrame_Double,
    /*  VideoDataType_Single,    real32_T */
    EmptyIntensityVideoFrame_Single,
    /*  VideoDataType_Int8,      char_T */
    EmptyIntensityVideoFrame_Int8,
    /*  VideoDataType_Uint8,     uint8_T */
    EmptyIntensityVideoFrame_Uint8,
    /*  VideoDataType_Int16,     int16_T */
    EmptyIntensityVideoFrame_Int16,
    /*  VideoDataType_Uint16,    uint16_T */
    EmptyIntensityVideoFrame_Uint16,
    /*  VideoDataType_Int32,     int32_T */
    EmptyIntensityVideoFrame_Int32,
    /*  VideoDataType_Uint32,    uint32_T */
    EmptyIntensityVideoFrame_Uint32,
    /*  VideoDataType_Boolean    bool */
    (COPY_RGB24_FUNC) NULL
};


COPY_RGB24_FUNC MWDSP_GetRGB24ToIntensityCopyFcn(VideoDataType dType)
{
    int_T offset = dType;
    if(offset >= 0 && offset < NUM_DTYPES)
        return rgb24ToIntensityCopyFcns[offset];
    else
        return (COPY_RGB24_FUNC) NULL;
}


COPY_RGB24_FUNC MWDSP_GetIntensityEmptyFcn(VideoDataType dType)
{
    int_T offset = dType;
    if(offset >= 0 && offset < NUM_DTYPES)
        return intensityEmptyFcns[offset];
    else
        return (COPY_RGB24_FUNC) NULL;
}

#endif /* !INTEGER_CODE */

/* [EOF] mmrgb24convert2gray_rt.c */
