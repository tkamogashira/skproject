function [freq, freqstr] = ExpandFcycle(FcycType, Chan, Fcyc, ds);
% ExpandFcycle - converts Fcycle specification to frequency in Hz
%   Note: freq is always a column vector of length ds.Nsub
%
%   See also UCcyc, UCcycParam and ExploreFcycle.

if isequal('auto', FcycType), % use ExploreFcycle to get default values
   [ifc icc fstr cstr defaultstr] = exploreFcycle(ds);
   FcycType = defaultstr{1};
   Chan = defaultstr{2};
   Fcyc = 137;
end

freqstr = '';
switch FcycType,
case 'carrier', freq = ds.fcar; freqstr = 'carrier';
case 'modulation', freq = ds.fmod; freqstr = 'mod';
case 'other', freq = Fcyc; freqstr = [num2sstr(freq) ' Hz'];
otherwise, error('invalid FcycType value');
end

switch Chan,
case 'left', freq = freq(:,1); freqstr = ['left ' freqstr ];
case 'right', freq = freq(:,end); freqstr = ['right ' freqstr];
case 'beat', 
   if isequal(0,ds.DAchan),
      if isequal(1,size(freq,2)), freq = [freq freq]; end
      freq = abs(diff(freq,1,2)); freqstr = [freqstr ' beat'];
   elseif isequal(1,ds.DAchan)
      freq = freq(1); freqstr = [freqstr ' left'];
   elseif isequal(2,ds.DAchan)
      freq = freq(end); freqstr = [freqstr ' right'];
   end
case 'none', 
otherwise, error('invalid Chan value');
end % switch/case

if size(freq,1)==1,
   freq = repmat(freq, ds.Nsub, 1);
end

if ~isequal('other', FcycType),
   fr = unique(freq(find(~isnan(freq))));
   N = length(fr);
   if N>1, fff = num2sstr(fr([1 end]));
   else, fff = num2sstr(fr);
   end;
   fff = strsubst(fff,' ','..'); 
   freqstr = strvcat(freqstr, [' =' fff ' Hz']);
end



