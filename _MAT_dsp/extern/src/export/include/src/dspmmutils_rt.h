/*
 * dspmmutils_rt.hpp Header file for utilities that provide conversion routines
 * between video and audio data formats (mainly data types) as well as routines
 * that set the data to default state (black for video, silence for audio)
 *
 * Copyright 2005-2013 The MathWorks, Inc.
 */

#ifndef DSPMMUTILS_RT_H
#define DSPMMUTILS_RT_H

#include "dsp_rt.h"

#include "VideoDefs.hpp"
#include "AudioDefs.hpp"
#ifdef MW_DSP_RT
#include "src/libmw_src_util.h"
#else
#include "libmw_src_util.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif

/* This structure is identical to the RGBTRIPLE defined in windows.h */
typedef struct tagMM_RGBTRIPLE { 
    uint8_T rgbtBlue; 
    uint8_T rgbtGreen;
    uint8_T rgbtRed; 
} MM_RGBTRIPLE; 

/*  RGB24 video data conversion function types */
typedef void (*COPY_RGB24_FUNC) (void*,void*,int_T,int_T,VideoFrameOrientation);
typedef void (*COPY_RGB24_CHANS_FUNC) (void*,void*,void*,void*,int_T,
                                       int_T,VideoFrameOrientation);
typedef void (*OUTPUT_RGB24_FUNC) (const void*,void*,int_T,int_T,
                                   VideoFrameOrientation);
typedef void (*OUTPUT_RGB24_CHANS_FUNC) (const void*,const void*,
                                         const void*,void*,int_T,int_T,
                                         VideoFrameOrientation);

/*  PCM audio data conversion function types */
typedef void (*COPY_PCM_SAMPLES_FUNC) (void*,void*,int_T,int_T);
typedef void (*OUTPUT_PCM_SAMPLES_FUNC) (const void*,void*,int_T,int_T);

/* /////////////////////////////////////////////////////////////////////// */
/*                                    VIDEO                                */
/* /////////////////////////////////////////////////////////////////////// */

LIBMW_SRC_API COPY_RGB24_FUNC         MWDSP_GetRGB24CopyFcn(VideoDataType dType);
LIBMW_SRC_API COPY_RGB24_CHANS_FUNC   MWDSP_GetRGB24ChannelsCopyFcn(VideoDataType dType);
LIBMW_SRC_API COPY_RGB24_FUNC         MWDSP_GetRGB24EmptyFcn(VideoDataType dType);
LIBMW_SRC_API COPY_RGB24_CHANS_FUNC   MWDSP_GetRGB24ChannelsEmptyFcn(VideoDataType dType);

LIBMW_SRC_API OUTPUT_RGB24_FUNC       MWDSP_GetRGB24OutputFcn(VideoDataType dType);
LIBMW_SRC_API OUTPUT_RGB24_CHANS_FUNC MWDSP_GetRGB24ChannelsOutputFcn(VideoDataType dType);

LIBMW_SRC_API OUTPUT_RGB24_FUNC       MWDSP_GetPaddedRGB24OutputFcn(VideoDataType dType);
LIBMW_SRC_API OUTPUT_RGB24_CHANS_FUNC MWDSP_GetPaddedRGB24ChannelsOutputFcn(VideoDataType dType);

LIBMW_SRC_API COPY_RGB24_FUNC         MWDSP_GetRGB24ToIntensityCopyFcn(VideoDataType dType);
LIBMW_SRC_API COPY_RGB24_FUNC         MWDSP_GetIntensityEmptyFcn(VideoDataType dType);

/* //////////////////////////// Uint8 //////////////////////////////////// */

/*  Input:	RGB24 video frame */
/*  Output:	Uint8 matrix */
void CopyRGB24VideoFrame_ToUint8(void* source, 
                                 void* target,
                                 int_T width,
                                 int_T height,
                                 VideoFrameOrientation rowOrColumn);

/*  Input:	RGB24 video frame */
/*  Output:	three Uint8 matrices */
void CopyRGB24VideoFrame_ToUint8_Channels(void* source, 
                                          void* targetRed,
                                          void* targetGreen,
                                          void* targetBlue,
                                          int_T width,
                                          int_T height,
                                          VideoFrameOrientation rowOrColumn);

