function varargout = channelSelect(activeDAC, varargin);
% channelSelect - select active DAC channels of stimulus parameters
%    channelSelect(DAC, X) uses the specification of active DA channels,
%    DAC, to select the relevant elements of stimulus parameter X.
%    By convention X(:,1) corresponds to the left channel and
%    X(:,2) corresponds to the right channel. DAC is a string whose first
%    character is L|R|B, meaning Left|Right|Both.
%    When A and B are scalars or column vectors,
%      channelSelect('L', [A B]) returns A
%      channelSelect('R', [A B]) returns B
%      channelSelect('B', [A B]) returns [A B]
%      channelSelect('L', A) returns A
%      channelSelect('R', A) returns A
%      channelSelect('B', A) returns [A A] 
%
%    [X,Y,..] = channelSelect(DAC, X, Y, ..) selects multiple parameters.
%
%    channelSelect(S, X, ..), where S is a struct is the same as
%    channelSelect(S.DAC, X, ..).

if numel(varargin)~=nargout,
    error('#inputs does not match #outputs.');
end
if isstruct(activeDAC),
    activeDAC = activeDAC.DAC;
end
activeDAC = activeDAC(1); % L|R|B
switch upper(activeDAC),
    case 'L', ic=1;
    case 'R', ic=2;
    case 'B', ic=1:2;
    otherwise, error('Invalid channel spec');
end
Narg = numel(varargin);
for iarg=1:Narg,
    x = repmat(varargin{iarg},[1 2]); % make sure indexing works even if input is scalaror 3D array
    varargout{iarg} = x(:,ic,:);
end






