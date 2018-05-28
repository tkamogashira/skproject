function [DefaultStruct] = updatestruct(DefaultStruct, UpdateStruct, varargin)
%UPDATESTRUCT     Update/fill in structure based on the values from a second structure.
%
%
% DESCRIPTION
%                 Update/fill in structure based on the values from a
%                 second structure. The supplied UpdateStruct can have fields not
%                 present in the struct to be updated (DefaultStruct). If a fieldname isn't
%                 present in the UpdateStruct, the value from DefaultStruct
%                 will be kept.
%
% INPUT
%        DefaultStruct: The default struct to be updated
%        UpdateStruct:  Struct with the values
%		 Additionanl options:
%         'skipnontemplate', [false]       % Skip struct fields which are
%                                          % not in the template.
%
% OUTPUT
%        DefaultStruct:  Updated structure
%
% EXAMPLES
%        DefaultStruct.testvalue = 1;
%        UpdateStruct.testvalue2 = 0;
%        UpdateStruct.testvalue = 0;
%        updatestruct(DefaultStruct, UpdateStruct)
%
% SEE ALSO          struct

%---------------- CHANGELOG -----------------------
% date          developer       short description
% 02/12/2010    Abel            Initial creation
%  Mon Jan 17 2011  Abel   
%   - Bugfix: Structure was not completely updated
%	- Code simplified
%  Wed May 4 2011  Abel   
%   - added skipnontemplate function

%---------------- Default parameters --------------
DefaultParam = struct();
DefaultParam.version = 0.01;
% DefaultParam.minarguments = 2;
% DefaultParam.maxarguments = 3;
% DefaultParam.nrarguments = nargin;
DefaultParam.skipnontemplate = false;
DefaultParam.help = {'updatestruct(DefaultStruct, UpdateStruct, OptionalParams)'};

param = [];

%---------------- Main program --------------------
% Return factory settings
if nargin == 0 || strcmpi('factory', DefaultStruct)
	printHelp(DefaultParam);
	return;
end

% Check if additional options were set (getArguments() can handle an empty
% varargin)
param = getArguments(DefaultParam, varargin);

% Update struct: If skipnontemplate is set only update the Template
% fieldnames. Otherwise update and/or add all fieldnames from UpdateStruct.
if param.skipnontemplate
	fieldNames = fieldnames(DefaultStruct);
else	
	fieldNames = fieldnames(UpdateStruct);
end

for n = 1:length(fieldNames);
	if isfield(UpdateStruct, fieldNames{n})
		DefaultStruct.(fieldNames{n}) = UpdateStruct.(fieldNames{n});
	end
end
end