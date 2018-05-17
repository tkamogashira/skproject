/* Include files */

#include "Klatt2_sfun.h"
#include "Klatt2_sfun_debug_macros.h"
#include "c1_Klatt2.h"
#include "c2_Klatt2.h"
#include "c3_Klatt2.h"
#include "c4_Klatt2.h"
#include "c5_Klatt2.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */
uint32_T _Klatt2MachineNumber_;

/* Function Declarations */

/* Function Definitions */
void Klatt2_initializer(void)
{
}

void Klatt2_terminator(void)
{
}

/* SFunction Glue Code */
unsigned int sf_Klatt2_method_dispatcher(SimStruct *simstructPtr, unsigned int
  chartFileNumber, const char* specsCksum, int_T method, void *data)
{
  if (chartFileNumber==1) {
    c1_Klatt2_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==2) {
    c2_Klatt2_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==3) {
    c3_Klatt2_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==4) {
    c4_Klatt2_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==5) {
    c5_Klatt2_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  return 0;
}

unsigned int sf_Klatt2_process_check_sum_call( int nlhs, mxArray * plhs[], int
  nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[20];
  if (nrhs<1 || !mxIsChar(prhs[0]) )
    return 0;

  /* Possible call to get the checksum */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"sf_get_check_sum"))
    return 0;
  plhs[0] = mxCreateDoubleMatrix( 1,4,mxREAL);
  if (nrhs>1 && mxIsChar(prhs[1])) {
    mxGetString(prhs[1], commandName,sizeof(commandName)/sizeof(char));
    commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
    if (!strcmp(commandName,"machine")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3318325528U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(3391472399U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(70966958U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(3799083762U);
    } else if (!strcmp(commandName,"exportedFcn")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(0U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(0U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(0U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(0U);
    } else if (!strcmp(commandName,"makefile")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(2035000476U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(536832800U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(2609441188U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(3527329208U);
    } else if (nrhs==3 && !strcmp(commandName,"chart")) {
      unsigned int chartFileNumber;
      chartFileNumber = (unsigned int)mxGetScalar(prhs[2]);
      switch (chartFileNumber) {
       case 1:
        {
          extern void sf_c1_Klatt2_get_check_sum(mxArray *plhs[]);
          sf_c1_Klatt2_get_check_sum(plhs);
          break;
        }

       case 2:
        {
          extern void sf_c2_Klatt2_get_check_sum(mxArray *plhs[]);
          sf_c2_Klatt2_get_check_sum(plhs);
          break;
        }

       case 3:
        {
          extern void sf_c3_Klatt2_get_check_sum(mxArray *plhs[]);
          sf_c3_Klatt2_get_check_sum(plhs);
          break;
        }

       case 4:
        {
          extern void sf_c4_Klatt2_get_check_sum(mxArray *plhs[]);
          sf_c4_Klatt2_get_check_sum(plhs);
          break;
        }

       case 5:
        {
          extern void sf_c5_Klatt2_get_check_sum(mxArray *plhs[]);
          sf_c5_Klatt2_get_check_sum(plhs);
          break;
        }

       default:
        ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(0.0);
      }
    } else if (!strcmp(commandName,"target")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(814460797U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(400623215U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(1072597456U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(1176453921U);
    } else {
      return 0;
    }
  } else {
    ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3584806622U);
    ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(2183136527U);
    ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(3538484084U);
    ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(1418923364U);
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_Klatt2_autoinheritance_info( int nlhs, mxArray * plhs[], int
  nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[32];
  char aiChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]) )
    return 0;

  /* Possible call to get the autoinheritance_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_autoinheritance_info"))
    return 0;
  mxGetString(prhs[2], aiChksum,sizeof(aiChksum)/sizeof(char));
  aiChksum[(sizeof(aiChksum)/sizeof(char)-1)] = '\0';

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        if (strcmp(aiChksum, "GjOSZN2sb7qoiXoCt273RD") == 0) {
          extern mxArray *sf_c1_Klatt2_get_autoinheritance_info(void);
          plhs[0] = sf_c1_Klatt2_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 2:
      {
        if (strcmp(aiChksum, "1Rp3UImfr28g4GvsnehgEG") == 0) {
          extern mxArray *sf_c2_Klatt2_get_autoinheritance_info(void);
          plhs[0] = sf_c2_Klatt2_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 3:
      {
        if (strcmp(aiChksum, "wuvYZhUzh5G5slFomrAxW") == 0) {
          extern mxArray *sf_c3_Klatt2_get_autoinheritance_info(void);
          plhs[0] = sf_c3_Klatt2_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 4:
      {
        if (strcmp(aiChksum, "GjOSZN2sb7qoiXoCt273RD") == 0) {
          extern mxArray *sf_c4_Klatt2_get_autoinheritance_info(void);
          plhs[0] = sf_c4_Klatt2_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 5:
      {
        if (strcmp(aiChksum, "3gRuvCbwJeTLdP8iD19NUG") == 0) {
          extern mxArray *sf_c5_Klatt2_get_autoinheritance_info(void);
          plhs[0] = sf_c5_Klatt2_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_Klatt2_get_eml_resolved_functions_info( int nlhs, mxArray *
  plhs[], int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[64];
  if (nrhs<2 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the get_eml_resolved_functions_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_eml_resolved_functions_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        extern const mxArray *sf_c1_Klatt2_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c1_Klatt2_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 2:
      {
        extern const mxArray *sf_c2_Klatt2_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c2_Klatt2_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 3:
      {
        extern const mxArray *sf_c3_Klatt2_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c3_Klatt2_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 4:
      {
        extern const mxArray *sf_c4_Klatt2_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c4_Klatt2_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 5:
      {
        extern const mxArray *sf_c5_Klatt2_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c5_Klatt2_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_Klatt2_third_party_uses_info( int nlhs, mxArray * plhs[], int
  nrhs, const mxArray * prhs[] )
{
  char commandName[64];
  char tpChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the third_party_uses_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  mxGetString(prhs[2], tpChksum,sizeof(tpChksum)/sizeof(char));
  tpChksum[(sizeof(tpChksum)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_third_party_uses_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        if (strcmp(tpChksum, "WSwqwBMp4X1xhJJY2QcHXF") == 0) {
          extern mxArray *sf_c1_Klatt2_third_party_uses_info(void);
          plhs[0] = sf_c1_Klatt2_third_party_uses_info();
          break;
        }
      }

     case 2:
      {
        if (strcmp(tpChksum, "7kKJ6DtGkApVNOjjUFnQcG") == 0) {
          extern mxArray *sf_c2_Klatt2_third_party_uses_info(void);
          plhs[0] = sf_c2_Klatt2_third_party_uses_info();
          break;
        }
      }

     case 3:
      {
        if (strcmp(tpChksum, "M6nTFROKuyOkY7VWcIV5FH") == 0) {
          extern mxArray *sf_c3_Klatt2_third_party_uses_info(void);
          plhs[0] = sf_c3_Klatt2_third_party_uses_info();
          break;
        }
      }

     case 4:
      {
        if (strcmp(tpChksum, "WSwqwBMp4X1xhJJY2QcHXF") == 0) {
          extern mxArray *sf_c4_Klatt2_third_party_uses_info(void);
          plhs[0] = sf_c4_Klatt2_third_party_uses_info();
          break;
        }
      }

     case 5:
      {
        if (strcmp(tpChksum, "bfCVN310uAmqY2goc5231C") == 0) {
          extern mxArray *sf_c5_Klatt2_third_party_uses_info(void);
          plhs[0] = sf_c5_Klatt2_third_party_uses_info();
          break;
        }
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;
}

unsigned int sf_Klatt2_updateBuildInfo_args_info( int nlhs, mxArray * plhs[],
  int nrhs, const mxArray * prhs[] )
{
  char commandName[64];
  char tpChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the updateBuildInfo_args_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  mxGetString(prhs[2], tpChksum,sizeof(tpChksum)/sizeof(char));
  tpChksum[(sizeof(tpChksum)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_updateBuildInfo_args_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        if (strcmp(tpChksum, "WSwqwBMp4X1xhJJY2QcHXF") == 0) {
          extern mxArray *sf_c1_Klatt2_updateBuildInfo_args_info(void);
          plhs[0] = sf_c1_Klatt2_updateBuildInfo_args_info();
          break;
        }
      }

     case 2:
      {
        if (strcmp(tpChksum, "7kKJ6DtGkApVNOjjUFnQcG") == 0) {
          extern mxArray *sf_c2_Klatt2_updateBuildInfo_args_info(void);
          plhs[0] = sf_c2_Klatt2_updateBuildInfo_args_info();
          break;
        }
      }

     case 3:
      {
        if (strcmp(tpChksum, "M6nTFROKuyOkY7VWcIV5FH") == 0) {
          extern mxArray *sf_c3_Klatt2_updateBuildInfo_args_info(void);
          plhs[0] = sf_c3_Klatt2_updateBuildInfo_args_info();
          break;
        }
      }

     case 4:
      {
        if (strcmp(tpChksum, "WSwqwBMp4X1xhJJY2QcHXF") == 0) {
          extern mxArray *sf_c4_Klatt2_updateBuildInfo_args_info(void);
          plhs[0] = sf_c4_Klatt2_updateBuildInfo_args_info();
          break;
        }
      }

     case 5:
      {
        if (strcmp(tpChksum, "bfCVN310uAmqY2goc5231C") == 0) {
          extern mxArray *sf_c5_Klatt2_updateBuildInfo_args_info(void);
          plhs[0] = sf_c5_Klatt2_updateBuildInfo_args_info();
          break;
        }
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;
}

void Klatt2_debug_initialize(struct SfDebugInstanceStruct* debugInstance)
{
  _Klatt2MachineNumber_ = sf_debug_initialize_machine(debugInstance,"Klatt2",
    "sfun",0,5,0,0,0);
  sf_debug_set_machine_event_thresholds(debugInstance,_Klatt2MachineNumber_,0,0);
  sf_debug_set_machine_data_thresholds(debugInstance,_Klatt2MachineNumber_,0);
}

void Klatt2_register_exported_symbols(SimStruct* S)
{
}

static mxArray* sRtwOptimizationInfoStruct= NULL;
mxArray* load_Klatt2_optimization_info(void)
{
  if (sRtwOptimizationInfoStruct==NULL) {
    sRtwOptimizationInfoStruct = sf_load_rtw_optimization_info("Klatt2",
      "Klatt2");
    mexMakeArrayPersistent(sRtwOptimizationInfoStruct);
  }

  return(sRtwOptimizationInfoStruct);
}

void unload_Klatt2_optimization_info(void)
{
  if (sRtwOptimizationInfoStruct!=NULL) {
    mxDestroyArray(sRtwOptimizationInfoStruct);
    sRtwOptimizationInfoStruct = NULL;
  }
}
