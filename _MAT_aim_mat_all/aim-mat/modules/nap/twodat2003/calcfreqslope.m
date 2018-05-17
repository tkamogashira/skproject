%  
% function adjacent_band_level=calcfreqslope(cf,af);
%
%   INPUT VALUES:
% 		
%
%   RETURN VALUE:
%		
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



function adjacent_band_level=calcfreqslope(cf,af,b);
% function used to calculate the relative amplitudes in adjacent GTFBs
%e.g to calculate the level in 2000Hz critical band due to excitation 
%in 1000Hz critical band calcfreqslope(2000,1000);


n=4;
%ERB = 24.7+0.108.*cf;
[dummy ERB]=Freq2ERB(cf);
B=b.*ERB;


h_cf=abs(3.*(B./(2.*pi.*i.*(cf-cf)+2.*pi.*B)).^n);
h_af=abs(3.*(B./(2.*pi.*i.*(af-cf)+2.*pi.*B)).^n);

adjacent_band_level=h_af./h_cf;
adjacent_band_level=20.*log10(adjacent_band_level);