/*  Input:	Uint8 matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromUint8(const void* input,
                                     void* output,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn);


/*  Input:	three Uint8 matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromUint8_Channels(const void* sourceRed,
                                              const void* sourceGreen,
                                              const void* sourceBlue,
                                              void* output,
                                              int_T width,
                                              int_T height,
                                              VideoFrameOrientation rowOrColumn);

/*  Input:	Uint8 matrix */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromUint8(const void* input,
                                           void* output,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn);


/*  Input:	three Uint8 matrices */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromUint8_Channels(const void* sourceRed,
                                                    const void* sourceGreen,
                                                    const void* sourceBlue,
                                                    void* output,
                                                    int_T width,
                                                    int_T height,
                                                    VideoFrameOrientation rowOrColumn);

/*  Input:	(none) */
/*  Output:	black RGB24 video frame as Uint8 matrix */
void EmptyRGB24VideoFrame_ToUint8(void* source, 
                                  void* target,
                                  int_T width,
                                  int_T height,
                                  VideoFrameOrientation rowOrColumn);

/*  Input:	(none) */
/*  Output:	black RGB24 video frame as three Uint8 matrices */
void EmptyRGB24VideoFrame_ToUint8_Channels(void* source, 
                                           void* targetRed,
                                           void* targetGreen,
                                           void* targetBlue,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn);

/*  Input:	RGB24 video frame */
/*  Output:	Uint8 intensity matrix */
void ConvertRGB24VideoFrame_ToIUint8(void* source, 
                                     void* target,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn);


/*  Input:	(none) */
/*  Output:	black intensity video frame as Uint8 matrix */
void EmptyIntensityVideoFrame_Uint8(void* source, 
                                    void* target,
                                    int_T width,
                                    int_T height,
                                    VideoFrameOrientation rowOrColumn);


/* //////////////////////// Int8 //////////////////////////////// */

/*  Input:	RGB24 video frame */
/*  Output:	Int8 matrix */
void CopyRGB24VideoFrame_ToInt8(void* source, 
                                void* target,
                                int_T width,
                                int_T height,
                                VideoFrameOrientation rowOrColumn);

/*  Input:	RGB24 video frame */
/*  Output:	three Int8 matrices */
void CopyRGB24VideoFrame_ToInt8_Channels(void* source, 
                                         void* targetRed,
                                         void* targetGreen,
                                         void* targetBlue,
                                         int_T width,
                                         int_T height,
                                         VideoFrameOrientation rowOrColumn);

/*  Input:	(none) */
/*  Output:	black RGB24 video frame as Int8 matrix */
void EmptyRGB24VideoFrame_ToInt8(void* source, 
                                 void* target,
                                 int_T width,
                                 int_T height,
                                 VideoFrameOrientation rowOrColumn);

/*  Input:	(none) */
/*  Output:	black RGB24 video frame as three Int8 matrices */
void EmptyRGB24VideoFrame_ToInt8_Channels(void* source, 
                                          void* targetRed,
                                          void* targetGreen,
                                          void* targetBlue,
                                          int_T width,
                                          int_T height,
                                          VideoFrameOrientation rowOrColumn);


/*  Input:	Int8 matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromInt8(const void* input,
                                    void* output,
                                    int_T width,
                                    int_T height,
                                    VideoFrameOrientation rowOrColumn);


/*  Input:	three Int8 matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromInt8_Channels(const void* sourceRed,
                                             const void* sourceGreen,
                                             const void* sourceBlue,
                                             void* output,
                                             int_T width,
                                             int_T height,
                                             VideoFrameOrientation rowOrColumn);

/*  Input:	Int8 matrix */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromInt8(const void* input,
                                          void* output,
                                          int_T width,
                                          int_T height,
                                          VideoFrameOrientation rowOrColumn);


/*  Input:	three Int8 matrices */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromInt8_Channels(const void* sourceRed,
                                                   const void* sourceGreen,
                                                   const void* sourceBlue,
                                                   void* output,
                                                   int_T width,
                                                   int_T height,
                                                   VideoFrameOrientation rowOrColumn);


