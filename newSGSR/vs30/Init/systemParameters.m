function systemParameters(FactorySettings)

% SystemParameters - initialization of global SGSR struct XXX
% This structure contains all system-dependent settings
% and parameters.
% XXX addresses of xbdrv devices
% XXX clock ratio should be measured systematically at startup

global SGSR;

if nargin>0
    warning('obsolete usage of systemParameters - does not take args anymore');
end

% delete previous versions
SGSR = [];

SGSR.version = str2double(CurrentVersion);
% version number for IDF and SPK files
SGSR.IDF_SPKversion = 9 + SGSR.version;
SGSR.TDTpresent = 1; % assume that TDT hardware is present
% available set of sample frequencies in Hz, or more precisely,
% The sample frequencies that define the choice of
% anti-imaging filters. IN ASCENDING ORDER!
% ----------SGSR.samFreqs = 1e3*[20 50 125]; 
SGSR.samFreqs = 1e3*[50 125]; 
try
    if inLeuven && isequal('sys3', TDTsystem),
        SGSR.samFreqs = [12207.03125000 24414.06250000 48828.12500000 97656.25000000];
    end
catch e %#ok<NASGU>
    %NO-OP;
end

SGSR.samFreqUnit = 'Hz';
% max stimulus-freq/sample-freq ratio considered safe
SGSR.maxSampleRatio = 0.8/2;
SGSR.maxSampleRatioUnit = '';
% duration in ms of switch buffer that precedes each subsequence.
% Should be long enough to allow SS1 switching, etc
SGSR.switchDur = 80;
SGSR.switchDurUnit = 'ms';
% maximum attenuation in dB of analog attenuators
SGSR.maxAtten = 99.9;
SGSR.maxAttenUnit = 'dB';
% minimum bit range considered meaningfull for D/A conversion
SGSR.minMagDA = 1;
SGSR.minMagDAUnit = 'bit';
% maximum magnitude of samples sent to the D/A converter
SGSR.maxMagDA = 32000; % see PD1 manual
SGSR.maxMagDAUnit = '';
% preferred fraction of max D/A range used (to avoid distortion)
SGSR.prefDAfraction = 0.3;
SGSR.prefDAfractionUnit = '';
% conversion factor (bit value at ADC) -> (Voltage at ADC)
SGSR.ADC_VoltPerBit  = 10/2^15; % 16 bit ADC; 10 V min/max
% TTL-pulse  amplitude in D/A converter units
SGSR.TTLamplitude = 0.6*SGSR.maxMagDA;
SGSR.TTLamplitudeUnit = '';
% TTL-pulse  width in samples
SGSR.TTLwidth = 8;
SGSR.TTLwidthUnit = 'samples';
% ratio of ET1 and PD1 clocks
SGSR.ClockRatio = 1-0.7/9000 + 13e-3/9000; % (PD1 clock rate)/(ET1 clock rate) Note is measured by et1calibrate, not set fixed
SGSR.ClockRatioUnit = ''; % 
% maximum interval in minutes after which the ET1 has to be calibrated again
SGSR.ET1calibrateInterval = 8;
SGSR.ET1calibrateIntervalUnit = 'minute';
% default calibration estimate,i.e., SPL when unattenuated
SGSR.defaultMaxSPL = 130; % dB SPL assumed when playing @ max
% duration in ms of the calibration ET1 calibration pulse train
SGSR.ET1calibDur = 1000;
SGSR.ET1calibDurUnit = 'ms';
% ADC channel used for calibration
SGSR.ADCchannel = 1;

% this should be moved to wiring and device ID-ing XXX
% connection of anti-aliasing filters - see PlayIt
SGSR.SS1_1 = [1 2 2]; % means: to use the nth filter, the ...
%  appropriate dual switch of SS1_1 be set to SS1_1(n), etc
SGSR.SS1_2 = [0 1 2]; % idem for SS1_2
