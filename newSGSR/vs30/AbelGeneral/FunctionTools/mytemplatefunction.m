function [OutTemplate, Param] = mytemplatefunction(mydataset, varargin)
%MYTEMPLATEFUNCTION     A template file for new functions. 
%                       (This line is scanned by the lookfor function and should contain a 1 line discription) 
% 
% DESCRIPTION
%                       Here a larger description of what the function does and how to use it.
%                       Have a look at:
%                       http://www.mathworks.com/matlabcentral/fileexchange/2529
%                       for the used style guide.
%
% INPUT     
%        mydataset:     Describe input parameters: type / possible
%                       values. Example: mydataset, a dataset object of type...
%        varargin:      Struct or array list of type ['parameter', 'value'] containing function options. 
%                       varargin = ['factory'] Prints de default settings for this function.
%           
% OUTPUT
%        OutTemplate:   Some expected output struct
%        Param:         Struct containing input parameters in struct form, along with altered values.
%                       
%
% EXAMPLES
%        ds = dataset('S0432', -45);
%        Param = struct();
%        Param.testvalue = 1;
%        mytemplatefunction(ds, varargin)
%
% SEE ALSO          processParams   (Place all the SGSR commads here)

%% ---------------- CHANGELOG -----------------------
% date          developer       short description
% 30/11/2010    Abel            Initial creation

%% ---------------- Default parameters --------------
DefaultParam = struct();
DefaultParam.version = 0.01;
DefaultParam.minarguments = 2;
DefaultParam.maxarguments = 2;
DefaultParam.nrarguments = nargin;
DefaultParam.help = {'mytemplatefunction(ds, varargin)'};
DefaultParam.testvalue = 1;

%% ---------------- Main program --------------------
%{
    Naming conventions:
        someVariable
        SomeStruct.somevalue
        somefunction()
        somelocalfunction_()
        someobject
        iSomeIterationVariable
        nSomeNumberOfElemetsVariable
        scratch variables for integers are i, j, k, m, n and for doubles x, y and z.

    Warning classes:
        SGSR:Critical       %Class for important info
        SGSR:Info           %Class for script output info
        SGSR:Debug          %Class for debugging info
%}
        

% Get&Check input arguments based on DefaultParam template.
DefaultParam = struct();
DefaultParam.version = 0.01;
DefaultParam.minarguments = 1;
DefaultParam.maxarguments = 2;
DefaultParam.help = {'mytemplatefunction(ds, varargin)'};

Param = getarguments(DefaultParam, varnargin);
end

%% ---------------- Local functions -----------------
%{
    Local functions should end with an underscore 'name_'
%}
function OutputStruct = mylocalfunction_(InputStruct)
end


