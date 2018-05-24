function varargout = AddContents(Dir);
% AddContents - append recent mfiles in dir to contents.m file
%   AddContents('Foo') checks the contents.m file in directry Foo and adds
%   the one-line help of any mfiles in Foo not yet mentioned in contents.m.
%
%   See also GenContents, HELP, WHAT.

if ~exist(Dir,'dir'),
    error(['Directory ''' Dir ''' not found.']);
end

% ----collect one-line help texts from all mfiles in Dir-----
W = what(Dir);
if length(W)>1,
    error(['Ambiguous path specification ''' Dir '''.']);
end
if isempty(W.m),
    error(['No mfiles found in ' W.path]);
end
Nfile = length(W.m);
HelpLines = cell(Nfile,1);
for ifile=1:Nfile,
    FN = fullfile(W.path, W.m{ifile});
    H = local_onelinehelp(FN);
    if isempty(H),
        H = ['% =======Helpless ' FN '========='];
    end
    HelpLines{ifile} = H;
end
%HelpLines

% ----Find out which mfiles occur in  contents file-----
AppendStr = '';
CFN = fullfile(W.path, 'contents.m');
if exist(CFN,'file'),
    % read whole contents.m file into a char string
    fid = fopen(CFN);
    Contents = char(fread(fid,inf,'char')'); 
    fclose(fid);
    Contents = lower(Contents);
    for ifile=1:Nfile,
        mfile = lower(W.m{ifile}(1:end-2)); % strip off the trailing '.m'
        if ~isequal(mfile, 'contents') && isempty(strfind(Contents, mfile)),
            AppendStr = strvcat(AppendStr, [HelpLines{ifile} '(from ' mfile ')']);
        end
    end
end
%AppendStr;
if ~isempty(AppendStr),
    AppendStr = strvcat('=====NEW========', AppendStr);
    textwrite(CFN, AppendStr);
end
edit(CFN);
            

%==================
function H = local_onelinehelp(FN);
H = '';
fid=fopen(FN,'rt');
while 1,
    tline = fgetl(fid);
    if ~ischar(tline), 
        break, 
    elseif ~isempty(regexp(tline, '^\s*%', 'once' )); % full comment line
        H = tline;
        break;
    end
end
fclose(fid);

