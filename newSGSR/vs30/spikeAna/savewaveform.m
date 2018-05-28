function savewaveform(st);
% SAVEWAVEFORM - save waveform in export dir
%   SYNTAX: saveWaveforn(st)
%   where st is a struct from repWaveform;
%
%   See alsoRepWaveform

postfix = st.cond;
if ~ischar(postfix),
   postfix = ['S' num2str(postfix)];
end
fname = [exportdir '\' st.DataFileName '-' postfix '.mat'];
save(fname, 'st');