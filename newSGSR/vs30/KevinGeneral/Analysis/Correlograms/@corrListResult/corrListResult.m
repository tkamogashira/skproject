function CLR = corrListResult(varargin)
% CORRLISTRESULT  Constructor for corrListResult objects
%
% A corrListResult object contains correlograms, calculated by another
% function. For example, the method ''calcCorr'' from the class
% ''corrListObject'' returns a ''corrListResult'' object.
%
% CLR = corrListResult(varargin)
%  Creates a corrListResult instance, containing a set of correlograms,
%  and various information.
%
% Arguments:
%  As usual, the arguments are given in a ('paramName', paramValue) list.
%
%  Possible parameters are:
%   corrFcns: Obligatory. A one, two or three dimensional array of
%             correlograms. The dimension depends on the type of
%             calculation that was done in the function that generated the
%             corrListResult object.  
%    corrLag: Obligatory. Array of numeric values, of the same dimensions
%             as corrFcns. They are the lags belonging to the correlograms
%             in corrFcns. 
%   corrType: Obligatory. The type of the correlograms: 'sum', 'dif' or
%             simply 'cor'. This usually is a multidimensional cell array,
%             because different correlograms can have different corrTypes.
%             This is not checked though, and the programmer should keep
%             track of this.
%   calcType: Obligatory. The type of the calculations done in the function
%             that generated the corrListResult object.  
%     refRow: Obligatory if calcType is 'refRow'.
%      delta: Obligatory if calcType is 'deltaDiscern'
%        THR: A struct with fields CF, SR, THRmin, BW and QFactor, as
%             present in the userdata.
%         DF: The calculated dominant frequency of the correlograms,
%             contained in an array.
%
% Example:
%  Take a look at the way the method calcCorr of the class corrListObject
%  creates a corrListResult object.


%% Handle parameters
% Create struct
defParams.CLO             = [];
defParams.corrFncs        = [];
defParams.corrLag         = [];
defParams.corrType        = [];
defParams.calcType        = '';
defParams.refRow          = 0;
defParams.delta           = 0;
defParams.THR.CF          = 0;
defParams.THR.SR          = 0;
defParams.THR.THRmin      = 0; %
defParams.THR.BW          = 0;
defParams.THR.Qfactor     = 0;
defParams.DF              = [];
params = processParams(varargin, defParams);

CLR.CLO         = params.CLO;
CLR.corrLag     = params.corrLag;
CLR.corrFncs    = params.corrFncs;
CLR.corrType    = params.corrType;
CLR.calcType    = params.calcType;
CLR.refRow      = params.refRow;
CLR.THR         = params.THR;
CLR.DF          = params.DF;
CLR.delta       = params.delta;

list = getList(CLR.CLO);

% check format of arguments
if ~isequal('corrlistobject', lower(class(CLR.CLO)))
    error('Wrong format of the arguments.');
end
if isempty(CLR.corrLag) | isempty(CLR.corrFncs)
    error('Wrong format of the arguments.');
end
if ~iscell(CLR.corrLag) | ~iscell(CLR.corrFncs) %#ok<OR2>
    error('Wrong format of the arguments.');
end
if ~isequal(size(CLR.corrLag), size(CLR.corrFncs)) %#ok<OR2>
    error('Wrong format of the arguments.');
end
resultDims = ndims(CLR.corrLag);
if ~isequal(2, resultDims)
    error('Wrong format of arguments.');
end

switch lower(CLR.calcType)
    case {'refrow', 'within'}
        if ~isstruct(CLR.THR)
            error('Wrong format of the arguments.');
        end
        for i=1:size(CLR.corrLag,1)
            if ~isequal( 'double', class(CLR.corrLag{i}) ) | ~isequal( 'double', class(CLR.corrFncs{i}) )  %#ok<OR2>
                error('Wrong format of the arguments.');
            end
            if ~isequal( 2, ndims(CLR.corrLag{i}) ) | ~isequal( 1, size(CLR.corrLag{i},1) ) | ~isequal(size(CLR.corrLag{i}), size(CLR.corrFncs{i})) %#ok<OR2>
                error('Wrong format of the arguments.');
            end
            if ~isnumeric(CLR.DF(i))  | ~isscalar(CLR.DF(i))%#ok<OR2>
                error('Wrong format of the arguments.');
            end
        end
    case {'all', 'deltadiscern'}
        if ~isstruct(CLR.THR)
            error('Wrong format of the arguments.');
        end
        for i=1:size(CLR.corrLag,1)
            for j=1:size(CLR.corrLag,2)
                if ~isequal( 'double', class(CLR.corrLag{i,j}) ) | ~isequal( 'double', class(CLR.corrFncs{i,j}) )  %#ok<OR2>
                    error('Wrong format of the arguments.');
                end
                if ~isequal(size(CLR.corrLag{i,j}), size(CLR.corrFncs{i,j})) | ...
                        ( ~isempty(CLR.corrLag{i,j}) & ( ~isequal( 2, ndims(CLR.corrLag{i,j}) ) ...
                                                         | ~isequal( 1, size(CLR.corrLag{i,j},1) ) ...
                                                        )...
                         )%#ok<OR2>
                    error('Wrong format of the arguments.');
                end
                if ~isnumeric(CLR.DF(i,j))  | ~isscalar(CLR.DF(i,j))%#ok<OR2>
                    error('Wrong format of the arguments.');
                end
            end
        end
    otherwise
        error('Wrong format of the arguments.');
end

if ~ismember(lower(CLR.corrType), {'dif';'sac';'xac';'scc';'xcc';'sum'}) | ~ismember({lower(CLR.calcType)}, {'within';'refrow'; 'all'; 'deltadiscern'}) %#ok<OR2>
    error('Wrong format of arguments.');
end

listLength = length(list);
switch lower(CLR.calcType)
    case 'refrow'
        if ~ismember(CLR.refRow, 1:listLength)
            error('Wrong format of arguments.');
        end
        for row=1:listLength
            CLR.ds1(row) = list(CLR.refRow);
            CLR.ds2(row) = list(row);
        end
    case {'all', 'deltadiscern'}
        for row = 1:listLength
            for col = 1:listLength
                CLR.ds1(row,col) = list(row);
                CLR.ds2(row,col) = list(col);
            end
        end
    case 'within'
        for row = 1:listLength
            CLR.ds1(row) = list(row);
            CLR.ds2(row) = list(row);
        end
end

%% Construct class
CLR = class(CLR, 'corrListResult');