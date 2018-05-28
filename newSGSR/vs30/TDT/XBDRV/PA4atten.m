function Name = PA4atten(Dev, Atten)

% function PA4atten(Dev, Atten) - XBUS PA4atten
% default Dev=1, Atten=99.9

if nargin<1, Dev=1; end;

persistent UsePA5s

% find out if PA5s must be used instead of PA4s
% this is done in 2 steps:
%  (1) try to access PA4s
%  (2) if this fails, try to access PA5s
if isempty(UsePA5s) | (nargout>0),
   try
      s232('PA4atten', Dev, 0);
      UsePA5s = 0;
      Name = ['PA4_' num2str(Dev)];
   catch
      try
         if isequal(3,exist('z3.dll'));
            try 
               z3('PA5setatt', Dev, 0);
               UsePA5s = 1;
               Name = ['PA5_' num2str(Dev)];
            catch
               error('Cannot find PA4 or PA5');
            end
         else,
            error('Cannot find PA4; no z3.dll to try PA5');
         end
      end
   end
end

if UsePA5s,
   if nargin<2, Atten=120; end;
   z3('PA5setatt', Dev, Atten);
else,
   if nargin<2, Atten=99.9; end;
   s232('PA4atten', Dev, Atten);
end;


   
