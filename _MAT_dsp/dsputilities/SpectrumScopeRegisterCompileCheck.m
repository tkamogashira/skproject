function SpectrumScopeRegisterCompileCheck(block, muObj)
% SPECTRUMSCOPEREGISTERCOMPILECHECK  Compile check registration for the Spectrum
%   Scope block, in which parameters related to the X-axis are updated
%
%  Input arguments:
%    block    - handle to the block being updated
%    muObj    - model updater object

%   Copyright 2010 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectSpectrumScopeData, ...
    @UpdateSpectrumScope);

%-------------------------------------------------------------------------------
% Collect block information under compile stage
function notUsed = CollectSpectrumScopeData(~, ~)

% No mid-compile information is necessary -- only post-compile info
notUsed = [];  % Set to dummy value

%-------------------------------------------------------------------------------
function UpdateSpectrumScope(block, muObj, ~)
% Post compile action:
% Update params related to the X-axis, depending on the version of the block,
% the value of the 'Frequency display offset', 'Minimum frequency', and 'Maximum
% frequency'

needToUpdateXAxisParams = strcmp(get_param(block, 'XAxisParamsVer'), '6.8');

if needToUpdateXAxisParams
    % The X-axis related parameters have not been slupdated - update them
    % otherwise, no need to do anything

    freqDispOffsetStr = get_param(block, 'XDisplay'); % this value is in string
    freqDispOffset = str2double(freqDispOffsetStr); % this could be NaN if 
                                                    % freqDispOffsetStr is a 
                                                    % variable
    
    freqDisplayLimits = get_param(block, 'XLimit');
    
    needToUpdateFreqDispOffset = (freqDispOffset ~= 0);
    needToUpdateXLimits = strcmpi(freqDisplayLimits, 'User-defined');
    
    if needToUpdateFreqDispOffset || needToUpdateXLimits
        % need to update one or both sets of params - 'Frequency display offset'
        % and 'Minimum frequency' & 'Maximum frequency'

        if askToUpdateSpecVecScope(block, muObj)

            xunits_exp = coreSpecVecScopeSlupdate(block);

            funcSet = {};
            paramList = {};

            if needToUpdateFreqDispOffset
                % need to update 'Frequency display offset' param do NOT perform
                % scaling here by multiplying the numerical values - this may 
                % not work if a variable is used for the parameter value.
                % Instead, update parameter edit box with string 'paramValue *
                % correctScaling'.
                funcSetTmp = uSafeSetParam(muObj, block, 'XDisplay', ...
                    [freqDispOffsetStr ' * ' num2str(1/xunits_exp, '%.0e')]);
                funcSet = {funcSetTmp};
                paramList(1) = {'''Frequency display offset'', '};
            end

            if needToUpdateXLimits
                % need to 'Minimum frequency' & 'Maximum frequency' params
                
                xMinStr = get_param(block, 'XMin');
                xMaxStr = get_param(block, 'XMax');

                % do NOT perform scaling here by multiplying the numerical
                % values - this may not work if a variable is used for the
                % parameter value. Instead, update parameter edit box with
                % string 'paramValue * correctScaling'.
                funcSetTmp = uSafeSetParam(muObj, block, ...
                    'XMin', [xMinStr ' * ' num2str(1/xunits_exp, '%.0e')], ...
                    'XMax', [xMaxStr ' * ' num2str(1/xunits_exp, '%.0e')]);
                funcSet{end+1} = funcSetTmp;
                paramList(end+1) = ...
                    {'''Minimum frequency'' and ''Maximum frequency'', '};
                
            end

            % convert cell array of parameters to be updated into a string/char
            % array
            paramList = [paramList{:}];
            % removing trailing ', '
            paramList(end-1:end) = [];
            
            paramUpdateReasonStr = ...
                sprintf(['Update following parameter/s as per the unit set ' ...
                'by ''Frequency units'' parameter: %s'], paramList);
            appendTransaction(muObj, block, paramUpdateReasonStr, {funcSet});
            
        end
    
    end
    
end

% set the flag to indicate that required parameters were slupdated so that the
% next time slupdate is used, this block is not updated.  Use uSafeSetParam
% instead of set_param so that this operation is not performed in 'analyze' mode
% of slupdate
uSafeSetParam(muObj, block, 'XAxisParamsVer', '6.9');

% [EOF]

% LocalWords:  XAxis slupdated XDisplay XLimit XMin XMax
