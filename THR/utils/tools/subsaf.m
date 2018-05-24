function subsaf
% SUBSAF - show all figures and tile them next to each other
%   SUBSAF makes all existing figures visible, provided their 'Visible'
%   property is 'on'. It places these figures in a tiled configuration.
% 
%   See also SAF, SUBFIG, AA, AAA, DD, FF.

fh = sort(findobj('type', 'figure', 'visible', 'on'));
if isempty(fh), return; end %no figures

N = numel(fh);

if N > 1,
    Y = ceil(sqrt(N));
    X = Y;
    if Y*(Y-1) >= N & N>2,
        X = Y-1; 
    end
    for ii = 1:N
        subfig(fh(ii), X, Y,ii);
        figure(fh(ii));
    end
end

figure(fh(end));
    