/*  Input:	RGB24 video frame */
/*  Output:	Int8 intensity matrix */
void ConvertRGB24VideoFrame_ToIInt8(void* source, 
                                    void* target,
                                    int_T width,
                                    int_T height,
                                    VideoFrameOrientation rowOrColumn);


/*  Input:	(none) */
/*  Output:	black intensity video frame as Int8 matrix */
void EmptyIntensityVideoFrame_Int8(void* source, 
                                   void* target,
                                   int_T width,
                                   int_T height,
                                   VideoFrameOrientation rowOrColumn);



/* //////////////////////////// Int16 ////////////////////////////// */

/*  Input:	RGB24 video frame */
/*  Output:	Int16 matrix */
void CopyRGB24VideoFrame_ToInt16(void* source, 
                                 void* target,
                                 int_T width,
                                 int_T height,
                                 VideoFrameOrientation rowOrColumn);

/*  Input:	RGB24 video frame */
/*  Output:	three Int16 matrices */
void CopyRGB24VideoFrame_ToInt16_Channels(void* source, 
                                          void* targetRed,
                                          void* targetGreen,
                                          void* targetBlue,
                                          int_T width,
                                          int_T height,
                                          VideoFrameOrientation rowOrColumn);

/*  Input:	(none) */
/*  Output:	black RGB24 video frame as Int16 matrix */
void EmptyRGB24VideoFrame_ToInt16(void* source, 
                                  void* target,
                                  int_T width,
                                  int_T height,
                                  VideoFrameOrientation rowOrColumn);

/*  Input:	(none) */
/*  Output:	black RGB24 video frame as three Int16 matrices */
void EmptyRGB24VideoFrame_ToInt16_Channels(void* source, 
                                           void* targetRed,
                                           void* targetGreen,
                                           void* targetBlue,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn);


/*  Input:	Int16 matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromInt16(const void* input,
                                     void* output,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn);


/*  Input:	three Int16 matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromInt16_Channels(const void* sourceRed,
                                              const void* sourceGreen,
                                              const void* sourceBlue,
                                              void* output,
                                              int_T width,
                                              int_T height,
                                              VideoFrameOrientation rowOrColumn);

/*  Input:	Int16 matrix */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromInt16(const void* input,
                                           void* output,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn);


/*  Input:	three Int16 matrices */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromInt16_Channels(const void* sourceRed,
                                                    const void* sourceGreen,
                                                    const void* sourceBlue,
                                                    void* output,
                                                    int_T width,
                                                    int_T height,
                                                    VideoFrameOrientation rowOrColumn);


/*  Input:	RGB24 video frame */
/*  Output:	Int16 intensity matrix */
void ConvertRGB24VideoFrame_ToIInt16(void* source, 
                                     void* target,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn);


/*  Input:	(none) */
/*  Output:	black intensity video frame as Int16 matrix */
void EmptyIntensityVideoFrame_Int16(void* source, 
                                    void* target,
                                    int_T width,
                                    int_T height,
                                    VideoFrameOrientation rowOrColumn);



/* ////////////////////////// Uint16 ///////////////////////////////////// */

/*  Input:	RGB24 video frame */
/*  Output:	Uint16 matrix */
void CopyRGB24VideoFrame_ToUint16(void* source, 
                                  void* target,
                                  int_T width,
                                  int_T height,
                                  VideoFrameOrientation rowOrColumn);

/*  Input:	RGB24 video frame */
/*  Output:	three Uint16 matrices */
void CopyRGB24VideoFrame_ToUint16_Channels(void* source, 
                                           void* targetRed,
                                           void* targetGreen,
                                           void* targetBlue,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn);

/*  Input:	(none) */
/*  Output:	black RGB24 video frame as Uint16 matrix */
void EmptyRGB24VideoFrame_ToUint16(void* source, 
                                   void* target,
                                   int_T width,
                                   int_T height,
                                   VideoFrameOrientation rowOrColumn);

