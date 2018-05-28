    function [datasetobj, Param]  = ds2edf(varargin)
    %DS2EDF                 Translate a dataset of type IDF/SPK to EDF format
    %                    
    % 
    % DESCRIPTION
    %                       Translate a dataset of fileformat type IDF/SPK to EDF format
    %                       The current format can be checked by:
    %                       dataset.FileFormat
    %
    % INPUT     
    %        varargin:      First parameter should be a dataset of type IDF/SPK, followed by a struct or array list of type ['parameter', 'value'] containing function options. 
    %                       varargin = ['factory'] || '',  prints the default settings for this function.
    %           
    % OUTPUT
    %        datasetobj:    Translated dataset object
    %        Param:         Struct containing input parameters in struct form, along with altered values.
    %                       
    %
    % EXAMPLES
    %        ds = dataset('S0425', '4-8')
    %        newdataset = ds2edf(ds)
    %
    % SEE ALSO          EDFdataset dataset      getarguments updatestruct
    %                                           printhelp

    %---------------- CHANGELOG -----------------------
    % date          developer       short description
    % 30/11/2010    Abel            Initial creation
	%  Mon Mar 14 2011  Abel   
	%   - bugfix in updatestruct() 
	
    %---------------- Default parameters --------------
    % Define all needed options
    Default = struct();
    Default.version = 0.01;
    Default.maxargs = 2;
    Default.minargs = 1;
    Default.help = {'dsnew = ds2edf(ds)'};

    %---------------------------- Main function ---------------------------
    % Get arguments based on template 
    % - if no arguments or 'factory' just print help message and exit
    if (nargin == 0)
        printhelp(Default, 1);
    elseif strcmpi (varargin{1}, 'factory')
        printhelp(Default, 1);
    end
    
    % First argument should be an IDF/SPK type dataset
    mydataset = varargin{1};
    if ~isa(mydataset, 'dataset') && ~strcmp(mydataset.FileFormat, 'IDF/SPK')
        printhelp(Default, 'First argument should be an IDF/SPK type dataset', 1);
    end
   
    % Get user supplied arguments and set default
    if (nargin > 1)
        Param = getarguments(Default, varargin(2:end));
    else
        Param = Default;
    end
    Param.dataset = mydataset;   
    
    % Render some output warning
    warning('SGSR:Info', 'Transforming dataset to EDF format');
    
    % All iunput is fine, acctual translation of dataset to EDF format
    % - Translate dataset to struct 
    DStruct = struct(Param.dataset);
    % - Get new template struct based on an empty EDFdataset
    %   The original dataset is adapted and saved under EDFdataset.dataset
    EDFStruct = struct(EDFdataset());

    % - Fill in empty struct
    %Only SchName is saved in seperate EDF ID field
    %EDFStruct.ID = updatestruct(Param.dataset.ID, EDFStruct.ID);
    %EDFStruct.ID.FileFormat = 'EDF';
    
    %Don't change filename for userdata
    %EDFStruct.ID.SchName = strcat(DStruct.ID.FileName, '-MODIFIED');
    
    DStruct.ID.FileFormat = 'EDF';
	EDFStruct.Sizes = updatestruct(EDFStruct.Sizes, Param.dataset.Sizes);
    EDFStruct.EDFData = struct('SpikeTimes0', {Param.dataset.Data.SpikeTimes});
    EDFStruct.EDFIndepVar = updatestruct(EDFStruct.EDFIndepVar, Param.dataset.IndepVar);
    if isempty(EDFStruct.SchData)
        EDFStruct.SchData = struct();
        EDFStruct.SchData.NREP = mydataset.nrep;
        EDFStruct.SchData.DsID = mydataset.id.SeqID;
        EDFStruct.SchData.SchName = mydataset.filename;
    end

    % - Adapt original dataset and save 
    DStruct.ID.FileFormat = 'EDF';
    DStruct.Stimulus.StimParam.GWParam.FileName = Param.dataset.FileName;
    DStruct.Stimulus.StimParam.GWParam.ID = Param.dataset.ID.SeqID;
    EDFStruct.dataset = dataset(DStruct, 'convert');

    % - Set ID field and LOG entry to show data is modified 
    %Saved in EDF.dataset
    %EDFStruct.ID.FileName = strcat(DStruct.ID.FileName, '-MODIFIED');
    %Param.LOG = {'transformed to EDF format by ds2edf'};
    %EDFStruct.ID.LOG = Param.LOG;

    %Return Obj
    datasetobj = EDFdataset(EDFStruct, 'convert');
    end

