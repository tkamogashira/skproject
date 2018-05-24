function comments = dspparameq_mpt_comments(objectName, modelName, request)
% An example M-script to create custom comments for Simulink data objects.
% In this example, comments are placed immediately above the data's declaration
% and definition.
%
% You can define your own function name provided it has these three
% arguments.
%
%   INPUTS:
%         objectName: The name of mpt Parameter or Signal object
%         modelName:  The name of working model
%         request:    The nature of the code or information requested. 
%                     Two kinds of requests are supported:
%                     'declComment' -- comment for data declaration
%                     'defnComment' -- comment for data definition
%   OUTPUT:
%         comments:   A comment according to standard C convention
%
% Requirement: This file must be on the MATLAB path.
%
% Recommend: Use get_data_info to get the property value of a Simulink
%            or mpt data object, as illustrated in this example.
%
% See also get_data_info.

%   Copyright 2008-2011 The MathWorks, Inc.

% Add comments for variable definitions
if strcmp(request,'defnComment')
    desc     = get_data_info(objectName,'Description');
    cr       = sprintf('\n');
    comments = ['/* ' desc  cr ... 
                ' */'];
else
    comments = [];
end