/*  Input:	(none) */
/*  Output:	black RGB24 video frame as three Uint16 matrices */
void EmptyRGB24VideoFrame_ToUint16_Channels(void* source, 
                                            void* targetRed,
                                            void* targetGreen,
                                            void* targetBlue,
                                            int_T width,
                                            int_T height,
                                            VideoFrameOrientation rowOrColumn);


/*  Input:	Uint16 matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromUint16(const void* input,
                                      void* output,
                                      int_T width,
                                      int_T height,
                                      VideoFrameOrientation rowOrColumn);


/*  Input:	three Uint16 matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromUint16_Channels(const void* sourceRed,
                                               const void* sourceGreen,
                                               const void* sourceBlue,
                                               void* output,
                                               int_T width,
                                               int_T height,
                                               VideoFrameOrientation rowOrColumn);

/*  Input:	Uint16 matrix */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromUint16(const void* input,
                                            void* output,
                                            int_T width,
                                            int_T height,
                                            VideoFrameOrientation rowOrColumn);


/*  Input:	three Uint16 matrices */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromUint16_Channels(const void* sourceRed,
                                                     const void* sourceGreen,
                                                     const void* sourceBlue,
                                                     void* output,
                                                     int_T width,
                                                     int_T height,
                                                     VideoFrameOrientation rowOrColumn);


/*  Input:	RGB24 video frame */
/*  Output:	Uint16 intensity matrix */
void ConvertRGB24VideoFrame_ToIUint16(void* source, 
                                      void* target,
                                      int_T width,
                                      int_T height,
                                      VideoFrameOrientation rowOrColumn);



/*  Input:	(none) */
/*  Output:	black intensity video frame as Uint16 matrix */
void EmptyIntensityVideoFrame_Uint16(void* source, 
                                     void* target,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn);



/* ////////////////////////////// Int32 ////////////////////////////////// */

/*  Input:	RGB24 video frame */
/*  Output:	Int32 matrix */
void CopyRGB24VideoFrame_ToInt32(void* source, 
                                 void* target,
                                 int_T width,
                                 int_T height,
                                 VideoFrameOrientation rowOrColumn);

/*  Input:	RGB24 video frame */
/*  Output:	three Int32 matrices */
void CopyRGB24VideoFrame_ToInt32_Channels(void* source, 
                                          void* targetRed,
                                          void* targetGreen,
                                          void* targetBlue,
                                          int_T width,
                                          int_T height,
                                          VideoFrameOrientation rowOrColumn);

/*  Input:	(none) */
/*  Output:	black RGB24 video frame as Int32 matrix */
void EmptyRGB24VideoFrame_ToInt32(void* source, 
                                  void* target,
                                  int_T width,
                                  int_T height,
                                  VideoFrameOrientation rowOrColumn);

/*  Input:	(none) */
/*  Output:	black RGB24 video frame as three Int32 matrices */
void EmptyRGB24VideoFrame_ToInt32_Channels(void* source, 
                                           void* targetRed,
                                           void* targetGreen,
                                           void* targetBlue,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn);


/*  Input:	Int32 matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromInt32(const void* input,
                                     void* output,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn);


/*  Input:	three Int32 matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromInt32_Channels(const void* sourceRed,
                                              const void* sourceGreen,
                                              const void* sourceBlue,
                                              void* output,
                                              int_T width,
                                              int_T height,
                                              VideoFrameOrientation rowOrColumn);

/*  Input:	Int32 matrix */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromInt32(const void* input,
                                           void* output,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn);


/*  Input:	three Int32 matrices */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromInt32_Channels(const void* sourceRed,
                                                    const void* sourceGreen,
                                                    const void* sourceBlue,
                                                    void* output,
                                                    int_T width,
                                                    int_T height,
                                                    VideoFrameOrientation rowOrColumn);


/*  Input:	RGB24 video frame */
/*  Output:	Int32 intensity matrix */
void ConvertRGB24VideoFrame_ToIInt32(void* source, 
                                     void* target,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn);


/*  Input:	(none) */
/*  Output:	black intensity video frame as Int32 matrix */
void EmptyIntensityVideoFrame_Int32(void* source, 
                                    void* target,
                                    int_T width,
                                    int_T height,
                                    VideoFrameOrientation rowOrColumn);



