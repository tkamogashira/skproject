 function VectorScopeRegisterCompileCheck(block, muObj)
% VECTORSCOPEREGISTERCOMPILECHECK  Compile check registration for the Vector
%   Scope block, in which parameters related to the X-axis are updated
%
%  Input arguments:
%    block    - handle to the block being updated
%    muObj    - model updater object

%   Copyright 2010 The MathWorks, Inc.

appendCompileCheck(muObj, block, @CollectVectorScopeData, ...
    @UpdateVectorScope);

%-------------------------------------------------------------------------------
% Collect block information under compile stage
function notUsed = CollectVectorScopeData(~, ~)

% No mid-compile information is necessary -- only post-compile info
notUsed = [];  % Set to dummy value

%-------------------------------------------------------------------------------
function UpdateVectorScope(block, muObj, ~)
% Post compile action:
% Update params related to the X-axis, depending on the version of the block,
% the value of the 'Minimum frequency' and 'Maximum frequency'


needToUpdateXAxisParams = strcmp(get_param(block, 'XAxisParamsVer'), '6.8');

if needToUpdateXAxisParams
    % The X-axis related parameters have not been slupdate'd - update them
    % otherwise, no need to do anything

    domain = get_param(block, 'Domain');

    if strcmpi(domain, 'Time')
        % 'Time' domain
        
        updateParamsTimeDomain(block, muObj);
        
    elseif strcmpi(domain, 'Frequency')
        % Frequency domain
        
        updateParamsFrequencyDomain(block, muObj);
        
        %else %%% nothing to be done for 'User-defined' domain
    end 

end

% set the flag to indicate that required parameters were slupdate'd so that the
% next time slupdate is used, this block is not updated.  Use uSafeSetParam
% instead of set_param so that this operation is not performed in 'analyze' mode
% of slupdate
uSafeSetParam(muObj, block, 'XAxisParamsVer', '6.9');


%-------------------------------------------------------------------------------
function updateParamsTimeDomain(block, muObj)

XDisplayLimits   = get_param(block, 'XLimit');
needToUpdateXLimits = strcmpi(XDisplayLimits, 'User-defined');
    
if needToUpdateXLimits
    % need to update 'Minimum X-limit' & 'Maximum X-limit' parameters

    if askToUpdateSpecVecScope(block, muObj) %%askToReplace(muObj, block)    

        context     = getContext(muObj);
        % work our way up from whatever context we get to the model
        while strcmpi(get_param(context,'Type'), 'block')
            context = get_param(context,'Parent');
        end
        
        block_data = get_param(block, 'UserData');
        
        % copied in bits and pieces from sdspfscope2->setup_axes() --- start
        if block_data.Ts<0,
            % Triggered:
            ts = 1;
        else
            ts = block_data.Ts;
        end

        if (block_data.samples_per_frame==1) && (block_data.params.HorizSpan==1)
            xLimits = [-ts ts];  % prevent problems
        else
            xData  = (0:block_data.samples_per_frame*block_data.params.HorizSpan-1)' * ts;
            xLimits = [-ts xData(end)+ts];
        end

        % Adjust x-axes for engineering units:
        % Allow scalar
        if xLimits(2)==0,
            xLimits=[0 1];
        elseif (xLimits(1) > xLimits(2)),
            xLimits(1:2)=xLimits([2 1]);
        end
        
        [xunits_valNotUsed, xunits_exp, xunits_prefixNotUsed] = ...
            engunits(max(abs(xLimits)), 'latex','time'); %#ok

        % copied in bits and pieces from sdspfscope2->setup_axes() --- end

        reasonStr = ['Update ''Minimum X-limit'' and ' ...
            '''Maximum X-limit'' parameters to be in ''seconds'' unit'];
        updateParams(block, muObj, xunits_exp, reasonStr);

    end
    
end

%-------------------------------------------------------------------------------
function updateParamsFrequencyDomain(block, muObj)

FreqDisplayLimits   = get_param(block, 'XLimit');
needToUpdateFreqDispLimits = strcmpi(FreqDisplayLimits, 'User-defined');

if needToUpdateFreqDispLimits
    % need to update 'Minimum frequency' & 'Maximum frequency' parameters

    if askToUpdateSpecVecScope(block, muObj)

        xunits_exp = coreSpecVecScopeSlupdate(block);
        reasonStr = ...
            ['Update following parameters as per the unit set by ' ...
            '''Frequency units'' parameter: ''Minimum frequency'' and ' ...
            '''Maximum frequency'''];

        updateParams(block, muObj, xunits_exp, reasonStr);
        
    end
    
end

%-------------------------------------------------------------------------------
function updateParams(block, muObj, xunits_exp, reasonStr)

xMinStr = get_param(block, 'XMin');
xMaxStr = get_param(block, 'XMax');

% do NOT perform scaling here by multiplying the numerical values - this may not
% work if a variable is used for the parameter value. Instead, update parameter
% edit box with string 'paramValue * correctScaling'.
funcSet = uSafeSetParam(muObj, block, 'XMin', ...
    [xMinStr ' * ' num2str(1/xunits_exp, '%.0e')], ...
    'XMax', [xMaxStr ' * ' num2str(1/xunits_exp, '%.0e')]);

appendTransaction(muObj, block, reasonStr, {funcSet});

%-------------------------------------------------------------------------------

% [EOF]

% LocalWords:  XAxis slupdate'd XLimit sdspfscope XMin XMax
