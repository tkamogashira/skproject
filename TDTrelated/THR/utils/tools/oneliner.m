function [S, f] = oneliner(f);
% Oneliner - first line of help text from mfile.
%   oneliner('Foo') or oneliner(@Foo) reurns the first line of the help
%   text of function Foo.
%
%   [Str, Fnc] = oneliner(@Foo) also returns the name of the function.
%
%   S = oneliner({'Foo' 'Goo' 'Moo' ..}) returns oneliners in struct S.
%   Fieldnames are the function names.
%
%   See also help, methods, methodsHelp.

if iscell(f), % use recursion
    for ii=1:length(f),
        [s, fn{ii}] = oneliner(f{ii});
        S.(fn{ii}) = s;
    end
    f = fn;
    return;
end

if isa(f, 'function_handle'), % get function name
    f = char(f); % which can not handle function handles
end

if ~ischar(f),
    error('Argument to oneliner should be string, function handle, or cell array containing strings and/or function handles.');
end

mf = which(f);
mf = trimspace(mf);
if isempty(mf),
    error(['Function ''' f ''' not found.']);
end

if ~isempty(strmatch('built-in', mf)), % extract the mfile containing the help text
    mf = mf(11:end-1); % e.g. 'built-in (C:\Program Files\MATLAB\R2007a\toolbox\matlab\general\type)'
end

mf = fullFileName(mf,'dum','.m'); % provide .m extension if needed

if ~exist(mf,'file'),
    error(['Unable to locate mfile for function ''' f '''.']);
end

% mfile exists - read its first commented-out line
S = '';
fid = fopen(mf,'rt');
try,
    while 1,
        L = fgetl(fid);
        if ~ischar(L),
            break;
        end
        L = trimspace(L); % remove heading space
        if ~isempty(L) && isequal('%', L(1)),
            S = trimspace(L(2:end));
            break;
        end
    end
catch,
    fclose(fid);
    error(lasterror);
end
fclose(fid);
% by convention, the first word of the one-liner help is the function name:
% remove it.
[dum, S] = strtok(S);
S = trimspace(S);
% Most EARLY function oneline help starts with 'FOO - blahblah'
% remove the '-'
if ~isempty(S) && isequal('-', S(1)),
    S = trimspace(S(2:end));
end


