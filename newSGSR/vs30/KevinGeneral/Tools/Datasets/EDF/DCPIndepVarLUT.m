function ArgOut = DCPIndepVarLUT(varargin)
%LUT      = DCPIndepVarLUT
%LUTentry = DCPIndepVarLUT(DCPVarName)

%B. Van de Sande 09-07-2004

persistent LUT; if isempty(LUT), LUT = generateLUT; end

if nargin == 0, ArgOut = LUT; return; %Return completed LookUp Table ...
elseif nargin == 1, %Return only one entry ...
    DCPName = varargin{1};

    DCPNames = { LUT.DCPName };
    idx = find(strcmp(DCPNames, DCPName));

    if ~isempty(idx), ArgOut = LUT(idx);
    else, 
        warning(sprintf('%s is not a known name of an independent variable. Assuming same name for schema entry.', DCPName));
        
        FNames   = fieldnames(LUT)'; 
        NFields  = length(FNames); 
        Args     = vectorzip(FNames, repmat({'??'}, 1, NFields));
        LUTentry = struct(Args{:});
        [LUTentry.DCPName, LUTentry.Name, LUTentry.ShortName] = deal(DCPName);
        idx = find(strncmp(FNames, 'SCH', 3) | strcmp(FNames, 'CALIB'));
        for n = idx, LUTentry = setfield(LUTentry, FNames{n}, DCPName); end
        
        ArgOut = LUTentry;
    end
else, error('Invalid syntax.'); end

%---------------------------------------------local functions-------------------------------------------------
function LUT = generateLUT

LUT(1).DCPName   = 'freq';
LUT(1).Name      = 'Tone frequency';
LUT(1).ShortName = 'Ftone';
LUT(1).Unit      = 'Hz';
LUT(1).PlotScale = 'linear';
LUT(1).SCH006    = 'FREQ';
LUT(1).SCH008    = '';
LUT(1).SCH012    = 'FREQ';
LUT(1).SCH016    = 'FREQ';

LUT(2).DCPName   = 'spl';
LUT(2).Name      = 'Intensity';
LUT(2).ShortName = 'Level';
LUT(2).Unit      = 'dB SPL';
LUT(2).PlotScale = 'linear';
LUT(2).SCH006    = 'SPL';
LUT(2).SCH008    = '';
LUT(2).SCH012    = 'SPL';
LUT(2).SCH016    = 'SPL';

%Attention! The schema variable DELM designates the initial delay before the stimulus is
%presented. It's meaning is monaural and can be set independently for each playback channel
%in binaural settings. Do not confuse with ITD which is a binaural parameter.
LUT(3).DCPName   = 'delay';
LUT(3).Name      = 'Initial delay';
LUT(3).ShortName = 'ID';
LUT(3).Unit      = '\mus';
LUT(3).PlotScale = 'linear';
LUT(3).SCH006    = 'DELM';
LUT(3).SCH008    = 'DELM';
LUT(3).SCH012    = 'DELM';
LUT(3).SCH016    = 'DELM';

LUT(4).DCPName   = 'phase';
LUT(4).Name      = 'Initial phase of tone\carrier frequency';
LUT(4).ShortName = 'Phase';
LUT(4).Unit      = 'cycles';
LUT(4).PlotScale = 'linear';
LUT(4).SCH006    = 'PHASE';
LUT(4).SCH008    = 'PHASE';
LUT(4).SCH012    = 'PHASE';
LUT(4).SCH016    = 'PHASE';

LUT(5).DCPName   = 'fcarr';
LUT(5).Name      = 'Carrier frequency';
LUT(5).ShortName = 'Fcarr';
LUT(5).Unit      = 'Hz';
LUT(5).PlotScale = 'linear';
LUT(5).SCH006    = 'FREQ';
LUT(5).SCH008    = '';
LUT(5).SCH012    = 'FREQ';
LUT(5).SCH016    = 'FREQ';

