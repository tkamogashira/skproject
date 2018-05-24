function y = getIIRFilterDesignOutput(method ,filterType, N , Rp , Rs , Wlo ,Whi ,outputNum)
% getIIRFilterDesignOutput Helper function used to forward Digital IIR
% Filter Design to a Digital Filter block. 

% Copyright 2013 The MathWorks, Inc.

switch method
    case 'Butterworth'
        CmdStr = sprintf('butter(%d',N);
    case 'Chebyshev I'
        CmdStr = sprintf('cheby1(%d,%d',N,Rp);
    case 'Chebyshev II'
        CmdStr = sprintf('cheby2(%d,%d',N,Rs);
    case 'Elliptic'
        CmdStr = sprintf('ellip(%d,%d,%d',N,Rp,Rs);
    otherwise,
end

switch filterType
    case 'Lowpass',
        CmdStr = sprintf('%s,%d)',CmdStr,Wlo);
    case 'Highpass',
        CmdStr = sprintf('%s,%d,''high'')',CmdStr,Wlo);
    case 'Bandpass',
        CmdStr = sprintf('%s,[%d,%d])',CmdStr,Wlo,Whi);
    case 'Bandstop',
        CmdStr = sprintf('%s,[%d,%d],''stop'')',CmdStr,Wlo,Whi);
    otherwise,
end

[b,a] = eval(CmdStr);
% Return numerator or denominator
if outputNum == 1
    y = b;
else
    y = a;
end

end