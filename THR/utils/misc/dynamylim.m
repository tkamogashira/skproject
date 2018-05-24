function dynamylim(Ah, Str, M);
% dynamylim - set ylim according to the data
%    dynamylim(Ah, 'min-10 max+5')
%    sets the y-limits of axes with handle Ah to [Ymin-10, Ymax+5],
%    where Ymin, and Ymax are the grand minimum and maximum of all ydata
%    shown in the axes system. 
%    Other examples:
%        dynamylim(Ah, 'max-80 max+1')
%
%    dynamylim(Ah, 'min-10 max+5', M)
%    rounds the limits to the nearest multiple of M.
%
%    See also YLIM.

M = arginDefaults('M');

hl = findobj(Ah,'type', 'line', 'visible', 'on');
Ymin = inf;
Ymax = -inf;
for ii=1:numel(hl),
    yd = get(hl(ii), 'ydata');
    Ymin = min(Ymin, min(yd(:)));
    Ymax = max(Ymax, max(yd(:)));;
end
if Ymin>=Ymax, return; end
Str = trimspace(upper(Str));
Str = strrep(Str, 'MAX', ' Ymax');
Str = strrep(Str, 'MIN', ' Ymin');
Str = ['[' Str ']'];
YL = eval(Str);

if ~isempty(M),
    YL = M*round(YL/M);
end

ylim(gca,YL);

