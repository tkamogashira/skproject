%
%	Correction of ELC, MAF, MAP
%	IRINO Toshio
%	18 Mar 96
%	29 Aug 96 	renamed AFShapeCrct -> OutMidCrct
%	14 May 97 	option of Direct Output
%
%	It produces interpolated points for the ELC/MAF/MAP correction.
%
%	Reference:
%	Glassberg and Moore (1990)
%	"Derivation of auditory filter shapes from notched noise data"
%	Hearing Research, 47 , pp.103-138.
%
%	function [CrctLinPwr, frqNpnts, CrctdB] = OutMidCrct(StrCrct,Npnts,SR);
%	INPUT	StrCrct: String for Correction ELC/MAF/MAP
%		Npnts:	 Number of data points, if zero, then direct out.
%		SR: 	 Sampling Rate
%		SwPlot:  Switch for plot
%	OUTPUT  CrctLinPwr : Correction value in LINEAR POWER 
%		frqNpnts: Corresponding Frequency at the data point
%		CrctdB: Correction value in dB
%
function [CrctLinPwr, frqNpnts, CrctdB] = OutMidCrct(StrCrct,Npnts,SR,SwPlot);

if nargin < 1, help OutMidCrct; end;
if nargin < 2, Npnts = 0; end;
if nargin < 3, SR = 32000; end; 
if nargin < 4, SwPlot = 1; end; 

f1 = [	20, 25, 30, 35, 40, 45, 50, 55, 60, 70, 80, 90, 100, ...
	125, 150, 177, 200, 250, 300, 350, 400, 450, 500, 550, ...
	600, 700, 800, 900, 1000, 1500, 2000, 2500, 2828, 3000, ...
	3500, 4000, 4500, 5000, 5500, 6000, 7000, 8000, 9000, 10000, ...
	12748, 15000];

ELC = [ 31.8, 26.0, 21.7, 18.8, 17.2, 15.4, 14.0, 12.6, 11.6, 10.6, ...
	9.2, 8.2, 7.7, 6.7, 5.3, 4.6, 3.9, 2.9, 2.7, 2.3, ...
	2.2, 2.3, 2.5, 2.7, 2.9, 3.4, 3.9, 3.9, 3.9, 2.7, ...
	0.9, -1.3, -2.5, -3.2, -4.4, -4.1, -2.5, -0.5, 2.0, 5.0, ...
	10.2, 15.0, 17.0, 15.5, 11.0, 22.0];

MAF = [ 73.4, 65.2, 57.9, 52.7, 48.0, 45.0, 41.9, 39.3, 36.8, 33.0, ...
	29.7, 27.1, 25.0, 22.0, 18.2, 16.0, 14.0, 11.4, 9.2, 8.0, ...
	 6.9,  6.2,  5.7,  5.1,  5.0,  5.0,  4.4,  4.3, 3.9, 2.7, ...
	 0.9, -1.3, -2.5, -3.2, -4.4, -4.1, -2.5, -0.5, 2.0, 5.0, ...
	10.2, 15.0, 17.0, 15.5, 11.0, 22.0]; 

f2  = [  125,  250,  500, 1000, 1500, 2000, 3000,  ...
	4000, 6000, 8000,10000,12000,14000,16000];
MAP = [ 30.0, 19.0, 12.0,  9.0, 11.0, 16.0, 16.0, ...
	14.0, 14.0,  9.9, 24.7, 32.7, 44.1, 63.7];

frqTbl = [];
CrctTbl = [];
if length(StrCrct)==3
  if     strcmp(upper(StrCrct(1:3)),'ELC'), frqTbl = f1'; CrctTbl = ELC';
  elseif strcmp(upper(StrCrct(1:3)),'MAF'), frqTbl = f1'; CrctTbl = MAF';
  elseif strcmp(upper(StrCrct(1:3)),'MAP'), frqTbl = f2'; CrctTbl = MAP';
  else   error('Specifiy correction: ELC / MAF / MAP or NO correction.'); 
  end;
elseif length(StrCrct)~=2,
  error('Specifiy correction: ELC / MAF / MAP or NO correction.'); 
end;

str1 = '';
if Npnts <= 0,
  str1 = 'No interpolation. Output original table.';
  frqNpnts = frqTbl; 
  CrctdB = CrctTbl; 
else
  frqNpnts = (0:Npnts-1)'/Npnts * SR/2;
  if strcmp(upper(StrCrct(1:2)), 'NO'),
    CrctdB = zeros(size(frqNpnts));
  else
    str1 = 'Spline interpolated value in equal frequency spacing.';
    CrctdB = spline(frqTbl,CrctTbl,frqNpnts);	
  end;
end;

if SwPlot == 1, 
   disp(['*** Outer/Middle Ear Transfer Function ( ' ...
		upper(StrCrct) ' Correction ) ***']);
   disp(str1);
   plot(frqTbl,CrctTbl,frqNpnts,CrctdB,'o'); 
end;

CrctLinPwr = 10.^(-CrctdB/10); 	% in Linear Power


