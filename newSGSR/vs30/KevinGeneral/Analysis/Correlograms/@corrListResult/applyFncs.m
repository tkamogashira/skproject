function CLR = applyFncs(CLR, functionList)
% APPLYFNCS Apply the given list of functions to the correlograms in the CLR object
%
% CLR = applyFncs(CLR, functionList)
%   Apply functions to the corrListObject. The functions need to be in the
%   format explained in the functionProcessing directory (type 'help
%   functionProcessing'). 
%  
% Arguments:
%  functionList: A cell array with names of the functions and the 
%                parameters for these functions. The X and Y arrays should
%                be omitted.
%                Format: 
%                   {'functionName1',{params1},'functionName2',{params2}, ...}
%
% Example:
%  CLR = applyFncs(CLRRaw, {Hilbert, {8}});


%% Prepare a list of data available to the functions
CLO = getCLO(CLR);
results.corrBinWidth    = getCorrBinWidth(CLO);
THR                     = getTHR(CLR);
results.CF              = THR.CF;
magnAtZero              = getMagnAtZero(CLR);
DF                      = getDF(CLR);

listLength = size(CLR.corrFncs, 1);
switch lower(CLR.calcType)
    case {'refrow', 'within'}
        for row=1:listLength
            results.magnAtZero      = magnAtZero(row);
            results.DF              = DF(row);
            [CLR.corrLag{row}, CLR.corrFncs{row}] = localApplyFncs(CLR.corrLag{row}, CLR.corrFncs{row}, results, functionList);
        end
    case {'all', 'deltadiscern'}
        for row = 1:listLength
            for col = 1:listLength
                if ~isempty(CLR.corrLag{row,col})
                    results.magnAtZero      = magnAtZero(row,col);
                    results.DF              = DF(row,col);
                    [CLR.corrLag{row,col}, CLR.corrFncs{row,col}] = localApplyFncs(CLR.corrLag{row,col}, CLR.corrFncs{row,col}, results, functionList);
                end
            end
        end
end

%% apply functions on an individual X,Y pair
function [X,Y] = localApplyFncs(X, Y, results, functionList) %#ok<INUSL> (eval was used)
% check params
NApplyFcns = length(functionList);
if ~isequal(0, mod(NApplyFcns, 2) )
    % extra functions should have even amount of entries
    error('Wrong format for extra functions!');
end

% apply functions to data (like smoothing, splining, ...)
for i = 1:2:NApplyFcns
    applyFcnStr = [functionList{i} '(X, Y'];
    for j = 1:length(functionList{i+1})
        if ischar(functionList{i+1}{j})
            % parameter is a string
            dollarPos = strfind(functionList{i+1}{j}, '$');
            if isequal( 0, mod( length(dollarPos), 2 ) ) & ~isequal(0, length(dollarPos))
                % the string contains an even, non zero ammount of dollar
                % signs; assume it should be parsed
                functionList{i+1}{j} = parseExpression(functionList{i+1}{j}, 'results');
            else
                % this is not something that should be parsed: just put
                % between quotation marks
                functionList{i+1}{j} = ['''' functionList{i+1}{j} ''''];
            end
        end
        applyFcnStr = [applyFcnStr ',' mat2str(functionList{i+1}{j})];
    end
    applyFcnStr = [applyFcnStr ');'];
    Data = eval(applyFcnStr);
    X = Data.XOut;
    Y = Data.YOut;
end
