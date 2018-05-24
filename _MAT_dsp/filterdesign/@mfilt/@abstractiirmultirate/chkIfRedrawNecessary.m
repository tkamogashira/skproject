function [redraw,h] = chkIfRedrawNecessary(Hd,h,sys,filter_structure,rate_factor)
%CHKIFREDRAWNECESSARY checks to see whether the FILTER blk needs to be redrawn
%   [redraw,nstages_equal] = CHKIFREDRAWNECESSARY(Hd,h,sys)
%   redraw ->indicates whether the FILTER blk needs to be redrawn

%   Copyright 2007-2010 The MathWorks, Inc.

redraw=true;

% If model file name is Filter and we are looking for a subsystem named Filter
% find_system will return 'Filter' and 'Filter/Filter' and hence the chk below
% Also for eg:If we are looking for Stage1 inside Stage1 of a Filter find_system
% will return 'Filter/Stage1' and 'Filter/Stage1/Stage1' and hence the chk

if ~any(strcmp(h,sys))
    h={};
end

if ~isempty(h) % if FILTER block is present
    s = get_param(sys,'UserData');
    if isfield(s, 'filter')
        last_filter = s.filter;
    else
        last_filter = s;
    end
    
    if ~isempty(last_filter)
        if ~ischar(last_filter) || ~strcmpi(last_filter, filter_structure)
            delete_block(sys);
        elseif Hd.(rate_factor)~=s.RateChangeFactor, % if both are mfilt.iirinterp chk the interpolation factor
                delete_block(sys);
        else
            redraw=false;
        end
    else
        delete_block(sys);
    end
end
% [EOF]