LUT(6).DCPName   = 'fmod';
LUT(6).Name      = 'Modulation frequency';
LUT(6).ShortName = 'Fmod';
LUT(6).Unit      = 'Hz';
LUT(6).PlotScale = 'linear';
LUT(6).SCH006    = 'FMOD';
LUT(6).SCH008    = 'FMOD';
LUT(6).SCH012    = 'FMOD';
LUT(6).SCH016    = '';

LUT(7).DCPName   = 'phasm';
LUT(7).Name      = 'Initial phase of modulation frequency';
LUT(7).ShortName = 'Pmod';
LUT(7).Unit      = 'Hz';
LUT(7).PlotScale = 'linear';
LUT(7).SCH006    = 'PHASM';
LUT(7).SCH008    = 'PHASM';
LUT(7).SCH012    = 'PHASM';
LUT(7).SCH016    = '';

LUT(8).DCPName   = 'dmod';
LUT(8).Name      = 'Depth of modulation';
LUT(8).ShortName = 'Dmod';
LUT(8).Unit      = '0-1';
LUT(8).PlotScale = 'linear';
LUT(8).SCH006    = 'DMOD';
LUT(8).SCH008    = 'DMOD';
LUT(8).SCH012    = 'DMOD';
LUT(8).SCH016    = '';

LUT(9).DCPName   = 'tonlvl';
LUT(9).Name      = 'Tone level for Masking Stimulus paradigm';
LUT(9).ShortName = 'MSKTlvl';
LUT(9).Unit      = 'dB';
LUT(9).PlotScale = 'linear';
LUT(9).SCH006    = 'TONLVL';
LUT(9).SCH008    = 'TONLVL';
LUT(9).SCH012    = 'TONLVL';
LUT(9).SCH016    = '';

LUT(10).DCPName   = 'gwlvl';
LUT(10).Name      = 'GW level for Masking Stimulus paradigm';
LUT(10).ShortName = 'MSKGWlvl';
LUT(10).Unit      = 'dB';
LUT(10).PlotScale = 'linear';
LUT(10).SCH006    = 'GWLVL';
LUT(10).SCH008    = 'GWLVL';
LUT(10).SCH012    = 'GWLVL';
LUT(10).SCH016    = '';

LUT(11).DCPName   = 'delay2';
LUT(11).Name      = 'Masking stimulus delay';
LUT(11).ShortName = 'MSKdelay';
LUT(11).Unit      = '\mus';
LUT(11).PlotScale = 'linear';
LUT(11).SCH006    = 'DELAY2';
LUT(11).SCH008    = 'DELAY2';
LUT(11).SCH012    = 'DELAY2';
LUT(11).SCH016    = 'DELAY2';

LUT(12).DCPName   = 'dur2';
LUT(12).Name      = 'Masking stimulus duration';
LUT(12).ShortName = 'NSKdur';
LUT(12).Unit      = 'ms';
LUT(12).PlotScale = 'linear';
LUT(12).SCH006    = 'DUR2';
LUT(12).SCH008    = 'DUR2';
LUT(12).SCH012    = 'DUR2';
LUT(12).SCH016    = 'DUR2';

LUT(13).DCPName   = 'repint';
LUT(13).Name      = 'Repetition interval';
LUT(13).ShortName = 'RepDur';
LUT(13).Unit      = 'ms';
LUT(13).PlotScale = 'linear';
LUT(13).SCH006    = 'REPINT';
LUT(13).SCH008    = 'REPINT';
LUT(13).SCH012    = 'REPINT';
LUT(13).SCH016    = 'REPINT';

LUT(14).DCPName   = 'stmdur';
LUT(14).Name      = 'Stimulus duration';
LUT(14).ShortName = 'BurstDur';
LUT(14).Unit      = 'ms';
LUT(14).PlotScale = 'linear';
LUT(14).SCH006    = 'DUR1';
LUT(14).SCH008    = 'DUR1';
LUT(14).SCH012    = 'DUR1';
LUT(14).SCH016    = 'DUR1';

