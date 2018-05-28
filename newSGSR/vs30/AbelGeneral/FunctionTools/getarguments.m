function Param = getarguments(Template, varargin)
%GETARGUMENTS       Initializes a function by loading the arguments based
%                   on a given template.
% DESCRIPTION
%                   Initializes a function by loading the arguments based
%                   on a given template. Type checking is performed based
%                   on the input struct, or by an array list of options in
%                   a ['parameter', 'value'] syntax.
%                   All options or fieldnames are case insensitive
%
%
% INPUT
%        Template:     Struct containing the default parameters
%                      values.
%        varargin:     Struct or array list of type ['parameter', 'value'] containing function options.
%                      varargin = ['factory'] Prints de default settings for this function.
%
% OUTPUT
%        Param:         Flattened struct containing the updated default
%                       parameters.
%
%
% EXAMPLES
%        Param = struct();
%        Param.testvalue = 1;
%        Param = getarguments(Param, varargin)
%
% SEE ALSO                              processParams printhelp

%% ---------------- CHANGELOG -----------------------
% date          developer       short description
% 01/12/2010    Abel            Initial creation
%  Fri Apr 22 2011  Abel
%  - add read params from struct option
%  - general debug and rewrite
%  Tue May 31 2011  Abel   
%  - Resolved bugfix for getarguments(Template, varagin) syntax

%% ---------------- Default parameters --------------
DefaultParam = struct();
DefaultParam.version = 0.01;
% DefaultParam.minarguments = 2;
% %DefaultParam.maxarguments = 2;
% DefaultParam.nrarguments = nargin;
DefaultParam.help = {'Param = getarguments(Template, varargin)'};

%---------------- Main program --------------------
%Check if we just wanted to list the defaults
if (nargin == 0) || strcmpi(Template, 'factory')
	printHelp(DefaultParam, 'you need to supply at least a template struct');
	return;
end

%If no varargin just return the give template
if isempty(varargin{:})
	Param = Template;
	return;
end

%Check if the correct arguments were given for GETARGUMENTS
nrOk = countarguments_(DefaultParam);
if (~nrOk)
	printhelp(DefaultParam, 'Error in number of input arguments', 1);
end

%Check if first input is a struct
isStruct = isa(Template, 'struct');
if (~isStruct)
	printhelp(DefaultParam, 'First argument should be a template struct', 1);
end

%Check if the correct arguments were given for Template
nrOk = countarguments_(Template);
if (~nrOk)
	printhelp(Template, 'Error in number of input arguments', 1);
end

%Build Parameters
% if varargin{1} is a struct, update the template accordingly and return
% else varargin is a list of params, update the template using
% processParams() and return

% Ugly hack
%If getarguments was ran as: getarguments(Template, varagin) with varagin a
%single struct, then the struct is wrapped within a double cell struct =
%varagin{1}{1}
if nargin == 2 && isequal([1 1], size(varargin{:})) && iscell(varargin{:})
	%unwrap the first cell layer
	varargin = varargin{:};
end

%Now test for structure are second argumant
if isstruct(varargin{1})
	Param = updatestruct(Template, varargin{1});
	return;
end
try
	[Param, structFields] = wrapStructInCell_(varargin{:});
	Param = processParams(Param, Template);
	if ~isempty(structFields)
		Param = unwrapStructInCell_(Param, structFields);
	end
catch exception
	Param = Template;
	warning('SGSR:Critical', 'Error trying to processParams');
	printhelp(Template, exception.message, 1);
end

end

%---------------- Local functions -----------------
%FUNCTION: countarguments_      Test if the correct number of arguments was
%                               given.
function nrOk = countarguments_(Param)
hasNrArguments = isfield(Param, 'nrarguments');
if (~hasNrArguments)
	nrOk = 1;
	return;
end
nArguments = Param.nrarguments;

hasMinArguments = isfield(Param, 'minarguments');
hasMaxArguments = isfield(Param, 'maxarguments');
if (hasMinArguments) && (nArguments < Param.minarguments)
	printhelp(Param, 'Not enough input arguments');
	nrOk = 0;
elseif (hasMaxArguments) && (nArguments > Param.maxarguments)
	printhelp(Param, 'To many input arguments');
	nrOk = 0;
else
	nrOk = 1;
end
end

%FUNCTION: wrapStructInCell_	Wrap a cell around any struct in vargin. We
%want processParams() to update the Template with these and not use them as a
%parameter list
function [param,structFields] = wrapStructInCell_(param)
structFields = {};
for n=1:length(param)
	if isstruct(param{n})
		param{n} = {param{n}};
		structFields{end +1} = param{n-1};
	end
end
end

%FUNCTION: unwrapStructInCell_ unwrap cell structs after safe execution of processParams()
function param = unwrapStructInCell_(param, structFields)
for n=1:length(structFields)
	param.(structFields{n}) = param.(structFields{n}){:};
end
end


