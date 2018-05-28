function y = sys3deviceList(varargin);
% sys3deviceList - specify/retrieve list of sys3 devices connected
%    y = sys3deviceList returns the list of sys3 devices hooked up to the current setup
%
%    sys3deviceList('RP2_1', ...) specifies the list. This list is remembered across
%    MatLab sessions.

CN = compuname;
SFN = ['sys3devicelist_' CN];
if nargin<1, % query
   y = fromSetupfile(SFN);
   y = y.DEV;
else,
   if (nargin==1) & iscellstr(varargin{1}), varargin=varargin{1}; end % make sure the list is in a cellstr
   DEV = varargin;
   toSetupfile(SFN,DEV);
end



