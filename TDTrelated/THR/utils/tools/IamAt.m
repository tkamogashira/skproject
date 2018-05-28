function Str=IamAt(cmd);
%  IamAt - tool for displaying current function or method
%    eval(IamAt), when called from a function or method, displays the
%    mfilename with the class name (if any). Debug tool.
%
%    eval(IamAt('indent')) does the same, but will cause the *next* call to
%    IamAt to be indented. 
%
%    IamAt needs initialization, or else it will return ''.
%    use IamAt('activate') to activate.
%    use IamAt('inactivate') to inactivate.

persistent CMD ACTIVE INDENT; 
if isempty(ACTIVE), ACTIVE=0; end
if isempty(INDENT), INDENT=0; end


if nargin>0 && isequal('indent',cmd), INDENT=-1;
elseif nargin>0,
    if isequal('activate',cmd), ACTIVE=1;
    elseif isequal('inactivate',cmd), ACTIVE=0;
    else, CMD = cmd;
    end
    return;
end

ind = ''; % default: no indentation
if isequal(INDENT,1),  % do use indentation
    ind = '   ';
    INDENT = 0; % next time, don't
elseif isequal(-1, INDENT), % don't now, but do next time
    INDENT = 1;
end

if ~ACTIVE, Str=''; 
else,
    Str = ['if isempty(mfilename(''class'')), disp([''' ind '*****>'' mfilename]), ' ...
        'else, disp([''' ind '*****>'' mfilename(''class'') ''/'' mfilename]), end;' CMD];
end