/* //////////////////////////// Uint32 /////////////////////////////////// */

/*  Input:	RGB24 video frame */
/*  Output:	Uint32 matrix */
void CopyRGB24VideoFrame_ToUint32(void* source, 
                                  void* target,
                                  int_T width,
                                  int_T height,
                                  VideoFrameOrientation rowOrColumn);

/*  Input:	RGB24 video frame */
/*  Output:	three Uint32 matrices */
void CopyRGB24VideoFrame_ToUint32_Channels(void* source, 
                                           void* targetRed,
                                           void* targetGreen,
                                           void* targetBlue,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn);

/*  Input:	(none) */
/*  Output:	black RGB24 video frame as Uint32 matrix */
void EmptyRGB24VideoFrame_ToUint16(void* source, 
                                   void* target,
                                   int_T width,
                                   int_T height,
                                   VideoFrameOrientation rowOrColumn);

/*  Input:	(none) */
/*  Output:	black RGB24 video frame as three Uint32 matrices */
void EmptyRGB24VideoFrame_ToUint16_Channels(void* source, 
                                            void* targetRed,
                                            void* targetGreen,
                                            void* targetBlue,
                                            int_T width,
                                            int_T height,
                                            VideoFrameOrientation rowOrColumn);


/*  Input:	Uint32 matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromUint32(const void* input,
                                      void* output,
                                      int_T width,
                                      int_T height,
                                      VideoFrameOrientation rowOrColumn);


/*  Input:	three Uint32 matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromUint32_Channels(const void* sourceRed,
                                               const void* sourceGreen,
                                               const void* sourceBlue,
                                               void* output,
                                               int_T width,
                                               int_T height,
                                               VideoFrameOrientation rowOrColumn);

/*  Input:	Uint32 matrix */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromUint32(const void* input,
                                            void* output,
                                            int_T width,
                                            int_T height,
                                            VideoFrameOrientation rowOrColumn);


/*  Input:	three Uint32 matrices */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromUint32_Channels(const void* sourceRed,
                                                     const void* sourceGreen,
                                                     const void* sourceBlue,
                                                     void* output,
                                                     int_T width,
                                                     int_T height,
                                                     VideoFrameOrientation rowOrColumn);



/*  Input:	RGB24 video frame */
/*  Output:	Uint32 intensity matrix */
void ConvertRGB24VideoFrame_ToIUint32(void* source, 
                                      void* target,
                                      int_T width,
                                      int_T height,
                                      VideoFrameOrientation rowOrColumn);


/*  Input:	(none) */
/*  Output:	black intensity video frame as Uint32 matrix */
void EmptyIntensityVideoFrame_Uint32(void* source, 
                                     void* target,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn);



/* /////////////////////////// Double ////////////////////////////////// */

/*  Input:	RGB24 video frame */
/*  Output:	Double matrix */
void CopyRGB24VideoFrame_ToDouble(void* source, 
                                  void* target,
                                  int_T width,
                                  int_T height,
                                  VideoFrameOrientation rowOrColumn);

/*  Input:	RGB24 video frame */
/*  Output:	three Double matrices */
void CopyRGB24VideoFrame_ToDouble_Channels(void* source, 
                                           void* targetRed,
                                           void* targetGreen,
                                           void* targetBlue,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn);

/*  Input:	Double matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromDouble(const void* input,
                                      void* output,
                                      int_T width,
                                      int_T height,
                                      VideoFrameOrientation rowOrColumn);


/*  Input:	three Double matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromDouble_Channels(const void* sourceRed,
                                               const void* sourceGreen,
                                               const void* sourceBlue,
                                               void* output,
                                               int_T width,
                                               int_T height,
                                               VideoFrameOrientation rowOrColumn);


/*  Input:	Double matrix */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromDouble(const void* input,
                                            void* output,
                                            int_T width,
                                            int_T height,
                                            VideoFrameOrientation rowOrColumn);


/*  Input:	three Double matrices */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromDouble_Channels(const void* sourceRed,
                                                     const void* sourceGreen,
                                                     const void* sourceBlue,
                                                     void* output,
                                                     int_T width,
                                                     int_T height,
                                                     VideoFrameOrientation rowOrColumn);


