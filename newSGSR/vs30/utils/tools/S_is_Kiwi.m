function yn=S_is_Kiwi(er);
% S_is_Kiwi - 1 if \\Kiwi\SGSRserver is mapped network drive S
%   S_is_Kiwi returns 1 if \\Kiwi\SGSRserver is accessible as 
%   mapped network drive S, 0 otherwise.
%
%   S_is_Kiwi(1) throws an error if ~S_is_Kiwi.
if nargin<1, er=0; end

yn = logical(exist('S:\ExpData\Philip\DontRemove.txt', 'file'));
yn= ~~yn; % force 1 instead of 2

if ~yn & er,
   error('\\Kiwi\SGSRserver not is connected as network drive S');
end
