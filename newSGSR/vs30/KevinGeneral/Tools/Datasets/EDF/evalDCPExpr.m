function [N, SchData, Err] = evalDCPExprNEW(FieldName, DSSName, SchData, DSSParam)

%B. Van de Sande 28-02-2005, Attention! Always first evaluate the expression for the master DSS ...

%For the slave DSS the time settings can be given by referring to the settings of the master DSS. This is
%done by giving a character string with the name of the variable to set the parameter to. 
%The values can also be specified as algebraic expressions. Any expression (upto 32 chars in length) may be
%used, as long as it follows the rules of FORTRAN for legality and precedence. The FORTRAN functions SIN, 
%COS, TAN, SQRT, LOG may be included in the expression. Of course, the variables used in the expression (e.g.
%DUR above) must follow a standard naming convention. The following is a list of currently permitted variable 
%names :
%
%              FREQ      : Carrier (or pure tone) frequency (Hz)
%              FCARR     : same as FREQ
%              SPL       : Sound Intensity (dB)
%              DELAY     : Initial delay in microsecs
%              MDELAY    : Same as DELAY
%              DELM      : Same as DELAY
%              NREP      : Number of repetitions
%              NREPS     : Number of repetitions
%              RTIME     : Rise time (millisecs)
%              FTIME     : Fall time (millisecs)
%              PHASE     : Phase of carrier freq. (0 to 1)
%              PHASM     : Phase of modulating freq. (0 to 1)
%              PHASEM    : Same as PHASM
%              FMOD      : Modulating frequency (Hz)
%              DMOD      : Modulation depth (0 to 1)
%              TONLVL    : Tone level for MASK stim (0 to 1)
%              GWLVL     : GW level for MASK stim (0 to 1)
%              DSSN      : Current DSS number (1 or 2)
%              STMDUR    : Stimulus duration (millisecs)
%              DUR1      : Same as STMDUR
%              DUR       : Same as STMDUR
%              REPINT    : Repetition interval (millisecs)
%              DELAY2    : Masked stimulus delay (microsecs)
%              DUR2      : Masked stimulus duration (millisecs)
%              FRLOW     : Low frequency (Hz) (for FM)
%              FRHIGH    : High frequency (Hz) (for FM)
%              FMRISE    : Rise time for FM sweep (seconds)
%              FMDWELL   : Dwell (hold) time for FM sweep (seconds)
%              FMFALL    : Fall time for FM sweep (seconds)
%              ATNSET    : Attenuator setting (dB)
%              GWDS      : Data set number of GW waveform
%
%Each of these variable names can be specified for either the master or slave DSS by 
%appending #M or #S to them. For example, SPL#M means the SPL of the master DSS, while 
%SPL#S is for the slave. No extension means master DSS. Thus SPL and SPL#M mean the same 
%thing. These extensions have meaning only for two-DSS experiments.

persistent KeyWords; if isempty(KeyWords), KeyWords = getKeyWords; end

Err = 0;

SchName = SchData.SchName;

if strncmpi(DSSName, 'm', 1), DSSIdx = DSSParam.MasterIdx; else, DSSIdx = DSSParam.SlaveIdx; end
Expr = getfield(SchData, 'DSSDAT', {DSSIdx}, FieldName);
%Saved as number in dataset schema (SCH016) ...
if isnumeric(Expr), N = Expr;
%No value assigned or string with N/A (Not Applicable) ...
elseif isempty(Expr) | strcmpi(Expr, 'N/A'), N = NaN;
%Evaluate expression ... 
else,
    Expr = lower(deblank(Expr));
    Tokens = parseExpr(Expr);
    NTokens = length(Tokens);
    
    KeyWordsList = {KeyWords.Name};
    
    for n = 1:NTokens,
        if isnumeric(Tokens{n}), Tokens{n} = num2str(Tokens{n});
        else,
            [TokenName, DSSName] = parseDCPVarName(Tokens{n});
            idx = find(strcmp(KeyWordsList, TokenName));
            if ~isempty(idx),
                FieldName = getfield(KeyWords, {idx}, 'SCHName', upper(SchName));
                switch DSSName(1),
                case 'm', SubstVal = getfield(SchData, 'DSSDAT', {DSSParam.MasterIdx}, FieldName);
                case 's', SubstVal = getfield(SchData, 'DSSDAT', {DSSParam.MasterIdx}, FieldName); end
                Tokens{n} = mat2str(SubstVal);
            end
        end    
    end
    
    Expr = cat(2, Tokens{:});
    try, 
        N = eval(Expr);
        SchData = setfield(SchData, 'DSSDAT', {DSSIdx}, FieldName, N);
    catch N = []; Err = 1; end
