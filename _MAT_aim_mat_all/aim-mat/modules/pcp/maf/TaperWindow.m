%
%	Taper Window Generator for signal onset/offset
%	7 Apr. 1993
%	29 Aug. 96
%	IRINO Toshio
%
%	function [TaperWin, TypeTaper] = ...
%		TaperWindow(LenWin,TypeTaper,LenTaper,RangeSigma,SwPlot)
%	INPUT	LenWin    : Length of Window (Number of points)
%		TypeTaper : Type of Taper (KeyWords of 3 letters)
%		  (Hamming, Hanning (=cosine^2), Blackman, Gauss, Line)
%		LenTaper  : Length of Taper  (Number of points)
%		RangeSigma: Range in Sigma (default: 3) for Gauss
%		SwPlot    : 0) Omit plotting,  1) Plot Taper
%	OUTPUT  TaperWin  : Taper Window Points (max==1);
%		TypeTaper : Type of Taper (Full Name)
%
function [TaperWin, TypeTaper] = ...
	TaperWindow(LenWin,TypeTaper,LenTaper,RangeSigma,SwPlot)

if nargin < 2,
help TaperWindow
error([ 'Specify Type of Taper : ' ...
	' Hamming, Hanning (=cosine^2), Blackman, Gauss, Line ']);
%TaperWin = ones(1,LenWin);
%return;
end;

if nargin < 3, LenTaper = fix(LenWin/2); end;
if nargin < 4, RangeSigma = 3; end;

if  LenTaper*2 >= LenWin, 
	disp('Caution (TaperWindow.m) : No flat part. ');
	if LenTaper ~= fix(LenWin/2),
	disp('Caution (TaperWindow.m) : LenTaper <-- fix(LenWin/2)');
	end;
	LenTaper = fix(LenWin/2); 
end;

if nargin < 5, SwPlot = 0; end;	% changing default Swplot 29 Aug. 96

%TypeTaper = lower(TypeTaper(1:3));

if	upper(TypeTaper(1:3)) == 'HAM', 
	Taper = hamming(LenTaper*2)';
	TypeTaper = 'Hamming';
elseif	upper(TypeTaper(1:3)) == 'HAN' | upper(TypeTaper(1:3)) == 'COS', 
	Taper = hanning(LenTaper*2)';
	TypeTaper = 'Hanning/Cosine';
elseif	upper(TypeTaper(1:3)) == 'BLA', 
	Taper = blackman(LenTaper*2)';
	TypeTaper = 'Blackman';
elseif	upper(TypeTaper(1:3)) == 'GAU',  
	if length(RangeSigma) == 0, RangeSigma = 3; end;
	nn = -LenTaper+0.5:1:LenTaper-0.5;
	Taper = exp(-(RangeSigma*nn/LenTaper).^2 /2);
	TypeTaper = 'Gauss';
else	Taper = [1:LenTaper LenTaper:-1:1]/LenTaper;  % 'line', 
	TypeTaper = 'Line';
end;

%plot(Taper)
%size(Taper);
LenTaper = fix(LenTaper);
TaperWin = [	Taper(1:LenTaper) ones(1,LenWin-LenTaper*2) ...
		Taper(LenTaper+1:LenTaper*2)];

if SwPlot == 1,

plot(TaperWin)
xlabel('Points');
ylabel('Amplitude');
title(['TypeTaper = ' TypeTaper] );

end;

