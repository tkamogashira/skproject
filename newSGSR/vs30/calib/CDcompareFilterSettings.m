function cf = CDcompareFilterSettings(CD1,CD2);
% CDcompareFilterSettings - check if two CalData/calstim sets have same fsam & filter settings
if nargin<2, % compare with current SGSR settings
   global SGSR
   CD2.calibParams.SampleFreqs = SGSR.samFreqs;
   CD2.calibParams.maxSampleRatio = SGSR.maxSampleRatio;
end
cp1 = getFieldOrDef(CD1, 'calibParams', []);
if isempty(cp1), cp1 = CD1.params; end;
cp2 = getFieldOrDef(CD2, 'calibParams', []);
if isempty(cp2), cp2 = CD2.params; end;
cf = isequal(cp1.SampleFreqs, cp2.SampleFreqs) ...
   & isequal(cp1.maxSampleRatio, cp2.maxSampleRatio);


