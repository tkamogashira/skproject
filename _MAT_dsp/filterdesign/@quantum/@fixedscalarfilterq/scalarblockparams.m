function p = scalarblockparams(this)
%SCALARBLOCKPARAMS   Get the block parameters.

%   Author(s): J. Schickler
%   Copyright 1999-2011 The MathWorks, Inc.
%     

s = internalsettings(this);

paramWL = num2str(s.CoeffWordLength);
paramFL = num2str(s.CoeffFracLength);
if this.Signed
    paramSign = '1';
else
    paramSign = '0';
end
p.ParamDataTypeStr = ['fixdt(' paramSign ',' paramWL ',' paramFL ')'];

outWL = num2str(s.OutputWordLength);
outFL = num2str(s.OutputFracLength);
p.OutDataTypeStr = ['fixdt(1,' outWL ',' outFL ')'];
p.RndMeth     = rndmeth(this);
p.DoSatur     = dosatur(this);


%----------------------------------------------------------------------
function RndMeth = rndmeth(this)
% Convert from quantizer/roundmode to RndMeth property of the block.

switch this.Roundmode
    case 'fix'
        RndMeth = 'Zero';
    case 'floor'
        RndMeth = 'Floor';
    case 'ceil'
        RndMeth = 'Ceiling';
    case 'round'
        RndMeth = 'Round';
    case 'convergent'
        RndMeth = 'Convergent';
    case 'nearest'
        RndMeth = 'Nearest';
end

%----------------------------------------------------------------------
function DoSatur = dosatur(this)
% Convert from quantizer/overflowmode to DoSatur property of the block.

switch this.Overflowmode
case 'saturate'
    DoSatur = 'on';
case 'wrap'
    DoSatur = 'off';
end

% [EOF]