end

%------------------------------------------local functions----------------------------------------------------
function LUT = getKeyWords

%FREQ: Carrier (or pure tone) frequency (Hz)
LUT(1).Name           = 'freq';
LUT(1).SCHName.SCH006 = 'FREQ';
LUT(1).SCHName.SCH008 = '';
LUT(1).SCHName.SCH012 = 'FREQ';
%FCARR: same as FREQ
LUT(2).Name           = 'fcarr';
LUT(2).SCHName.SCH006 = 'FREQ';
LUT(2).SCHName.SCH008 = '';
LUT(2).SCHName.SCH012 = 'FREQ';
%SPL: Sound Intensity (dB)
LUT(3).Name           = 'spl';
LUT(3).SCHName.SCH006 = 'SPL';
LUT(3).SCHName.SCH008 = '';
LUT(3).SCHName.SCH012 = 'SPL';
%DELAY, MDELAY, DELM: Initial delay in microsecs
LUT(4).Name           = 'delay';
LUT(4).SCHName.SCH006 = 'DELM';
LUT(4).SCHName.SCH008 = 'DELM';
LUT(4).SCHName.SCH012 = 'DELM';
LUT(5).Name           = 'mdelay';
LUT(5).SCHName.SCH006 = 'DELM';
LUT(5).SCHName.SCH008 = 'DELM';
LUT(5).SCHName.SCH012 = 'DELM';
LUT(6).Name           = 'delm';
LUT(6).SCHName.SCH006 = 'DELM';
LUT(6).SCHName.SCH008 = 'DELM';
LUT(6).SCHName.SCH012 = 'DELM';
%NREP, NREPS: Number of repetitions
LUT(7).Name           = 'nrep';
LUT(7).SCHName.SCH006 = 'NREPS';
LUT(7).SCHName.SCH008 = 'NREPS';
LUT(7).SCHName.SCH012 = 'NREPS';
LUT(8).Name           = 'nreps';
LUT(8).SCHName.SCH006 = 'NREPS';
LUT(8).SCHName.SCH008 = 'NREPS';
LUT(8).SCHName.SCH012 = 'NREPS';
%RTIME: Rise time (millisecs)
LUT(9).Name           = 'rtime';
LUT(9).SCHName.SCH006 = 'RTIME';
LUT(9).SCHName.SCH008 = 'RTIME';
LUT(9).SCHName.SCH012 = 'RTIME';
%FTIME: Fall time (millisecs)
LUT(10).Name           = 'ftime';
LUT(10).SCHName.SCH006 = 'FTIME';
LUT(10).SCHName.SCH008 = 'FTIME';
LUT(10).SCHName.SCH012 = 'FTIME';
%PHASE: Phase of carrier freq. (0 to 1)
LUT(11).Name           = 'phase';
LUT(11).SCHName.SCH006 = 'PHASE';
LUT(11).SCHName.SCH008 = 'PHASE';
LUT(11).SCHName.SCH012 = 'PHASE';
%PHASM, PHASEM: Phase of modulating freq. (0 to 1)
LUT(12).Name           = 'phasm';
LUT(12).SCHName.SCH006 = 'PHASM';
LUT(12).SCHName.SCH008 = 'PHASM';
LUT(12).SCHName.SCH012 = 'PHASM';
LUT(13).Name           = 'phasem';
LUT(13).SCHName.SCH006 = 'PHASM';
LUT(13).SCHName.SCH008 = 'PHASM';
LUT(13).SCHName.SCH012 = 'PHASM';
%FMOD: Modulating frequency (Hz)
LUT(14).Name           = 'fmod';
LUT(14).SCHName.SCH006 = 'FMOD';
LUT(14).SCHName.SCH008 = 'FMOD';
LUT(14).SCHName.SCH012 = 'FMOD';
%DMOD: Modulation depth (0 to 1)
LUT(15).Name           = 'dmod';
LUT(15).SCHName.SCH006 = 'DMOD';
LUT(15).SCHName.SCH008 = 'DMOD';
LUT(15).SCHName.SCH012 = 'DMOD';
%TONLVL: Tone level for MASK stim (0 to 1)
LUT(16).Name           = 'tonlvl';
LUT(16).SCHName.SCH006 = 'TONLVL';
LUT(16).SCHName.SCH008 = 'TONLVL';
LUT(16).SCHName.SCH012 = 'TONLVL';
%GWLVL: GW level for MASK stim (0 to 1)
LUT(17).Name           = 'gwlvl';
LUT(17).SCHName.SCH006 = 'GWLVL';
LUT(17).SCHName.SCH008 = 'GWLVL';
LUT(17).SCHName.SCH012 = 'GWLVL';
%DSSN: Current DSS number (1 or 2)
LUT(18).Name           = 'dssn';
LUT(18).SCHName.SCH006 = 'DSSN';
LUT(18).SCHName.SCH008 = 'DSSN';
LUT(18).SCHName.SCH012 = 'DSSN';
%STMDUR, DUR1, DUR: Stimulus duration (millisecs)
LUT(19).Name           = 'stmdur';
LUT(19).SCHName.SCH006 = 'DUR1';
LUT(19).SCHName.SCH008 = 'DUR1';
LUT(19).SCHName.SCH012 = 'DUR1';
LUT(20).Name           = 'dur1';
LUT(20).SCHName.SCH006 = 'DUR1';
LUT(20).SCHName.SCH008 = 'DUR1';
LUT(20).SCHName.SCH012 = 'DUR1';
LUT(21).Name           = 'dur';
LUT(21).SCHName.SCH006 = 'DUR1';
LUT(21).SCHName.SCH008 = 'DUR1';
LUT(21).SCHName.SCH012 = 'DUR1';
%REPINT: Repetition interval (millisecs)
LUT(22).Name           = 'repint';
LUT(22).SCHName.SCH006 = 'REPINT';
LUT(22).SCHName.SCH008 = 'REPINT';
LUT(22).SCHName.SCH012 = 'REPINT';
%DELAY2: Masked stimulus delay (microsecs)
LUT(23).Name           = 'delay2';
LUT(23).SCHName.SCH006 = 'DELAY2';
LUT(23).SCHName.SCH008 = 'DELAY2';
LUT(23).SCHName.SCH012 = 'DELAY2';
%DUR2: Masked stimulus duration (millisecs)
LUT(24).Name           = 'dur2';
LUT(24).SCHName.SCH006 = 'DUR2';
LUT(24).SCHName.SCH008 = 'DUR2';
LUT(24).SCHName.SCH012 = 'DUR2';
%FRLOW: Low frequency (Hz) (for FM)
LUT(25).Name           = 'frlow';
LUT(25).SCHName.SCH006 = 'FRLOW';
LUT(25).SCHName.SCH008 = '';
LUT(25).SCHName.SCH012 = 'FRLOW';
%FRHIGH: High frequency (Hz) (for FM)
LUT(26).Name           = 'frhigh';
LUT(26).SCHName.SCH006 = 'FRHIGH';
LUT(26).SCHName.SCH008 = '';
LUT(26).SCHName.SCH012 = 'FRHIGH';
%FMRISE: Rise time for FM sweep (seconds)
LUT(27).Name           = 'fmrise';
LUT(27).SCHName.SCH006 = 'FMRISE';
LUT(27).SCHName.SCH008 = '';
LUT(27).SCHName.SCH012 = 'FMRISE';
%FMDWELL: Dwell (hold) time for FM sweep (seconds)
LUT(28).Name           = 'fmdwell';
LUT(28).SCHName.SCH006 = 'FMDWELL';
LUT(28).SCHName.SCH008 = '';
LUT(28).SCHName.SCH012 = 'FMDWELL';
%FMFALL: Fall time for FM sweep (seconds)
LUT(29).Name           = 'fmfall';
LUT(29).SCHName.SCH006 = 'FMFALL';
LUT(29).SCHName.SCH008 = '';
LUT(29).SCHName.SCH012 = 'FMFALL';
%ATNSET: Attenuator setting (dB)
LUT(30).Name           = 'atnset';
LUT(30).SCHName.SCH006 = 'ATTSET';
LUT(30).SCHName.SCH008 = '';
LUT(30).SCHName.SCH012 = 'ATTSET';
%GWDS: Data set number of GW waveform
LUT(31).Name           = 'gwds';
LUT(31).SCHName.SCH006 = 'GWDS';
LUT(31).SCHName.SCH008 = 'GWDS';
LUT(31).SCHName.SCH012 = 'GWDS';

