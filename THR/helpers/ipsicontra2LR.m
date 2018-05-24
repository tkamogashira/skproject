function C = ipsicontra2LR(C, EXP);
% ipsicontra2LR - convert ipsi/contra channel spec to L/R char
%    ipsicontra2LR(C, EXP), where C is a char string abbreviating 'ipsi' or
%    'contra', and EXP is a non-void experiment object, returns 'L' or 'R'
%    depending on the recordings side of the experiment. If C is a
%    Left/Right channel spec, it is abbreviated to L/R.
%
%    See also ITD2delay.

[C, Mess] = keywordMatch(lower(C), {'ipsi' 'contra' 'left' 'right'}, 'DA-channel specification');
error(Mess);
if isequal('left', C), 
    C = 'L';
elseif isequal('right', C),
    C = 'R';
else, % C/I
    IpsiIsLeft = isequal('Left', EXP.RecordingSide);
    CisIpsi = isequal('ipsi', C);
    if xor(IpsiIsLeft, CisIpsi), C = 'R';
    else, C = 'L';
    end
end






