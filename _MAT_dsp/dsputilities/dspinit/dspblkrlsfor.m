function dspblkrlsfor()
% DSPBLKRLSFOR Mask dynamic dialog function for RLS adaptive filter
% for loop
% Copyright 1995-2007 The MathWorks, Inc.

updateweights(gcb);

%-----------------------------------------------------
function updateweights(blk)

weights = get_param(blk, 'weights_for');

%update weight output
if (strcmp(weights, 'off'))
    %remove weights output
    if (exist_block(blk, 'Wts'))
        delete_line(blk, 'Update/1', 'Wts/1');
        delete_block([blk '/Wts']);
    end
else
    if ~(exist_block(blk, 'Wts'))
        add_block('built-in/Outport', [blk, '/Wts'], 'Position', [490 98 520 112]);
        add_line(blk, 'Update/1', 'Wts/1');
    end
end

% [EOF] dspblkrlsfor.m
