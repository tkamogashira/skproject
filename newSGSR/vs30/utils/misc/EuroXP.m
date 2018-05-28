function [y, B] = EuroExp(B0, Bm, r, plotArg)
% EuroExp - spaarpotfunctie
%  syntax: [y, B] = EuroExp(B0, Bm, r)
%  inputs:
%   B0: inleg
%   Bm: maandelijkse premie
%   r: netto rendement in % op jaarbasis
%  outputs:
%   y: tijdvector in jaren, van 0 tot 30 jaar in stappen van 1 mnd
%   B: bedrag op tijdstip y
%
%   Zonder output args wordt het verloop geplot.
%   plot(y,B) plot de groei v/h vermogen aan.
% 
%   Als r een vector is, wordt dit geinterpreteerd als een
%   over de 30 jaar varierend rendement mbv lineaire interpolatie.

if nargin<4, plotArg=''; end % default plot argument: new plot

Nm = 30*12; % # maanden looptijd
if length(r)==1, r = [r r]; end
% interpoleer r naar maandelijxe resolutie
rtijd = linspace(0,Nm,length(r));
r = interp1(rtijd,r,0:Nm);

groeifactor = (1+r/100).^(1/12); % groeifactor per maand

% de groei wordt beschreven door:
%    B(1) = B0
%    B(n+1) = g(n)*B(n)+Bm
% Voor zo'n kleine berekening is vectoriseren teveel eer, dus gewoon een for loop.
B = zeros(Nm+1,1);
B(1) = B0;
for im=1:Nm,
   B(im+1) = groeifactor(im)*B(im)+Bm;
end
y = (0:Nm)/12; % jaar->maand conversie
if nargout<1,
   if ~isempty(plotArg), hold on; else, plotArg = 'b'; end
   plot(y,B,plotArg); hold off;
   xlabel('Looptijd (jaren)');
   Ylabel('Vermogen');
   disp(['Eindvermogen (30 j): ' num2str(B(end))]);
   figure(gcf);
end