/*  Input:	(none) */
/*  Output:	black RGB24 video frame as Double matrix */
void EmptyRGB24VideoFrame_ToDouble(void* source, 
                                   void* target,
                                   int_T width,
                                   int_T height,
                                   VideoFrameOrientation rowOrColumn);

/*  Input:	(none) */
/*  Output:	black RGB24 video frame as three Double matrices */
void EmptyRGB24VideoFrame_ToDouble_Channels(void* source, 
                                            void* targetRed,
                                            void* targetGreen,
                                            void* targetBlue,
                                            int_T width,
                                            int_T height,
                                            VideoFrameOrientation rowOrColumn);


/*  Input:	RGB24 video frame */
/*  Output:	Double intensity matrix */
void ConvertRGB24VideoFrame_ToIDouble(void* source, 
                                      void* target,
                                      int_T width,
                                      int_T height,
                                      VideoFrameOrientation rowOrColumn);



/*  Input:	(none) */
/*  Output:	black intensity video frame as Double matrix */
void EmptyIntensityVideoFrame_Double(void* source, 
                                     void* target,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn);



/* ///////////////////////////// Single ////////////////////////////////// */

/*  Input:	RGB24 video frame */
/*  Output:	Single matrix */
void CopyRGB24VideoFrame_ToSingle(void* source, 
                                  void* target,
                                  int_T width,
                                  int_T height,
                                  VideoFrameOrientation rowOrColumn);

/*  Input:	RGB24 video frame */
/*  Output:	three Single matrices */
void CopyRGB24VideoFrame_ToSingle_Channels(void* source, 
                                           void* targetRed,
                                           void* targetGreen,
                                           void* targetBlue,
                                           int_T width,
                                           int_T height,
                                           VideoFrameOrientation rowOrColumn);

/*  Input:	Single matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromSingle(const void* input,
                                      void* output,
                                      int_T width,
                                      int_T height,
                                      VideoFrameOrientation rowOrColumn);


/*  Input:	three Single matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromSingle_Channels(const void* sourceRed,
                                               const void* sourceGreen,
                                               const void* sourceBlue,
                                               void* output,
                                               int_T width,
                                               int_T height,
                                               VideoFrameOrientation rowOrColumn);


/*  Input:	Single matrix */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromSingle(const void* input,
                                            void* output,
                                            int_T width,
                                            int_T height,
                                            VideoFrameOrientation rowOrColumn);


/*  Input:	three Single matrices */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromSingle_Channels(const void* sourceRed,
                                                     const void* sourceGreen,
                                                     const void* sourceBlue,
                                                     void* output,
                                                     int_T width,
                                                     int_T height,
                                                     VideoFrameOrientation rowOrColumn);


/*  Input:	(none) */
/*  Output:	black RGB24 video frame as Single matrix */
void EmptyRGB24VideoFrame_ToSingle(void* source, 
                                   void* target,
                                   int_T width,
                                   int_T height,
                                   VideoFrameOrientation rowOrColumn);

/*  Input:	(none) */
/*  Output:	black RGB24 video frame as three Single matrices */
void EmptyRGB24VideoFrame_ToSingle_Channels(void* source, 
                                            void* targetRed,
                                            void* targetGreen,
                                            void* targetBlue,
                                            int_T width,
                                            int_T height,
                                            VideoFrameOrientation rowOrColumn);



/*  Input:	RGB24 video frame */
/*  Output:	Single intensity matrix */
void ConvertRGB24VideoFrame_ToISingle(void* source, 
                                      void* target,
                                      int_T width,
                                      int_T height,
                                      VideoFrameOrientation rowOrColumn);


/*  Input:	(none) */
/*  Output:	black intensity video frame as Single matrix */
void EmptyIntensityVideoFrame_Single(void* source, 
                                     void* target,
                                     int_T width,
                                     int_T height,
                                     VideoFrameOrientation rowOrColumn);



/* ///////////////////////////// Boolean //////////////////////////// */

		
/*  Input:	Boolean matrix */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromBoolean(const void* input,
                                       void* output,
                                       int_T width,
                                       int_T height,
                                       VideoFrameOrientation rowOrColumn);

		
