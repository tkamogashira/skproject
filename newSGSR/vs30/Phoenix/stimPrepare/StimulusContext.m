function c = StimulusContext(resetRandState);
% StimulusContext - contextual information relevant for stimulus generation
%   C = StimulusContext returns a struct C whose fields contain various
%   types of information that is not a part of the stimulus definition,
%   but that still affects stimulus generation.
%   Together, the stimulus parameters and stimulus context uniquely define
%   the stimulus.
%
%   The fields of C are:
%     experiment: info on the experiment as returned by ExperimentInfo
%     calibration: current calibration data
%     now: time/date as returned by datestr(Now)
%     location: location string as returned by Here and Compuname
%     randomSeed: random seed as returned by setRandState('current')
%     settings: hardware and software settings (e.g. set of sample frequencies)
%     version: version of the software
%     
%   StimulusContext(1) refreshes the random generator by calling setRandState() 
%   before retrieving the randomseed.

if nargin<1, resetRandState=0; end
if resetRandState, setRandState; end % fresh rand seed based on system clock

% temporary use of globals as source of local settings and calibration params 
global CALIB SGSR
SGSR.system = TDTsystem;
ccal = CALIB;
% strip bulky transfer data from calib 
[ccal.ERC.TRF] = deal([]);

c.experiment = experiment('current');
c.calibration = ccal;
c.now = datestr(now);
c.location = [here '/' compuname];
c.randomSeed = setRandState('current');
c.systemParameters = SGSR; 
c.version = CurrentVersion;

%Exp: 
%- name
%- experimenter
%- neural structure
%- recording side
%- started at (time)
%- last modified at (time)

%Settings:
%- TDT sys2 or sys3
%- sample freqs
%- maxmagDA
%- various system parameters

%also ask Bram about EDF










