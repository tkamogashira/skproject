function W = whoiscalling();
% whoiscalling - display caller and caller's caller, etc (debug tool)
%   whoiscalling, when called from a function F, displays the function that
%   called F, its caller, etc.
%
%   W = whoiscalling retruns the function names in cell array W.

qq = dbstack;
qq = qq(end:-1:2);

Str = qq(1).name;
W = {Str};
for ii=2:numel(qq),
    if nargout<1,
        Str = strvcat(Str, [repmat('>',1,ii-1) qq(ii).name]);
    else,
        W = [W Str];
    end
end
if nargout<1,
    disp(Str);
    clear W;
end
