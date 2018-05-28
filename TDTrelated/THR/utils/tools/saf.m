function saf
% SAF - show all figures
%   SAF makes all existing figures visible, provided their 'Visible'
%   property is 'on'.
% 
%   See also AA, AAA, DD, FF.

FH = findobj('type', 'figure', 'visible', 'on');
for fh = sort(FH(:).'),
    figure(fh);
end


