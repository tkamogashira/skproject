function [RAPStat, CallerLineNr, ErrTxt] = RAPCmdEM(RAPStat, CallerLineNr, MacroFileName)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 26-03-2004

%-------------------------------------RAP Syntax------------------------------------
%   EM @@..@@		          Execute (run) specified macro
%-----------------------------------------------------------------------------------

%-------------------------------implementation details--------------------------
%   1)A macro must always end with a RETURN command. This may seem an annoying
%     rule, but this is the only way that a reference to an invalid line number with
%     the GO command can be checked!
%   2)Commands in macro's are case-insensitive.
%   3)Invoking a macro from the command line is different from executing a macro
%     from MATLAB. The memory usage is different, in the former case the macro runs
%     in the same RAP memory and settings space as the command line. For the latter
%     this is not the case, it runs in its own RAP memory and settings space even
%     if an RAP session has already been launched previously.
%   4)While running a macro, the output to the command window is annihilated.
%   5)Macro statements can be echoed to the command window if requested. If this
%     is the case then commands are also verbose in scripts ...
%-------------------------------------------------------------------------------

ErrTxt = '';

%Parsing of macro filename ...
[FullFileName, MacroFileName, ErrTxt] = ParseMCOFileName(RAPStat, MacroFileName);
if ~isempty(ErrTxt), return; end

%Opening of macro file and making internal representation of this macro. While building
%the internal representation, a table of label-identifiers is constructed ...
fid = fopen(FullFileName, 'rt');
if fid < 0, ErrTxt = sprintf('Couldn''t open %s.', FullFileName); end

McoLine = 0; McoStr = cell(0); 
PseudoCode = cell(0); LblTable = cell(0);
while 1,    
    LineStr = fgetl(fid);
    if ~ischar(LineStr), break; 
    else, 
        McoLine = McoLine + 1; 
        McoStr{McoLine} = LineStr;
    end
    
    if ~isempty(LineStr),
        if strncmpi(LineStr, '!', 1), %MATLAB escape sequence ... 
            TokenList = {LineStr};
        else, %Normal RAP Command ...
            [TokenList, ErrTxt] = TokenizeRAPStatement(LineStr);
            if ~isempty(ErrTxt), 
                ErrTxt = sprintf('%s on line %d in %s', ErrTxt, McoLine, upper(MacroFileName));
                fclose(fid); return; 
            end
            if ~ParseRAPTokenList(TokenList), 
                ErrTxt = sprintf('Syntax error on line %d in %s', McoLine, upper(MacroFileName)); 
                fclose(fid); return; 
            end
            LblID = ParseRAPCmd(TokenList);
            if ~isempty(LblID),
                if ~isnan(GetLineNr4Lbl(LblTable, LblID)), 
                    ErrTxt = sprintf('Label identifier ''%s'' is defined for the second time on line %d in %s', LblID, McoLine, upper(MacroFileName));
                    fclose(fid); return;
                else, LblTable(end+1, :) = { LblID, McoLine }; end
            end
        end        
    else, TokenList = {}; end
        
    PseudoCode{McoLine} = TokenList;
end    

fclose(fid);

%Executing pseudocode ...
RAPStat.ComLineParam.InMco   = 'yes';
RAPStat.ComLineParam.McoName = [upper(MacroFileName) '.MCO'];
%Restricting the output when executing macro's only if command echoing is not requested ...
if strcmpi(RAPStat.ComLineParam.McoEcho, 'off'), RAPStat.ComLineParam.Verbose = 'no';
else, fprintf('MCO (Entering %s)\n', upper(MacroFileName)); end
LineNr = 1; 
while (LineNr ~= 0),
    PrevLineNr = LineNr;
    if strcmpi(RAPStat.ComLineParam.McoEcho, 'on'), fprintf('MCO(%d)>> %s\n', LineNr, McoStr{LineNr}); end
    
    if ~isempty(PseudoCode{LineNr}) & strncmpi(PseudoCode{LineNr}{1}, '!', 1),
        [RAPStat, LineNr, ErrTxt] = RAPEscape2MATLAB(RAPStat, LineNr, PseudoCode{LineNr}{1});
        if ~isempty(ErrTxt),
            ErrTxt = sprintf('%s on line %d in %s', ErrTxt, LineNr, upper(MacroFileName));
            RAPStat = TerminateMco(RAPStat);
            return;
        end
    else,    
        [dummy, Cmd, Args] = ParseRAPCmd(PseudoCode{LineNr}); %Label ID is discarded in this phase ...
        if ~isempty(Cmd),
            [RAPStat, LineNr, ErrTxt] = ExecuteRAPCmd(RAPStat, LineNr, Cmd, Args{:});
            %The previous RAP command could have been the execution of a macro ...
            if strcmpi(RAPStat.ComLineParam.McoEcho, 'off'), RAPStat.ComLineParam.Verbose = 'no'; end
            RAPStat.ComLineParam.InMco   = 'yes';
            RAPStat.ComLineParam.McoName = [upper(MacroFileName) '.MCO'];
            if ~isempty(ErrTxt), 
                ErrTxt = sprintf('%s on line %d in %s', ErrTxt, LineNr, upper(MacroFileName));
                RAPStat = TerminateMco(RAPStat);
                return;
            elseif ischar(LineNr),
                NewLineNr = GetLineNr4Lbl(LblTable, LineNr);
                if isnan(NewLineNr),
                    ErrTxt = sprintf('Reference to label that doesn''t exist on line %d in %s', PrevLineNr, upper(MacroFileName));
                    RAPStat = TerminateMco(RAPStat);
                    return;
                else, LineNr = NewLineNr; end    
            end
        else, LineNr = LineNr + 1; end
    end
    if (LineNr > McoLine),
        ErrTxt = sprintf('Reference to line number that doesn''t exist in %s', upper(MacroFileName));
        RAPStat = TerminateMco(RAPStat);
        return;
    end
end
if strcmpi(RAPStat.ComLineParam.McoEcho, 'on'), fprintf('MCO (Leaving %s)\n', upper(MacroFileName)); end    
RAPStat = TerminateMco(RAPStat);

%Line number of calling routine has to be augmented with one, because invocation
%of macro is considered as one line ...
CallerLineNr = CallerLineNr + 1;

%---------------------------------------local functions-------------------------------
function RAPStat = TerminateMco(RAPStat)

RAPStat.ComLineParam.Verbose = 'yes';
RAPStat.ComLineParam.InMco   = 'no';
RAPStat.ComLineParam.McoName = ManageRAPStatus('ComLineParam.McoName');