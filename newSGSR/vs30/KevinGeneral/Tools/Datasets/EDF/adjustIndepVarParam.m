function [IndepVarParam, Err] = adjustIndepVarParam(IndepVarParam, GenStimParam, DSSParam);

%B. Van de Sande 09-07-2004

Err = 0;

%For binaural datasets with delay as one of the independent variables, this independent
%variable is translated. Delay is a monaural stimulus parameter and for binaural datasets
%the interaural delay is more meaningful. The ITD (Interaural Time Delay) is calculated
%from the initial delay from both playback channels by subtracting the initial delay of
%the master DSS from the initial delay of the slave DSS.
idx = find(strcmpi({IndepVarParam.DCPName}, 'delay')); NrDSS = DSSParam.Nr;
if ~isempty(idx) & (NrDSS == 2),
    IndepVarParam(idx).Name      = 'Inter-aural delay';
    IndepVarParam(idx).ShortName = 'ITD';
    IndepVarParam(idx).DCPName   = '';
    IndepVarParam(idx).DSS       = 'both';
    IndepVarParam(idx).DSSidx    = NaN;
    IndepVarParam(idx).SCHName   = struct([]);
    IndepVarParam(idx).Values    = diff(GenStimParam.Delay, 1, 2);
end