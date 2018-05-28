function yn=BB(er);
% B_is_Bigscreen - 1 if bisgscreen/Oog is mapped network drive B
%   B_is_Bigscreen returns 1 if Bigscreen\C or Oog\C is accessible as 
%   mapped network drive B, 0 otherwise.
%
%   B_is_Bigscreen(1) throws an error if ~B_is_Bigscreen.
if nargin<1, er=0; end


yn = exist('B:\usr\marcel\YesThisIsBigscreen.txt', 'file') | exist('B:\Program Files\thisIsOOG.txt');
yn= ~~yn; % force 1 instead of 2

if ~yn & er,
   error('Bigscreen\C not is connected as network drive B:');
end
