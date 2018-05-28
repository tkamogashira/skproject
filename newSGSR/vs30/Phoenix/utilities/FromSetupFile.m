function varargout = FromSetupFile(FN, varargin);
% FromSetupFile - retrieve parameters from setup file
%   [Xval, Yval ..] = FromSetupFile(FN, Xname, Yname, ..) 
%   retrieves parameters named Xname, etc, from setupfile FN
%   that have been stored in FN by an earlier call to ToSetupFile. 
%
%   FromSetupFile(FN) without specication of parameter names, returns
%   all the parameters stored in FN as a atruct whose fieldnames
%   are the parameter names.
%
%   See also ToSetupFile, SetupFile, SetupDir.

% get whole struct
STR = load(setupfile(FN), '-mat');
if nargin<2, % whole struct
   varargout{1} = STR;
else,
   for ii=1:nargin-1,
      varargout{ii} = getfield(STR, varargin{ii});
   end
end 




