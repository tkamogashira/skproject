function [CP, details] = calibParams;

% function [CP, details] = calibParams
% returns those current system parameters that define the
% version of a calibration.
% Different calibration data (such as PRB and ERC trfs)
% are compatible only when their calibParams are identical
% CP is a structure containing  the relevant params.
% details is a struct containing params for calibration
% that are not essential for version compatibility.
% see setCalibParams for more details


% global SGSR settings essential for calibration
global SGSR
SampleFreqs = SGSR.samFreqs;
maxSampleRatio = SGSR.maxSampleRatio;
maxDAvalue = SGSR.maxMagDA;
ADC_VoltPerBit = SGSR.ADC_VoltPerBit;
maxFreq = MaxStimFreq;

setCalibParams; % get default calib parameters of this setup from file
global CalibParams CalibDetails;
% update CalibParams
CalibParams.maxNoiseBandWidth = CalibDetails.maxNoiseBandWidth;

CP = CollectInStruct(SampleFreqs, maxSampleRatio, maxDAvalue,...
   ADC_VoltPerBit, maxFreq);
% add non-SGSR essentials (see SetCalibParams)
CP = combineStruct(CP, CalibParams);

if nargout<2, return; end;

% all params from global CalibDetails (see setCalibParams)

details = CalibDetails;

