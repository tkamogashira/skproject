function boolean = iscolor(c)
%ISCOLOR  True if input is a color.
%   ISCOLOR(C) is 1 if c is a valid colorspec and 0 else.
%   Valid colorspecs are: 'r','g','b','w',... (a single character).
%                         [r g b] where r,g and b are scalars in [0,1]
%                         n-by-3 matrix with elements in the range [0,1]

%B. Van de Sande 07-04-2004 (adapted from version by T. Krauss)

if ischar(c),
    ColorStr = {'y' 'm' 'c' 'r' 'g' 'b' 'w' 'k'};  % see 'help plot'
    boolean = ismember(c, ColorStr);
else
    if any(abs(imag(c)) > 0.0), boolean = 0;
    elseif (min(size(c)) > 1),
        if (size(c,2)~=3), boolean = 0;
        else, boolean = max(max(c))<=1.0 & min(min(c))>=0.0; end
    else, boolean = max(max(c))<=1.0 & min(min(c))>=0.0; end
end