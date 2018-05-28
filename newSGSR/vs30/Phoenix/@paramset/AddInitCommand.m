function S = AddInitCommand(S, varargin);
% paramset/AddInitCommand - define initialization command for OUI
%   S = AddInitCommand(S, cmd, arg1, ...), where S is a paramset object
%   adds an initiazation command to S. Initialization commands are
%   executed at the end of the creation of a OUI by paramOUI by
%   passing all the arguments of AddInitCommand to eval.
%
%   Examples:
%      S = AddInitCommand(S, 'disp', ''hello world'' );
%      S = AddInitCommand(S,  'OUIhandle', 'expname.prompt', nan, 'backgroundcolor', rand(3,1));
%   See also ParamSet, paramOUI.

if  nargout<1, 
   error('No output argument using AddInitCommand. Syntax is: ''S = AddInitCommand(S, ...)''.');
end


S.OUI.init = {S.OUI.init{:}, varargin};





