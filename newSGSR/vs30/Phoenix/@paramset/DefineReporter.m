function S = DefineReporter(S, repname, uipos, Ustring, tooltip, varargin);
% paramset/DefineReporter - define reporter uicontrol a OUI of paramset object
%   S = DefineReporter(S, 'foo', [X,Y], sampleString, ToolTip) defines a 
%   reporter named 'foo' of paramset object S at coordinates [X,Y] re the 
%   most recently defined QueryGroup; single numbers Z are interpreted as [5 Z]. 
%   ToolTip is the tooltip of the uicontrol.
%
%   Reporters are named text uicontrols on a OUI which are used to 
%   display messages (see OUIreport). Width and height of the reporter are 
%   adjusted so that sampleString just fits in the text control. Char matrices as 
%   well as string cells may be used for multi-line text.
%   Note: contrary to MatLab conventions, Y is the vertical distance from the 
%   TOP of the QueryGroup.
%
%   The input arguments to DefineReporter may be followed by property/value pairs of
%   the reporter uicontrol as in:
%      S = DefineReporter(S, 'MaxSPL', [X, Y], '[100 102 dB]', 'foregroundcolor', [0 1 0.7]);
%   
%   See also Paramset, Paramset/InitQueryGroup, OUIreport, paramOUI.

if nargin<5, tooltip = ''; end;
if nargin<6, varargin = {[]}; end; % see props struct below

if  nargout<1, 
   error('No output argument using DefineReporter. Syntax is: ''S = DefineReporter(S, parName, Pos, ...)''.');
end

if ~(isequal([1,1], size(uipos)) | isequal([1,2], size(uipos))) | ~isnumeric(uipos) | ~isreal(uipos), 
   error('UI position of reporters must be scalar or 1x2 real: [X,Y].'); 
end

if numel(uipos)==1, uipos = [5 uipos]; end % see help text
   
% put trailing property/value pairs in struct
props = struct(varargin{:});
% put reporter definition in single struct  
R = collectInstruct(Ustring, uipos, props, tooltip);
% add to paramset
S = addOUIitem(S, repname, 'reporter', R);