%----------------------------------------------------------------------------------------------------------
function Tokens = parseExpr(Expr)
%B. Van de Sande 06-10-2003
%Old function, removed from general m-files directory and pasted in this file. 28-02-2005

%Parameters nagaan ...
if (nargin ~= 1) | ~ischar(Expr), error('Wrong input arguments.'); end

%Tekensets definieren ...
Cipher    = '0123456789';
Letter    = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_#';
Operators = '+-*/';

%Expressie parsen ...
Tokens  = cell(0);
NTokens = 0;

ParenCount = 0;

Pos = 1;
while Pos <= length(Expr)
    if ismember(Expr(Pos), Letter)
        NTokens = NTokens + 1;
        [Pos, Tokens{NTokens}] = ParseWord(Expr, Pos);
    elseif ismember(Expr(Pos), [Cipher '.'])
        NTokens = NTokens + 1;
        [Pos, Tokens{NTokens}] = ParseNumber(Expr, Pos);
    elseif ismember(Expr(Pos), Operators)
        NTokens = NTokens + 1;
        [Pos, Tokens{NTokens}] = ParseOperator(Expr, Pos);
    elseif strcmp(Expr(Pos), ',')
        NTokens = NTokens + 1;
        Tokens{NTokens} = ',';
        Pos = Pos + 1;
    elseif strcmp(Expr(Pos), '''')
        NTokens = NTokens + 1;
        [Pos, Tokens{NTokens}] = ParseQuotedString(Expr, Pos);
    elseif strcmp(Expr(Pos), '(')
        NTokens = NTokens + 1;
        Tokens{NTokens} = '(';
        ParenCount = ParenCount + 1;
        Pos = Pos + 1;
    elseif strcmp(Expr(Pos), ')')
        NTokens = NTokens + 1;
        ParenCount = ParenCount - 1;
        if ParenCount < 0, error('Parenthesis in expression do not match.'); end
        Tokens{NTokens} = ')';
        Pos = Pos + 1;
    elseif isspace(Expr(Pos)), Pos = Pos + 1;
    else, error(sprintf('%s isn''t a valid character.', Expr(Pos))); end    
end

%-------------------------------------------local functions------------------------------------------------
function [Pos, Wrd] = ParseWord(Expr, Pos)

%Tekensets definieren ...
Cipher = '0123456789';
Letter = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_';

%Woord uit statement halen ...
Wrd = '';
N = length(Expr);
while (Pos <= N) & ismember(Expr(Pos), [Cipher Letter '.']) 
    Wrd = [ Wrd Expr(Pos) ]; Pos = Pos + 1;
end

%----------------------------------------------------------------------------------------------------------
function [Pos, Nr] = ParseNumber(Expr, Pos)

%Tekensets definieren ...
Cipher = '0123456789';

%Woord uit statement halen ...
Wrd      = '';
DotCount = 0;
ExpCount = 0;
N = length(Expr);
while (Pos <= N) & ismember(Expr(Pos), [Cipher '.e'])
    if isequal(Expr(Pos), '.'), 
        DotCount = DotCount + 1;
        if ExpCount == 1, error('Exponent must be integer.'); end
        if DotCount > 1, error('More then one dot in a number.'); end
    elseif isequal(Expr(Pos), 'e'),
        ExpCount = ExpCount + 1;
        if ExpCount > 1, error('More then one exponent symbol in a number.'); end
    end
    Wrd = [ Wrd Expr(Pos) ]; Pos = Pos + 1;
end

%Woord omzetten naar double ...
if (length(Wrd) == 1) & any(strcmp(Wrd, {'e', '.'})), error('Invalid number notation.'); end
Nr = str2num(Wrd); if isempty(Nr), error('Couldn''t parse number.'); end

%----------------------------------------------------------------------------------------------------------
function [Pos, Op] = ParseOperator(Expr, Pos)

%Parameters nagaan ...
if (nargin ~= 2) | ~ischar(Expr) | ~isnumeric(Pos), error('Wrong arguments.'); end

%Tekensets definieren ...
Operators = '+-*/^=<>!';

%Operator uit statement halen ...
Op = '';
if ismember(Expr(Pos), Operators) 
    Op = Expr(Pos); Pos = Pos + 1;
end

N = length(Expr);
if (Pos <= N) & ismember(Expr(Pos), Operators(3:end))
    Op = [Op Expr(Pos)]; Pos = Pos + 1;
end    

%----------------------------------------------------------------------------------------------------------
function [Pos, Str] = ParseQuotedString(Expr, Pos)

%Woord uit statement halen ...
Str = '';
Pos = Pos + 1;
N = length(Expr);
while ~strcmp(Expr(Pos), '''') 
    Str = [ Str Expr(Pos) ]; Pos = Pos + 1;
    if Pos > N, error('Quotation marks in expression do not match.'); end
end
Pos = Pos + 1;
%----------------------------------------------------------------------------------------------------------