LUT(15).DCPName   = 'rtime';
LUT(15).Name      = 'Rise time';
LUT(15).ShortName = 'RiseDur';
LUT(15).Unit      = 'ms';
LUT(15).PlotScale = 'linear';
LUT(15).SCH006    = 'RTIME';
LUT(15).SCH008    = 'RTIME';
LUT(15).SCH012    = 'RTIME';
LUT(15).SCH016    = 'RTIME';

LUT(16).DCPName   = 'ftime';
LUT(16).Name      = 'Fall time';
LUT(16).ShortName = 'FallDur';
LUT(16).Unit      = 'ms';
LUT(16).PlotScale = 'linear';
LUT(16).SCH006    = 'FTIME';
LUT(16).SCH008    = 'FTIME';
LUT(16).SCH012    = 'FTIME';
LUT(16).SCH016    = 'FTIME';

LUT(17).DCPName   = 'gwres';
LUT(17).Name      = 'GW playback resolution';
LUT(17).ShortName = 'GWres';
LUT(17).Unit      = 'ms';
LUT(17).PlotScale = 'linear';
LUT(17).SCH006    = 'GWRES';
LUT(17).SCH008    = 'GWRES';
LUT(17).SCH012    = 'GWRES';
LUT(17).SCH016    = 'GWRES';

LUT(18).DCPName   = 'dsnum';
LUT(18).Name      = 'GW dataset number';
LUT(18).ShortName = 'DSnr';
LUT(18).Unit      = '#';
LUT(18).PlotScale = 'linear';
LUT(18).SCH006    = 'GWDS';
LUT(18).SCH008    = 'GWDS';
LUT(18).SCH012    = 'GWDS';
LUT(18).SCH016    = '';

LUT(19).DCPName   = 'itrate';
LUT(19).Name      = 'ITD rate for shifted GEWAB';
LUT(19).ShortName = 'ITDrate';
LUT(19).Unit      = '\mus/s';
LUT(19).PlotScale = 'linear';
LUT(19).SCH006    = '';
LUT(19).SCH008    = '';
LUT(19).SCH012    = 'ITDRATE';
LUT(19).SCH016    = '';

LUT(20).DCPName   = 'itd1';
LUT(20).Name      = 'Initial ITD for shifted GEWAB';
LUT(20).ShortName = 'InitITD';
LUT(20).Unit      = '\mus';
LUT(20).PlotScale = 'linear';
LUT(20).SCH006    = '';
LUT(20).SCH008    = '';
LUT(20).SCH012    = 'ITD1';
LUT(20).SCH016    = '';

LUT(21).DCPName   = 'itd2';
LUT(21).Name      = 'Final ITD for shifted GEWAB';
LUT(21).ShortName = 'FinalITD';
LUT(21).Unit      = '\mus';
LUT(21).PlotScale = 'linear';
LUT(21).SCH006    = '';
LUT(21).SCH008    = '';
LUT(21).SCH012    = 'ITD2';
LUT(21).SCH016    = '';

LUT(22).DCPName   = 'elevtn';
LUT(22).Name      = 'Elevation for VS';
LUT(22).ShortName = 'Elevation';
LUT(22).Unit      = 'deg';
LUT(22).PlotScale = 'linear';
LUT(22).SCH006    = '';
LUT(22).SCH008    = '';
LUT(22).SCH012    = 'ELEVTN';
LUT(22).SCH016    = '';

LUT(23).DCPName   = 'azimth';
LUT(23).Name      = 'Azimuth for VS';
LUT(23).ShortName = 'Azimuth';
LUT(23).Unit      = 'deg';
LUT(23).PlotScale = 'linear';
LUT(23).SCH006    = '';
LUT(23).SCH008    = '';
LUT(23).SCH012    = 'AZIMTH';
LUT(23).SCH016    = '';

LUT(24).DCPName   = 'none';
LUT(24).Name      = 'None (do not vary)';
LUT(24).ShortName = 'None';
LUT(24).Unit      = '';
LUT(24).PlotScale = 'linear';
LUT(24).SCH006    = '';
LUT(24).SCH008    = '';
LUT(24).SCH012    = '';
LUT(24).SCH016    = '';