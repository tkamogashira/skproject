function EvalCALIB(ds, varargin)
%EVALCALIB  evaluate EDF calibration dataset.
%   EVALCALIB(ds) plots the calibration magnitude and phase curve for
%   the specified dataset. This dataset should be extracted from an EDF
%   datafile and should contain calibration data, i.e. its shema type 
%   should be 'CALIB'.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 22-04-2004

%Default parameters ...
DefParam.plot  = 'yes'; %'yes' or 'no' ...
DefParam.nharm = 1;     %harmonic number ...

%Evaluate input arguments ...
if (nargin == 1) & ischar(ds) & strcmpi(ds, 'factory'),
    disp('Properties and their factory defaults:')
    disp(DefParam);
    return;
elseif ~isa(ds, 'dataset') | ~strcmpi(ds.ID.FileFormat, 'EDF') | ...
        ~strcmpi(ds.SchData.SchName, 'CALIB'), 
    error('First argument should be an EDF dataset containing calibration data.');
end
Param = CheckPropList(DefParam, varargin{:});
if ~ischar(Param.plot) | ~any(strcmpi(Param.plot, {'yes', 'no'})),
    error('Property plot should be ''yes'' or ''no''.');
end
if ~isnumeric(Param.nharm) | (length(Param.nharm) ~= 1) | (Param.nharm < 0) | (Param.nharm > ds.Stimulus.StimParam.Nharm),
    error('Invalid value for property nharm.');
end

if strcmpi(Param.plot, 'yes'),
    FigHdl = figure('Name', sprintf('%s: %s <%s>', upper(mfilename), ds.ID.FileName, ds.ID.SeqID), ...
        'NumberTitle','off', ...
        'Units', 'normalized', ...
        'PaperOrientation', 'landscape');
    
    MagnHdl = axes('Position', [0.10 0.55 0.80 0.35]);
    line(ds.indepval, ds.Data.OtherData.calibCurve.magnitude(Param.nharm, :), 'LineStyle', '-', 'Color', 'b', 'Marker', 'none');
    title('Magnitude', 'FontSize', 12);
    xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
    
    PhHdl = axes('Position', [0.10 0.10 0.80 0.35]);
    line(ds.indepval, ds.Data.OtherData.calibCurve.phase(Param.nharm, :), 'LineStyle', '-', 'Color', 'b', 'Marker', 'none');
    title('Phase', 'FontSize', 12);
    xlabel('Frequency (Hz)'); ylabel('Phase (rad)');
end