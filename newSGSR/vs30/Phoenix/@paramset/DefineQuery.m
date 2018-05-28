function S = DefineQuery(S, parname, uipos, varargin);
% paramset/DefineQuery - define query for a parameter of paramset object
%   S = DefineQuery(S, 'foo', [X,Y], ...) defines the query for parameter 'foo'
%   of paramset object S. 
%
%   The 2-vector [X,Y] is the position on the OUI of the iucontrols dedicated to foo. 
%   These coordinates are defined re the frame of the query group to which foo belongs.
%   Contrary to MatLab conventions, Y is the vertical distance from the TOP of the frame.
%   Single numbers Z for the position are interpreted as [5 Z].
%
%   The ellipses indicate all input arguments following S. They are 
%   passed to the constructor function Query/Query.
%
%   See also Paramset, Paramset/AddParam, Paramset/InitOUIgroup, Query/Query, paramOUI.


if  nargout<1, 
   error('No output argument using DefineQuery. Syntax is: ''S = DefineQuery(S, parName, Pos, ...)''.');
end

if isvoid(S),
   error('Queries may not be defined for a void paramset object.');
elseif ~hasparam(S, parname),
   error(['Paramset does not contain a parameter named ''' parname '''.']);
elseif isempty(S.OUI), 
   error('At least one QueryGroup must exist before Queries can be added to a paramset. See InitQueryGroup.');
elseif ~(isequal([1,1], size(uipos)) | isequal([1,2], size(uipos))) | ~isnumeric(uipos) | ~isreal(uipos), 
   error('UI position must be scalar or [X,Y] pair of real numbers.'); 
end

if hasItem(S, parname),
   error(['Paramset already contains a query for parameter ''' parname '''.']);
end

if numel(uipos)==1, uipos = [5 uipos]; end % see help text
   
% get the index of the parameter for which the query is being defined
iparam = ParamIndex(S, parname);
% create the query just to test validity of specs
newq = query(S.Stimparam(iparam), varargin{:}); 

spec = varargin; % the definition of the query is contained in the trailing input args
newQuery = collectInstruct(parname, iparam, uipos, spec);
S = AddOUIitem(S, parname, 'query', newQuery);




