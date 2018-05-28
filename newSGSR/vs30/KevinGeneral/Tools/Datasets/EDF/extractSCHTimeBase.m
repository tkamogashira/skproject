function TimeBase = extractSCHTimeBase(SchData, DSSParam)

%B. Van de Sande 09-07-2004
%This parameter can only be extracted from datasets with schemata sch006, sch012 and sch016 ...

if ~any(strcmp(SchData.SchName, {'sch006', 'sch012', 'sch016'})), TimeBase = []; return; end

if isfield(SchData, 'TBASE') & (SchData.TBASE) > 0 & (SchData.TBASE < 1e6),
    %TBASE is scale for seconds, but spiketimes will be archived in milliseconds ...
    TimeBase = SchData.TBASE * 1000; 
else
    %If not suplied directly as a variable in the dataset schema, then the timebase can be derived from the time
    %settings of the stimulus ... But the TBASE-table provided in the RA documentation isn't the only table that
    %is taken into consideration because new timers have been installed. However, for the data collected by Philip
    %Joris the following table might suffice.
    
    warning('Invalid TBASE setting for this dataset. Using a time base for the spiketimes derived from timer settings.');
    
    GenStimParam = extractSCHGenStimParam(SchData, DSSParam);
    TimeDur = max([GenStimParam.RepDur, GenStimParam.Delay/1000]);
    
    if     TimeDur > 0        & TimeDur <= 64,        TimeBase = 0.001;
    elseif TimeDur > 64       & TimeDur <= 640,       TimeBase = 0.01;
    elseif TimeDur > 640      & TimeDur <= 6400,      TimeBase = 0.1;
    elseif TimeDur > 6400     & TimeDur <= 64000,     TimeBase = 1;
    elseif TimeDur > 64000    & TimeDur <= 640000,    TimeBase = 10;
    elseif TimeDur > 640000   & TimeDur <= 6400000,   TimeBase = 100;
    elseif TimeDur > 6400000  & TimeDur <= 64000000,  TimeBase = 1000;
    elseif TimeDur > 64000000 & TimeDur <= 640000000, TimeBase = 10000;   
    else TimeBase = []; end
end