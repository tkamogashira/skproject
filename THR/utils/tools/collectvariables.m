function Q = collectvariables(exclude) %#ok<STOUT>
% collectvariables - collects variables of caller workspace in struct
%   S = collectvariables collects all defined variables of the caller
%   workspace and puts them in struct S.
%
%   S = collectvariables(exclude) does the same, but excludes the variable
%   names parsed in exclude. If multiple variables should be excluded,
%   exclude should be a struct.
%
%   Example:
%
%   >> whos
%     Name        Size               Bytes  Class     Attributes
% 
%     CF          1x1                    8  double              
%     DS          1x1                  270  getds               
%     SP          1x25              291996  struct
%     iall        1x42                 336  double 
%     qq          1x12                 888  cell
%
%   >> S = collectvariables({'SP' 'qq'})
%   S = 
%         CF: 13.4200
%         DS: [1x1 getds]
%       iall: [1x42 double]
%

vars = evalin('caller','whos'); % variables present in caller function
for ii = 1:numel(vars)
    curvname = vars(ii).name; % current variable name
    if isempty(strmatch(curvname,exclude,'exact'))
        D = evalin('caller',curvname); %#ok<NASGU> extract value of variable from caller workspace
        eval('Q.(curvname) = D;') % assign variable and its value from caller function to current workspace
    end
end