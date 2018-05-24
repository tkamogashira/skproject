function HelperSpectrumAnalyzerMeasurements(command)
%HelperSpectrumAnalyzerMeasurement show/hide various windows for 
% the SpectrumAnalyzerMeasurementsExample.
%
% This function HelperSpectrumAnalyzerMeasurement is only in
% support of SpectrumAnalyzerMeasurementsExample.
% It may be removed or change in a future release.

% Copyright 2013 The MathWorks, Inc.
switch command
  case 'openModel'
    open_system('SpectrumAnalyzerMeasurementsExample');
    HelperSpectrumAnalyzerMeasurements('closePlots');
  case 'closePlots'
    close_system('SpectrumAnalyzerMeasurementsExample/Spectrogram');
    close_system('SpectrumAnalyzerMeasurementsExample/Peak Finder');
    close_system('SpectrumAnalyzerMeasurementsExample/CCDF');
    close_system('SpectrumAnalyzerMeasurementsExample/ACPR');
    close_system('SpectrumAnalyzerMeasurementsExample/Intermodulation Distortion');
    close_system('SpectrumAnalyzerMeasurementsExample/Harmonic Distortion');
  case 'openAmplifier'
    open_system('SpectrumAnalyzerMeasurementsExample/Amplifier1','force');
  case 'runModel'
    set_param('SpectrumAnalyzerMeasurementsExample','StopTime','0.01');
    sim('SpectrumAnalyzerMeasurementsExample');
    set_param('SpectrumAnalyzerMeasurementsExample','StopTime','Inf');
    HelperSpectrumAnalyzerMeasurements('closePlots');
  case 'showHarmonicDistortion'
    openForPublish('SpectrumAnalyzerMeasurementsExample/Harmonic Distortion');    
  case 'showIntermodulationDistortion'
    openForPublish('SpectrumAnalyzerMeasurementsExample/Intermodulation Distortion');
  case 'showACPR'
    openForPublish('SpectrumAnalyzerMeasurementsExample/ACPR');
  case 'showCCDF'
    openForPublish('SpectrumAnalyzerMeasurementsExample/CCDF');
  case 'showSpectrogram'
    openForPublish('SpectrumAnalyzerMeasurementsExample/Spectrogram');
  case 'showPeakFinder'
    openForPublish('SpectrumAnalyzerMeasurementsExample/Peak Finder');
  case 'closeModel'
    close_system('SpectrumAnalyzerMeasurementsExample','force');
end

function openForPublish(blk)
open_system(blk,'force');
