%% Parametric Audio Equalizer Data Specification
% Specifies parameter data used by dspparameq.mdl

%   Copyright 2008-2011 The MathWorks, Inc.

%% Specify Input and Output Code Generation Attributes
in = mpt.Signal;
 in.CoderInfo.StorageClass = 'ExportedGlobal';

out = mpt.Signal;
 out.CoderInfo.StorageClass = 'ExportedGlobal';

%% Specify Coefficient Values Code Generation Attributes
Fs = 48000;
% Band 1
tmpFilt = design(fdesign.parameq(...
           ['N,'  'F0,' 'BW,' 'Gref,' 'G0,'  'GBW'],...
              2,  763.9, 2292,     0,    5,  3.535, Fs));
[b,a] = tf(tmpFilt);
    
CoeffsMatrix1 = mpt.Parameter;
 CoeffsMatrix1.Value = [b(1) b(2) b(3) a(2) a(3)]';
 CoeffsMatrix1.Description = getDesignInfoFromDfilt(tmpFilt);
 CoeffsMatrix1.CoderInfo.StorageClass = 'Custom';
 CoeffsMatrix1.CoderInfo.CustomStorageClass = 'Global';
 CoeffsMatrix1.CoderInfo.CustomAttributes.DefinitionFile = 'biquad_coeffs.c';
 CoeffsMatrix1.CoderInfo.CustomAttributes.HeaderFile = 'biquad_coeffs.h';

% Band 2
tmpFilt = design(fdesign.parameq(...
           ['N,'  'F0,' 'BW,' 'Gref,' 'G0,' 'GBW'],...
              2,  1528, 2292,     0,    3,  2.12, Fs));
[b,a] = tf(tmpFilt);

CoeffsMatrix2 = mpt.Parameter;
 CoeffsMatrix2.Value = [b(1) b(2) b(3) a(2) a(3)]';
 CoeffsMatrix2.Description = getDesignInfoFromDfilt(tmpFilt);
 CoeffsMatrix2.CoderInfo.StorageClass = 'Custom';
 CoeffsMatrix2.CoderInfo.CustomStorageClass = 'Global';
 CoeffsMatrix2.CoderInfo.CustomAttributes.DefinitionFile = 'biquad_coeffs.c';
 CoeffsMatrix2.CoderInfo.CustomAttributes.HeaderFile = 'biquad_coeffs.h';

 % Band 3
tmpFilt = design(fdesign.parameq(...
           ['N,'  'F0,' 'BW,' 'Gref,' 'G0,'   'GBW'],...
              2,  2292, 2292,     0,   -5, -3.535, Fs));
[b,a] = tf(tmpFilt);

CoeffsMatrix3 = mpt.Parameter;
 CoeffsMatrix3.Value = [b(1) b(2) b(3) a(2) a(3)]';
 CoeffsMatrix3.Description = getDesignInfoFromDfilt(tmpFilt);
 CoeffsMatrix3.CoderInfo.StorageClass = 'Custom';
 CoeffsMatrix3.CoderInfo.CustomStorageClass = 'Global';
 CoeffsMatrix3.CoderInfo.CustomAttributes.DefinitionFile = 'biquad_coeffs.c';
 CoeffsMatrix3.CoderInfo.CustomAttributes.HeaderFile = 'biquad_coeffs.h';

clear Fs tmpFilt b a