/*  Input:	three Boolean matrices */
/*  Output:	RGB24 video frame */
void OutputRGB24VideoFrame_FromBoolean_Channels(const void* sourceRed,
                                                const void* sourceGreen,
                                                const void* sourceBlue,
                                                void* output,
                                                int_T width,
                                                int_T height,
                                                VideoFrameOrientation rowOrColumn);



		
/*  Input:	Boolean matrix */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromBoolean(const void* input,
                                             void* output,
                                             int_T width,
                                             int_T height,
                                             VideoFrameOrientation rowOrColumn);

		
/*  Input:	three Boolean matrices */
/*  Output:	Padded RGB24 video frame */
void OutputPaddedRGB24VideoFrame_FromBoolean_Channels(const void* sourceRed,
                                                      const void* sourceGreen,
                                                      const void* sourceBlue,
                                                      void* output,
                                                      int_T width,
                                                      int_T height,
                                                      VideoFrameOrientation rowOrColumn);






/* /////////////////////////////////////////////////////////////////// */
/*                                AUDIO                                */
/* /////////////////////////////////////////////////////////////////// */

LIBMW_SRC_API COPY_PCM_SAMPLES_FUNC   MWDSP_GetPCMAudioCopyFcn(AudioDataType dType, int_T numBits);
LIBMW_SRC_API COPY_PCM_SAMPLES_FUNC   MWDSP_GetPCMAudioEmptyFcn(AudioDataType dType);
LIBMW_SRC_API OUTPUT_PCM_SAMPLES_FUNC MWDSP_GetPCMAudioOutputFcn(AudioDataType dType, int_T numBits);

/*  Input:	24-bit PCM audio samples */
/*  Output:	Double-precision array */
void Copy24BitPCM_ToDouble(void* buffer, void* outputSignal, 
                           int_T numSamples, int_T numChannels);


/*  Input:	16-bit PCM audio samples */
/*  Output:	Double-precision array */
void Copy16BitPCM_ToDouble(void* buffer, void* outputSignal, 
                           int_T numSamples, int_T numChannels);


		
/*  Input:	8-bit PCM audio samples (unsigned) */
/*  Output:	Double-precision array */
void Copy8BitPCM_ToDouble(void* buffer, void* outputSignal, 
                          int_T numSamples, int_T numChannels);


		
/*  Input:	24-bit PCM audio samples */
/*  Output:	Single-precision array */
void Copy24BitPCM_ToSingle(void* buffer, void* outputSignal, 
                           int_T numSamples, int_T numChannels);


		
/*  Input:	16-bit PCM audio samples */
/*  Output:	Single-precision array */
void Copy16BitPCM_ToSingle(void* buffer, void* outputSignal, 
                           int_T numSamples, int_T numChannels);


		
/*  Input:	8-bit PCM audio samples (unsigned) */
/*  Output:	Single-precision array */
void Copy8BitPCM_ToSingle(void* buffer, void* outputSignal, 
                          int_T numSamples, int_T numChannels);


		
/*  Input:	16-bit PCM audio samples */
/*  Output:	Int16 array */
void Copy16BitPCM_ToInt16(void* buffer, void* outputSignal, 
                          int_T numSamples, int_T numChannels);


		
/*  Input:	8-bit PCM audio samples (unsigned) */
/*  Output:	Uint8 array */
void Copy8BitPCM_ToUint8(void* buffer, void* outputSignal, 
                         int_T numSamples, int_T numChannels);


/*  Input:	8-bit PCM audio samples (unsigned) */
/*  Output:	Int16 array */
void Copy8BitPCM_ToInt16(void* buffer, void* outputSignal, 
                         int_T numSamples, int_T numChannels);


/*  Input:	16-bit PCM audio samples */
/*  Output:	Uint8 array */
void Copy16BitPCM_ToUint8(void* buffer, void* outputSignal, 
                          int_T numSamples, int_T numChannels);

		
