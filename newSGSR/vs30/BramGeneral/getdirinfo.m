function S = getdirinfo(ProjectName)
%GETDIRINFO get directory information.
%   S = GETDIRINFO(ProjectName) If no ProjectName is given, then only general directory information is
%   returned.

%B. Van de Sande 02-07-2003

if nargin > 1, error('Wrong number of input parameters.'); end
if nargin == 0, ProjectName = ''; end

Path = ['C:\USR\' username ];

MFilesDir     = [ Path '\mfiles\' ];
SGSRDataDir   = [ Path '\rawdata\' ];
MadDataDir    = [ Path '\madisondata\' ];
if ~exist(MadDataDir, 'dir')
    MadDataDir = dataDir;
end
MadStimDir    = [ Path '\madisonstim\' ];

%Project specific directory information ...
ProjectDir    = [ MFilesDir ProjectName '\' ];
CalcDataDir   = [ Path '\' ProjectName 'data\' ];

TableFile     = [ ProjectDir ProjectName '.table' ];
IndexFile     = [ ProjectDir ProjectName '.index' ];
ErrorFile     = [ ProjectDir ProjectName '.error' ];

S = CollectInStruct(ProjectDir, CalcDataDir, SGSRDataDir, MadDataDir, ...
    MadStimDir, IndexFile, TableFile, ErrorFile);

