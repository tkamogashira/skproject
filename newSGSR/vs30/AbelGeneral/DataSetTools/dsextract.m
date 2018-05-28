function [datasetobj, Param]  = dsextract(varargin)
%DSEXTRACT          Extract a data subset from a given dataset object
%                    
% 
% DESCRIPTION
%                 Extract a data subset from a given dataset object. The
%                 database object containing the extracted data is
%                 returned. 
%                 
% INPUT     
%        varargin:          First parameter should be a dataset of type EDF, followed by a struct or array list of type ['parameter', 'value'] containing function options. 
%                           varargin = ['factory'] || '',  prints the default settings for this function.
%        varargin(1):       EDFdataset
%        varargin(2:end)    Struct or parameter list containing options:
%                           'repetitionrange'       [array list of repetitions to extract] 
%
% OUTPUT
%        datasetobj:        Dataset object with extracted data
%        Param:             Sturct with updated parameter list
%
% EXAMPLES
%       ds = dataset('S91110', '3-11-rccl')
%       ds = dsextract(ds, 'repetitionrange', [1:4]);
%
% SEE ALSO EDFdataset dataset 

%---------------- CHANGELOG -----------------------
% date          developer       short description
% 30/11/2010    Abel            Initial creation


%---------------------------- Config Defaults ---------------------------- 
% Define all needed options
Defaults = struct();
Defaults.version = 0.01;
Defaults.maxargs = 4;
Defaults.minargs = 3;
Defaults.repetitionrange = [];
Defaults.subtractsoptions = { 'repetitionrange' };
Defaults.help = { 'dsextract( datasetobj, Param )' };

%---------------------------- Main function -------------------------------
% Get arguments based on template 
% - if no arguments or 'factory' just print help message and exit
if nargin == 0 || strcmpi(varargin{1}, 'factory')
    printhelp(Defaults);
  return
end


% First argument should be a dataset
mydataset = varargin{1};
if ~isa(mydataset, 'dataset')
    printhelp(Default, 'First argument should be a dataset', 1);
end

% - Get user supplied arguments and set Defaults 
Param = getarguments(Defaults, varargin(2:end));

% - Get what to extract
for n=1:length(Param.subtractsoptions)
    if ~isempty(Param.(Param.subtractsoptions{n}))
        toDo = Param.subtractsoptions{n};
    end
end

% - Start extraction subroutine
switch toDo;
case 'repetitionrange'
    [datasetobj, Param] = extractrepetitions_(mydataset, Param);
end
end

%---------------------------- Local Functions ----------------------------
%FUNCT: extract repetition range from datasetobj
function [datasetobj, Param] = extractrepetitions_(mydataset, Param)

% Get dataformat
isEDF = strcmp(mydataset.fileformat, 'EDF');
isIDF = strcmp(mydataset.fileformat, 'IDF/SPK');

% Set LOG entry
Param.LOG = {'Extracted repetition range:', Param.repetitionrange};

% Transfer datasetobj to struct and set NREP at specific places
% - Only for EDF data:
if isEDF;
    % Get EDF extra struct 
    EDFStruct = struct(mydataset);
    % Extract general struct from EDF struct
    DStruct = struct(mydataset.dataset);
    % Set NREP at specific EDF places
    EDFStruct.SchData.NREPMD = length(Param.repetitionrange);
    % Set ID field and LOG entry to show data is modified 
    % Only SchName is saved in EDFStruct, others in DStruct
    
    %Don't change filename for userdata
    %EDFStruct.ID.SchName = strcat( EDFStruct.ID.SchName, '-MODIFIED');
    %EDFStruct.SchData.SchName = strcat( EDFStruct.SchData.SchName, '-MODIFIED');
    
    
    %EDFStruct.ID.FileName = strcat(DStruct.ID.FileName, '-MODIFIED');
    %EDFStruct.ID.LOG = Param.LOG;
% - For standard datasettype
elseif isIDF;
    DStruct = struct(mydataset);
else
    printhelp(Param, 'datasetobj type not recognized', 1);
end
% - For all datasets 
DStruct.Sizes.Nrep = length(Param.repetitionrange);

% Set ID field and LOG entry to show data is modified

%Don't change filename for userdata
%DStruct.ID.FileName = strcat(DStruct.ID.FileName, '-MODIFIED');
DStruct.ID.LOG = Param.LOG;

% Extract spiketimes and save only wanted data
data = DStruct.Data.SpikeTimes;
newdata = cell(size(data,1), length(Param.repetitionrange));
for row=1:size(data, 1);   
    newcol = 1;
    for col=Param.repetitionrange
        newdata(row, newcol) = data(row,col);
        newcol = newcol + 1;
    end
end
% - For EDF data
if isEDF && isfield(EDFStruct.EDFData, 'SpikeTimes0');
    EDFStruct.EDFData.SpikeTimes0 = newdata;
end
% - For all others
DStruct.Data.SpikeTimes = newdata;

% Rebuild datasetobj object 
% - For EDF data
if isEDF;
    EDFStruct.dataset = dataset(DStruct, 'convert');
    datasetobj = EDFdataset(EDFStruct, 'convert');
else
% - For others 
    datasetobj = dataset(DStruct, 'convert');
end
end


