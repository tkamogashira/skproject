function dllSupported = dsptargetsupportsdll(modelName)
%DSPTARGETSUPPORTSDLL Determines whether the given model's chosen target 
% supports using the dynamic version of the DSP Runtime Library.

% Copyright 1995-2005 The MathWorks, Inc.

dllSupported = false;

if ~ispc
    % currently only have a dynamic version of the library on Windows
    return;
else
    isPrecomp = strcmp(modelName, 'precomplib');
    sysTargetFile = get_param(modelName,'SystemTargetFile');
    
    %current targets supporting the dynamic version of the library:
    
    % Accelerator, Rapid Accelerator
    isAccel = strcmp(sysTargetFile, 'accel.tlc') || ...
              strcmp(sysTargetFile, 'raccel.tlc');
    
    % Model Reference simulation    
    isModelRefSim = strcmp(sysTargetFile, 'modelrefsim.tlc');
    
    % GRT, GRT_MALLOC
    isGRT = strcmp(sysTargetFile, 'grt.tlc') || ...
            strcmp(sysTargetFile, 'grt_malloc.tlc');    
    
    % ERT
    isERT = strcmp(sysTargetFile, 'ert.tlc');    
    
    % RSIM
    isRsim = strcmp(sysTargetFile, 'rsim.tlc');
    
    % RTWSFCN
    isRTWSFcn = strcmp(sysTargetFile, 'rtwsfcn.tlc');
    
    supportedTargets =  isAccel || isModelRefSim || ...
                        isGRT || isERT || ...
                        isRsim || isRTWSFcn;

    % if precompiling, we always want the static version of the library
    dllSupported = supportedTargets && ~isPrecomp;
end

% [EOF] dsptargetsupportsdll.m
