function ArgOut = rap(varargin)
%RAP respons area analysis program
%   RAP starts an emulation of Response Area Analysis Program (RAP), the program 
%   used for analysis of data collected in the auditory lab at the University of
%   Wisconsin, Madison. The emulation is started in command mode, i.e. it accepts
%   commands from the user and takes appropriate action. Type 'HELP' for a list
%   of commands. Use 'EXIT' to return to the standard MATLAB prompt.
%
%   RAP(FileName) runs the script FileName. If no directory is supplied, the
%   current working directory is assumed. The default extension is '.MCO'. After
%   completion of the script, execution is returned to MATLAB.
%
%   For further information on RAP see Users Guide on 
%   http://www.neurophys.wisc.edu/comp/docs/rap/rep007.html
%
%   See also RAPCMD, RAPDS

%B. Van de Sande 10-11-2004

FirstSession = 0;
persistent RAPStat; 

if ~any(nargin == [0, 1, 2])
    error('Wrong number of input arguments.');
end

if (nargin == 1) && isnumeric(varargin{1}) && any(varargin{1} == [1, 2])
    %Return foreground or background dataset currently being loaded ...
    if (varargin{1} == 1)
        if ~isempty(RAPStat) && ~isRAPStatDef(RAPStat, 'GenParam.DS')
            ArgOut = RAPStat.GenParam.DS;
            return;
        else error('No foreground dataset currently loaded in the RAP session.');
        end
    else
        if ~isempty(RAPStat) && ~isRAPStatDef(RAPStat, 'GenParam.DS2')
            ArgOut = RAPStat.GenParam.DS2;
            return;
        else
            error('No background dataset currently loaded in the RAP session.');
        end
    end    
elseif (nargin == 1) && ischar(varargin{1}) %Run script ...
    %Script must be executed within it's own RAP Status structure ...
    ScriptRAPStat = ManageRAPStatus;
    %Setting the paging of the output and the warning level ...
    CurMoreSetting = get(0, 'More');
    CurWarningSetting = warning;
    if ~strcmpi(ScriptRAPStat.ComLineParam.More, CurMoreSetting)
        set(0, 'More', ScriptRAPStat.ComLineParam.More); 
    end  
    if ~strcmpi(ScriptRAPStat.ComLineParam.Warning, CurWarningSetting)
        warning(ScriptRAPStat.ComLineParam.Warning); 
    end
    % ignore case sensitivity anyway (Kevin), necessary?? (Ramses)
    if highVersion
        warning('off','MATLAB:dispatcher:InexactMatch');
    end
    
    [dummy, dummy, ErrTxt] = ExecuteRAPCmd(ScriptRAPStat, 0, 'EM', varargin{1}); 
    %Resetting the paging of the output and the warning level ...
    set(0, 'More', CurMoreSetting);
    warning(CurWarningSetting);
    if ~isempty(ErrTxt)
        error('%s.\n', ErrTxt);
    else
        return;
    end
elseif (nargin == 2) && isnumeric(varargin{1}) && ischar(varargin{2}) %Run single command ...
    %Warning level and paging of output is the same as in the MATLAB workspace ...
    if isempty(RAPStat)
        RAPStat = ManageRAPStatus;
    end;
    [TokenList, ErrTxt] = TokenizeRAPStatement(varargin{2});
    if ~isempty(ErrTxt)
        error('%s.\n', ErrTxt);
    end
    if ~ParseRAPTokenList(TokenList)
        error('Syntax error.');
    end
    if ~isempty(TokenList)
        Cmd = TokenList{1};
        Args = TokenList(2:end);
        [RAPStat, dummy, ErrTxt] = ExecuteRAPCmd(RAPStat, 0, Cmd, Args{:});
        if ~isempty(ErrTxt)
            error('%s.\n', ErrTxt);
        end
    end
    return;
elseif (nargin > 0)
    error('Optional and only argument should be name of macro to execute.');
end

if isempty(RAPStat)
    FirstSession = 1;
    RAPStat = ManageRAPStatus;
end    

%Command Line interface ...
if FirstSession
    disp(' ');
    disp(' +----------------------------------+ ');
    disp(' | RAP emulation program for MATLAB | ');
    disp(' +----------------------------------+ ');
    disp(' ');
    disp(' Type HELP for more information ... ');
    disp(' ');
end

%Setting the paging of the output ...
CurMoreSetting = get(0, 'More');
if ~strcmpi(RAPStat.ComLineParam.More, CurMoreSetting)
    set(0, 'More', RAPStat.ComLineParam.More);
end  

%Setting the warning level ...
CurWarningSetting = warning;
if ~strcmpi(RAPStat.ComLineParam.Warning, CurWarningSetting)
    warning(RAPStat.ComLineParam.Warning); 
    % ignore case sensitivity anyway (Kevin)
    if highVersion
        warning('off','MATLAB:dispatcher:InexactMatch');
    end
end  

LineNr = 1;
while LineNr ~= 0;
    PrevLineNr = LineNr;
    
    CmdLine = input('RAP>> ', 's');
    
    %Last level of error trapping is done via a try-catch block ...
    try 
        if strncmpi(CmdLine, '!', 1)%MATLAB escape sequence ...
            [RAPStat, LineNr, ErrTxt] = RAPEscape2MATLAB(RAPStat, LineNr, CmdLine);
            if ~isempty(ErrTxt)
                fprintf('ERROR: %s.\n', ErrTxt);
                continue;
            end
        else %Normal RAP Command ...
            [TokenList, ErrTxt] = TokenizeRAPStatement(CmdLine);
            if ~isempty(ErrTxt)
                fprintf('ERROR: %s.\n', ErrTxt);
                continue;
            end
            if ~ParseRAPTokenList(TokenList)
                disp('ERROR: Syntax error.');
                continue;
            end
            
            [LblID, Cmd, Args] = ParseRAPCmd(TokenList);
            if ~isempty(LblID)
                fprintf('ERROR: Labels can''t be defined on the command line.\n');
                continue;
            elseif ~isempty(Cmd)
                [RAPStat, LineNr, ErrTxt] = ExecuteRAPCmd(RAPStat, LineNr, Cmd, Args{:});
                if ~isempty(ErrTxt)
                    fprintf('ERROR: %s.\n', ErrTxt);
                    continue; 
                elseif ischar(LineNr)
                    fprintf('ERROR: Jumping to a label isn''t possible on the command line.\n');
                    LineNr = PrevLineNr + 1;
                    continue;
                end
            end
        end
    catch
        ErrLines = Words2cell(lasterr, sprintf('\n'))';
        NErrLines = length(ErrLines);
        disp([repmat('ERROR: ', NErrLines, 1), char(ErrLines)]);
        %Resetting the RAP status after unknown error ...
        if ~strcmpi(lasterr, 'Screen output interrupted by user.')
            [RAPStat, LineNr, ErrTxt] = ExecuteRAPCmd(RAPStat, 0, 'SET', 'DEF'); 
        end
    end
end

%Resetting the paging of the output ...
set(0, 'More', CurMoreSetting);

%Resetting the warning level ...
warning(CurWarningSetting);
