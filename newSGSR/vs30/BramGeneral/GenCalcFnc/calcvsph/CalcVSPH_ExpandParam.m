function Param = CalcVSPH_ExpandParam(ArgIn, Param)

Param.isubseqs = ExpandiSubSeqs(ArgIn, Param.isubseqs); 
if isempty(Param.isubseqs)
    error('Invalid value for property isubseqs.');
end

Param.ireps = ExpandiReps(ArgIn, Param.isubseqs, Param.ireps);
if isempty(Param.ireps)
    error('Invalid value for property ireps.');
end

Param.anwin = ExpandAnWin(ArgIn, Param.anwin);
if isempty(Param.anwin)
    error('Invalid value for property anwin.');
end

if ~isnumeric(Param.minisi) || (length(Param.minisi) ~= 1) || ...
        (Param.minisi < 0)
    error('Invalid value for property minisi.');
end
if ~isnumeric(Param.timesubtr) || (length(Param.timesubtr) ~= 1) || ...
    (Param.timesubtr < 0)
error('Invalid value for property timesubtr.');
end

Param.binfreq = ExpandBinFreq(ArgIn, Param.binfreq, Param.isubseqs);
if isempty(Param.binfreq)
    error('Invalid value for property binfreq.');
end

if ~ischar(Param.intncycles) || ~any(strcmpi(Param.intncycles, {'yes', 'no'}))
    error('Property intncycles must be ''yes'' or ''no''.');
end

if ~isnumeric(Param.raycrit) || (length(Param.raycrit) ~= 1) || ...
        (Param.raycrit <= 0)
    error('Invalid value for property raycrit.');
end
if ~isnumeric(Param.compdelay) || (length(Param.compdelay) ~= 1) || ...
        (Param.compdelay < 0)
    error('Invalid value for property compdelay.');
end
if ~ischar(Param.phaseconv) || ~any(strcmpi(Param.phaseconv, {'lead', 'lag'}))
    error('Property phaseconv must be ''lead'' or ''lag''.');
end
if ~ischar(Param.phaselinreg) || ...
        ~any(strcmpi(Param.phaselinreg, {'normal', 'weighted'}))
    error('Property phaselinreg must be ''normal'' or ''weighted''.');
end

if ~isnumeric(Param.runav) || (length(Param.runav) ~= 1) || ...
        (Param.runav < 0) || (Param.runav > length(Param.isubseqs))
    error('Invalid value for property runav.'); 
end

if ~isnumeric(Param.cutoffthr) || (length(Param.cutoffthr) ~= 1) || ...
        (Param.cutoffthr <= 0), error('Invalid value for property cutoffthr.');
end
