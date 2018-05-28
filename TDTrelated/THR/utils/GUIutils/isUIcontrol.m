function iu = isUIcontrol(x);
% ISUICONTROL - True for handle of uicontrol
%   ISUICONTROL(X) returns 1 if X is a single handle to a uicontrol, 
%   0 otherwise.
iu = 0;
if issinglehandle(x),
   iu = isequal(get(x,'type'),'uicontrol');
end