/*  Input:	32-bit normalized, IEEE Type 3 PCM audio samples */
/*  Output:	Double-precision array */
void Copy32BitType3PCM_ToDouble(void* buffer, void* outputSignal,
                                int_T numSamples, int_T numChannels);

		
/*  Input:	32-bit normalized, IEEE Type 3 PCM audio samples */
/*  Output:	Single-precision array */
void Copy32BitType3PCM_ToSingle(void* buffer, void* outputSignal,
                                int_T numSamples, int_T numChannels);


/*  Input:	Doesn't matter */
/*  Output:	Double-precision array of zeros */
void EmptyPCM_ToDouble(void* buffer, void* outputSignal, 
                       int_T numSamples, int_T numChannels);

		
/*  Input:	Doesn't matter */
/*  Output:	Single-precision array of zeros */
void EmptyPCM_ToSingle(void* buffer, void* outputSignal, 
                       int_T numSamples, int_T numChannels);

		
/*  Input:	Doesn't matter */
/*  Output:	Int16 array of zeros */
void EmptyPCM_ToInt16(void* buffer, void* outputSignal, 
                      int_T numSamples, int_T numChannels);

		
/*  Input:	Doesn't matter */
/*  Output:	Uint8 array of zeros */
void EmptyPCM_ToUint8(void* buffer, void* outputSignal, 
                      int_T numSamples, int_T numChannels);


		
/*  Input:	Double-precision array */
/*  Output:	16-bit PCM audio samples */
void Output16BitPCM_FromDouble(const void* inputSignal, void* output, 
                               int_T numSamples, int_T numChannels);


		
/*  Input:	Double-precsion array */
/*  Output:	24-bit PCM audio samples */
void Output24BitPCM_FromDouble(const void* inputSignal, void* output, 
                               int_T numSamples, int_T numChannels);


		
/*  Input:	Single-precision array */
/*  Output:	24-bit PCM audio samples */
void Output24BitPCM_FromSingle(const void* inputSignal, void* output, 
                               int_T numSamples, int_T numChannels);


		
/*  Input:	Single-precision array */
/*  Output:	16-bit PCM audio samples */
void Output16BitPCM_FromSingle(const void* inputSignal, void* output, 
                               int_T numSamples, int_T numChannels);


		
/*  Input:	Int16 array */
/*  Output:	16-bit PCM audio samples */
void Output16BitPCM_FromInt16(const void* inputSignal, void* output, 
                              int_T numSamples, int_T numChannels);

		
/*  Input:	Uint8 array */
/*  Output:	8-bit PCM audio samples (unsigned) */
void Output8BitPCM_FromUint8(const void* inputSignal, void* output, 
                             int_T numSamples, int_T numChannels);



		
/*  Input:	Double-precision array */
/*  Output:	32-bit normalized, IEEE Type 3 PCM audio samples */
void Output32BitType3PCM_FromDouble(const void* inputSignal, void* output, 
                                    int_T numSamples, int_T numChannels);


		
/*  Input:	Double-precision array */
/*  Output:	8-bit PCM audio samples (unsigned) */
void Output8BitPCM_FromDouble(const void* inputSignal, void* output, 
                              int_T numSamples, int_T numChannels);


		
/*  Input:	Single-precision array */
/*  Output:	32-bit normalized, IEEE Type 3 PCM audio samples */
void Output32BitType3PCM_FromSingle(const void* inputSignal, void* output, 
                                    int_T numSamples, int_T numChannels);


		
/*  Input:	Single-precision array */
/*  Output:	8-bit PCM audio samples (unsigned) */
void Output8BitPCM_FromSingle(const void* inputSignal, void* output, 
                              int_T numSamples, int_T numChannels);


/*  Input:	Int16 array */
/*  Output:	8-bit PCM audio samples (unsigned) */
void Output8BitPCM_FromInt16(const void* inputSignal, void* output, 
                             int_T numSamples, int_T numChannels);

		
/*  Input:	Uint8 array */
/*  Output:	16-bit PCM audio samples */
void Output16BitPCM_FromUint8(const void* inputSignal, void* output, 
                              int_T numSamples, int_T numChannels);

#ifdef __cplusplus
}
#endif


#endif /*  MMUTILS_H */
