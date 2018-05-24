function dspLinkFVTool2Mask(hBlk,mode)
%dspLinkFVTool2Mask Callback for linking FVTool to a block mask.
%   dspLinkFVTool2Mask(block,mode) will launch a new FVTool or re-use an existing
%   FVTool from a block mask. The handle to FVTool will be stored in the
%   UserData of the block in a field of a structure called 'fvtool', e.g.,
%   ud.fvtool.
%
%   This function calls fvtool using a filter object assumed to be cached in
%   the UserData of the block as a field called 'filter', e.g. ud.filter.
%
%   This function must also be called from the 'init' portion of the mask
%   helper function so that FVTool will be updated based on changes to the
%   filter parameters.
%
%   Valid modes are:
%   'create': Launch a new FVTool (if one doesn't already exist for the block)
%   'update': Update the linked FVTool plot (do nothing if it's closed or doesn't exist)
%   'close':  Close the linked FVTool plot (do nothing if it's already closed)

%   Author(s): Hari Kumar
%   Copyright 1988-2011 The MathWorks, Inc.

if nargin < 2
    mode = 'close';
end

ud = get_param(hBlk, 'UserData');

if strcmpi(mode,'close')
    closeFVTool = 1;
else
    closeFVTool = 0;
    filtobj = [];
    if isfield(ud,'filter')
        filtobj = ud.filter;
    else
        if ((isfield(ud,'filterConstructor') && ...
             isfield(ud,'filterConstructorArgs')) && ...
            ~isempty(ud.filterConstructorArgs))
            try
                if strcmpi(ud.filterConstructor,'mfilt.cicdecim') || ...
                        strcmpi(ud.filterConstructor,'mfilt.cicinterp')
                    filtobj = createCICfiltObj(ud);
                else
                    filtobj = feval(ud.filterConstructor,...
                                ud.filterConstructorArgs{:});
                end
            catch
                filtobj = [];
            end
        end
    end
    if isempty(filtobj)
        error(message('dsp:dspLinkFVTool2Mask:invalidBlkInput'));
    end
end

% Get the Figure & FVTool handles
if dspIsFVToolOpen(hBlk)
    hFig = ud.fvtool;
    if closeFVTool
        close(hFig);
        ud.fvtool = [];
        % Cache UD back in the block
        set_param(hBlk, 'UserData', ud);
    else
        hFVT = getappdata(hFig,'FVToolObjectHandle');
        % Adding/Replacing filters
        if strcmpi(get(hFVT, 'LinkMode'), 'replace'),
            hFVT.setfilter(filtobj);
        else
            hFVT.addfilter(filtobj);
        end
        % Bring fvtool to front
        figure(hFig);
    end
else
    if strcmpi(mode,'create')
        hFVT = fvtoolwaddnreplace(filtobj);
        hFig = double(hFVT);
        setappdata(hFig, 'FVToolObjectHandle', hFVT);
        % Store the Figure Handle and not the handle to FVTool.
        ud.fvtool = hFig;
        % Cache UD back in the block
        set_param(hBlk, 'UserData', ud);
    end
end

% -------------------------------------------------------------------------
function filtobj = createCICfiltObj(ud)

filterInternals = ud.filterConstructorArgs{8};

% create mfilt object
filtobj = feval(ud.filterConstructor,ud.filterConstructorArgs{1:3});

switch filterInternals
    
    case 1  % Full precision
        % filtobj creation is complete
        
    case 2 % MinWordLengths
        filtobj.FilterInternals  = 'MinWordLengths';
        filtobj.OutputWordLength = ud.filterConstructorArgs{6};
        
    case 3 % SpecifyWordLengths
        filtobj.FilterInternals    = 'SpecifyWordLengths';
        filtobj.OutputWordLength   = ud.filterConstructorArgs{6};
        filtobj.SectionWordLengths = ud.filterConstructorArgs{4};
        
    case 4 % SpecifyPrecision
        filtobj.FilterInternals  = 'SpecifyPrecision';
        filtobj.OutputWordLength = ud.filterConstructorArgs{6};
        filtobj.OutputFracLength = ud.filterConstructorArgs{7};
        filtobj.SectionWordLengths = ud.filterConstructorArgs{4};
        filtobj.SectionFracLengths = ud.filterConstructorArgs{5};
end

