function PB = PBTest(PB, PropName, Mode)
%PBTEST  test function for property bag object.

%B. Van de Sande 14-05-2004

if (nargin == 0), 
    %Create property bag and add properties ...
    PB = Add(PropertyBag, 'plot', 'char', [], {'on', 'off'}, 'on');
    PB = Add(PB, 'xlimmode', 'char', [], {'auto', 'manual'}, 'auto');
    PB = Add(PB, 'xlim', 'double', 0, [], []);
    PB = Add(PB, 'xlim', 'double', 2, []);
    PB = Add(PB, 'ylim', 'char', [], 'auto', 'auto');
    PB = Add(PB, 'ylim', 'double', 2, []);
    PB = Add(PB, 'linewidth', 'double', 1, [0 +Inf], 1.5);
    PB = Add(PB, 'linecolor', 'char', [], {'r', 'g', 'b', 'i', 'c', 'm', 'y', 'k'}, 'b');
    PB = Add(PB, 'linecolor', 'double', 3, [0 1]);
    %Add relations ...
    PB = Add(PB, 'xlimmode', str2func(mfilename));
    PB = Add(PB, 'xlim', str2func(mfilename));
elseif strcmpi(Mode, 'relation'),
    switch PropName,
    case 'xlimmode',
        if strcmpi(get(PB, 'XLimMode'), 'auto'), PB = set(PB, 'norelations', 'XLim', []); end
    case 'xlim',
        if isempty(get(PB, 'XLim')), PB = set(PB, 'norelations', 'XLimMode', 'auto');
        else, PB = set(PB, 'norelations', 'XLimMode', 'manual'); end    
    end
elseif strcmpi(Mode, 'constraint'), end