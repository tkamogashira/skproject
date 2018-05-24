function alpha = determinealpha(h,Astop)
%DETERMINEALPHA   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

if Astop >= 50,
    alpha = 0.1102*(Astop - 8.7);
elseif Astop < 50 && Astop > 21,
    alpha = 0.5842*(Astop - 21)^.4 + 0.07886*(Astop - 21);
elseif Astop <= 21,
    alpha = 0;
end

% [EOF]
