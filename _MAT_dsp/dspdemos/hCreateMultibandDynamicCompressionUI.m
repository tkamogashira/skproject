% Create GUI to tune simulation parameters of model 

% Copyright 2013 The MathWorks, Inc. 

screen = get(0,'ScreenSize');
outerSize = min((screen(4)-40)/2, 512);
param = struct([]);
% Create the GUI and synchronize with block parameter values
blockName = 'multibanddynamiccompression/Dynamic Compression/Compressor Bank/Compressor1';
param(1).Name = 'Band 1 Compression Factor';
param(1).InitialValue = str2double(get_param(blockName,'CompressionRatio'));
param(1).Limits =  [1, 100];
param(1).BlockName = blockName;
param(1).ParameterName = 'CompressionRatio';
param(2).Name = 'Band 1 Threshold (dB)';
param(2).InitialValue =  str2double(get_param(blockName,'Threshold'));
param(2).Limits = [-80, 0];
param(2).BlockName = blockName; 
param(2).ParameterName = 'Threshold';
param(3).Name = 'Band 1 Attack Time (sec)';
param(3).InitialValue =   str2double(get_param(blockName,'AttackTime'));
param(3).Limits =  [0, 2000];
param(3).BlockName = blockName;
param(3).ParameterName = 'AttackTime';
param(4).Name = 'Band 1 Release Time (sec)';
param(4).InitialValue =  str2double(get_param(blockName,'ReleaseTime'));
param(4).Limits = [0, 2000];
param(4).BlockName = blockName; 
param(4).ParameterName = 'ReleaseTime';

blockName = 'multibanddynamiccompression/Dynamic Compression/Compressor Bank/Compressor2';
param(5).Name = 'Band 2 Compression Factor';
param(5).InitialValue =  str2double(get_param(blockName,'CompressionRatio'));
param(5).Limits =  [1, 100];
param(5).BlockName = blockName;
param(5).ParameterName = 'CompressionRatio';
param(6).Name = 'Band 2 Threshold (dB)';
param(6).InitialValue =  str2double(get_param(blockName,'Threshold'));
param(6).Limits = [-80, 0];
param(6).BlockName = blockName; 
param(6).ParameterName = 'Threshold';
param(7).Name = 'Band 2 Attack Time (sec)';
param(7).InitialValue =  str2double(get_param(blockName,'AttackTime'));
param(7).Limits =  [0, 2000];
param(7).BlockName = blockName;
param(7).ParameterName = 'AttackTime';
param(8).Name = 'Band 2 Release Time (sec)';
param(8).InitialValue =  str2double(get_param(blockName,'ReleaseTime'));
param(8).Limits = [0, 2000];
param(8).BlockName = blockName; 
param(8).ParameterName = 'ReleaseTime';

blockName = 'multibanddynamiccompression/Dynamic Compression/Compressor Bank/Compressor3';
param(9).Name = 'Band 3 Compression Factor';
param(9).InitialValue =  str2double(get_param(blockName,'CompressionRatio'));
param(9).Limits =  [1, 100];
param(9).BlockName = blockName;
param(9).ParameterName = 'CompressionRatio';
param(10).Name = 'Band 3 Threshold (dB)';
param(10).InitialValue =  str2double(get_param(blockName,'Threshold'));
param(10).Limits = [-80, 0];
param(10).BlockName = blockName; 
param(10).ParameterName = 'Threshold';
param(11).Name = 'Band 3 Attack Time (sec)';
param(11).InitialValue =  str2double(get_param(blockName,'AttackTime'));
param(11).Limits =  [0, 2000];
param(11).BlockName = blockName;
param(11).ParameterName = 'AttackTime';
param(12).Name = 'Band 3 Release Time (sec)';
param(12).InitialValue =  str2double(get_param(blockName,'ReleaseTime'));
param(12).Limits = [0, 2000];
param(12).BlockName = blockName; 
param(12).ParameterName = 'ReleaseTime';

blockName = 'multibanddynamiccompression/Dynamic Compression/Compressor Bank/Compressor4';
param(13).Name = 'Band 4 Compression Factor';
param(13).InitialValue=  str2double(get_param(blockName,'CompressionRatio'));
param(13).Limits =  [1, 100];
param(13).BlockName = blockName;
param(13).ParameterName = 'CompressionRatio';
param(14).Name = 'Band 4 Threshold (dB)';
param(14).InitialValue =  str2double(get_param(blockName,'Threshold'));
param(14).Limits = [-80, 0];
param(14).BlockName = blockName; 
param(14).ParameterName = 'Threshold';
param(15).Name = 'Band 4 Attack Time (sec)';
param(15).InitialValue =  str2double(get_param(blockName,'AttackTime'));
param(15).Limits =  [0, 2000];
param(15).BlockName = blockName;
param(15).ParameterName = 'AttackTime';
param(16).Name = 'Band 4 Release Time (sec)';
param(16).InitialValue =  str2double(get_param(blockName,'ReleaseTime'));
param(16).Limits = [0, 2000];
param(16).BlockName = blockName; 
param(16).ParameterName = 'ReleaseTime';

% Create UI. Clicking reset button calls resetMultibandCompressor
hgui = HelperCreateParamTuningUI(param, 'Multiband Dynamic Compression Example','ResetCallback',@()resetMultibandCompressor);

set(hgui,'Position',[57   221   971   902]);