function [mainParams, details] = SetCalibParams(FactorySettings);

% initialize globals CalibParams and CalibDetails
% first set factory defaults, then look
% for CalibParams.mat file in Setup dir
% for local settings.

% vs 6,  Aug 2001:  equal-width noise bands (except lowest one)

if nargin<1, FactorySettings=0; end;
if length(FactorySettings)==1,
   FactorySettings = [1 1]*FactorySettings;
end

global CalibParams CalibDetails DEFDIRS

% CalibDetails: factory settings
DefaultStartAtt = 30; %dB initial attenuator if not otherwise specified
SAFEMARGIN = 6; % dB safety margin for input/maxInput ratio
MinMargin = 10; % dB minimum margin (=recordedADCinput/max_ADCinput) 
                % justify second try with higher stimulus level
RollOffFreq = 10e3; % Hz, freq above which the transfer function can ...
% ... safely be expected to show a lowpass character
MaxBump = 20; % dB max local increase expected in trf above RollOffFreq 
SPL_LIMIT  = 85; % dB SPL max noise level at ERC calibration time
CalibDetails = CollectInStruct(DefaultStartAtt, ...
   SAFEMARGIN, MinMargin, RollOffFreq, MaxBump,...
   SPL_LIMIT);
% add max bw from CalibParams
CalibDetails.maxNoiseBandWidth = 4000; % Hz max BW of noise bursts

% CalibDetails: local settings override the above factory settings
qqq = getFieldsFromSetupFile([],'CalibDetails',0);
if ~isempty(qqq),
   CalibDetails = combineStruct(CalibDetails,qqq.CalibDetails);
end

% return if asked
if nargout>1, details = CalibDetails; end;


% CalibParams (essential for defining a calib version)
version = 6; % indicates essential procedural changes
minFreq = 50; % Hz  minimum freq used during calibration
burstDur = 200; % ms total duration of noise bursts
rampDur = 20; % ms ramp duration of noise bursts
maxNoiseBandWidth = CalibDetails.maxNoiseBandWidth; % Hz max bandwidth of noise bursts
CalibParams = CollectInStruct(version, minFreq, burstDur, rampDur, maxNoiseBandWidth);
% return if asked
if nargout>0, mainParams = CalibParams; end;




