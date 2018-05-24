% TDT2EARLY - how to do TDT things using the EARLY toolbox
%    Here is a list of TDT ActiveX functions together with the 
%    EARLY function that handles the same functionality.
%    Type HELP SYS3BASICS  for an overview of the TDT stuff in EARLY.
%
%      TDT          EARLY           See also
% -----------------------------------------------------
%  ClearCOF         sys3loadCircuit
%  ConnectXXX       sys3dev          sys3deviceList, sys3reset
%  GetCycleUsage    sys3status       sys3circuitInfo
%  GetDevCfg        -                -
%  GetNumOf         sys3circuitInfo  sys3loadCircuit, sys3partag
%  GetNameOf        sys3circuitInfo  sys3loadCircuit, sys3partag
%  GetSFreq         sys3fsam         sys3loadCircuit
%  GetStatus        sys3status
%  GetTagType       sys3ParTag       sys3CircuitInfo
%  GetTagVal        sys3getPar       sys3ParTag, sys3CircuitInfo
%  GetTagSize       sys3partag
%  Halt             sys3halt
%  LoadCOF          sys3loadCircuit
%  LoadCOFsf        sys3loadCircuit  sys3fsam
%  ReadTag          sys3read         sys3partag
%  ReadTagV         sys3read         sys3partag
%  ReadTagVEX       sys3read         sys3partag
%  Run              sys3run
%  SendParTable     -
%  SendSrcFile      -
%  SetTagVal        sys3setPar       sys3ParTag
%  SetDevCfg        -
%  SoftTrg          sys3trig
%  WriteTag         sys3write
%  WriteTagV        sys3write
%  WriteTagVEX      sys3write
%  ZeroTag          sys3write
%                                             .
%  ConnectPA5       sys3dev          sys3deviceList, sys3reset
%  Display          -
%  GetError         -
%  GetAtten         -
%  Reset            -
%  Setatten         sys3PA5
%  SetUser          -
%                                             .
%  ConnectZBUS      sys3dev          sys3reset
%  FlushIO          -
%  GetDeviceAddr    -
%  GetDeviceVersion -
%  GetError         -
%  HardwareReset    -                sys3hardswarereset, sys3reset
%  zBusTrigA        -
%  zBusTrigB        -
%  zBusSync         -



