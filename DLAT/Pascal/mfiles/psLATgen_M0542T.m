% psLATgen_M0542T
% popscript to study effect of SPL on delay
% PXJ 8/2005
%
% this version of the script contains tones at cf-data from M0542
% also in this version, in the resulting struct array DLAT, three fields are added, 'slope', 'cf' and 'fibernr'
% containing respectively the slope (as estimated using linear regression with polyfit()),
% the number of the fiber and the characteristic frequency
% 
%
% TF 03/09/2005

echo on;

D = struct([]);

% fields that need to be retrieved
XFieldName = 'ds2.discernvalue';
YFieldName = 'primpeak.delay';                                                                                                      
                                                                                                                                              
                                                                                                                                            
%M0542--------------------------------------------------------------------------------------------------------------

%Fiber 1, high cf
List = struct('filename','M0542','iseqp',num2cell([-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]),'isubseqp',num2cell([4,5,6,7,8,9,10,11,12,13,14,15,16,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,25,30,35,40,45,50,55,60,65,70,75,80,85]));
T = GenWFPlot(List, 4, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -1, subseq 14
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];
                                                                                          
%Fiber 2,high cf (!see book: missing some spikes at 70, 75 dB)
List = struct('filename','M0542','iseqp',num2cell([-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2]),'isubseqp',num2cell([3,4,5,6,7,8,9,10,11,12,13,14]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([15,20,25,30,35,40,45,50,55,60,65,70]));
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -2, subseq 14
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

%Fiber 3,high cf
List = struct('filename','M0542','iseqp',num2cell([-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3]),'isubseqp',num2cell([6,7,8,9,10,11,12,13,14,15,16,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,35,40,45,50,55,60,65,70,75,80,85]));
T = GenWFPlot(List, 4, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -3, subseq 14
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

%Fiber 5
List = struct('filename','M0542','iseqp',num2cell([-7,-7,-7,-7,-7,-7,-7,-7,-7,-7,-7,-7,-7,-7,-7]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,15,20,25,30,35,40,45,50,55,60,65,70,75,80]));
T = GenWFPlot(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -7, subseq 13
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

if 0 %see WFplot
%Fiber 6, high cf
List = struct('filename','M0542','iseqp',num2cell([-11,-11,-11,-11,-11,-11,-11,-11,-11,-11,-11,-11,-11,-11]),'isubseqp',num2cell([3,4,5,6,7,8,9,10,11,12,13,14,15,16]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,25,30,35,40,45,50,55,60,65,70,75,80,85]));
T = GenWFPlot(List, 4, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -11, subseq 13
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];
end

%Fiber 7 (broad thr-curve)
List = struct('filename','M0542','iseqp',num2cell([-12,-12,-12,-12,-12,-12,-12,-12,-12,-12,-12,-12,-12,-12]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,25,30,35,40,45,50,55,60,65,70,75,80,85]));
T = GenWFPlot(List, 4, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -12, subseq 11
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

%Fiber 8 (broad thr-curve)
List = struct('filename','M0542','iseqp',num2cell([-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([25,30,35,40,45,50,55,60,65,70,75]));
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -15, subseq 10
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

%Fiber 11
List = struct('filename','M0542','iseqp',num2cell([-17,-17,-17,-17,-17,-17,-17,-17,-17,-17,-17,-17,-17]),'isubseqp',num2cell([3,4,5,6,7,8,9,10,11,12,13,14,15]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([25,30,35,40,45,50,55,60,65,70,75,80,85]));
T = GenWFPlot(List, 4, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -17, subseq 12
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

%Fiber 12
List = struct('filename','M0542','iseqp',num2cell([-20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20]),'isubseqp',num2cell([3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([15,20,25,30,35,40,45,50,55,60,65,70,75,80,85]));
T = GenWFPlot(List, 4, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -20, subseq 14
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

%Fiber 14
List = struct('filename','M0542','iseqp',num2cell([-21,-21,-21,-21,-21,-21,-21,-21,-21,-21,-21,-21,-21]),'isubseqp',num2cell([5,6,7,8,9,10,11,12,13,14,15,16,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([25,30,35,40,45,50,55,60,65,70,75,80,85]));
T = GenWFPlot(List, 4, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -21, subseq 14
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

%Fiber 17, high cf
List = struct('filename','M0542','iseqp',num2cell([-24,-24,-24,-24,-24,-24,-24,-24,-24,-24,-24,-24,-24]),'isubseqp',num2cell([6,7,8,9,10,11,12,13,14,15,16,17,18]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([25,30,35,40,45,50,55,60,65,70,75,80,85]));
T = GenWFPlot(List, 4, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -24, subseq 15
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

%Fiber 18, high cf
List = struct('filename','M0542','iseqp',num2cell([-25,-25,-25,-25,-25,-25,-25,-25,-25,-25,-25,-25]),'isubseqp',num2cell([5,6,7,8,9,10,11,12,13,14,15,16]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,35,40,45,50,55,60,65,70,75,80,85]));
T = GenWFPlot(List, 4, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -25, subseq 13
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

%Fiber 22, high cf
List = struct('filename','M0542','iseqp',num2cell([-31,-31,-31,-31,-31,-31,-31,-31,-31,-31,-31,-31,-31]),'isubseqp',num2cell([4,5,6,7,8,9,10,11,12,13,14,15,16]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([25,30,35,40,45,50,55,60,65,70,75,80,85]));
T = GenWFPlot(List, 4, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -31, subseq 13
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

%Fiber 24
List = struct('filename','M0542','iseqp',num2cell([-32,-32,-32,-32,-32,-32,-32,-32,-32,-32,-32,-32,-32,-32,-32,-32]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85]));
T = GenWFPlot(List, 4, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -32, subseq 13
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

%Fiber 27, high cf
List = struct('filename','M0542','iseqp',num2cell([-34,-34,-34,-34,-34,-34,-34,-34,-34,-34,-34,-34,-34]),'isubseqp',num2cell([6,7,8,9,10,11,12,13,14,15,16,17,18]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([25,30,35,40,45,50,55,60,65,70,75,80,85]));
T = GenWFPlot(List, 4, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -34, subseq 15
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

%Fiber 29, high cf
List = struct('filename','M0542','iseqp',num2cell([-38,-38,-38,-38,-38,-38,-38,-38,-38,-38,-38]),'isubseqp',num2cell([8,9,10,11,12,13,14,15,16,17,18]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([35,40,45,50,55,60,65,70,75,80,85]));
T = GenWFPlot(List, 4, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -38, subseq 15
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

%Fiber 31
List = struct('filename','M0542','iseqp',num2cell([-41,-41,-41,-41,-41,-41,-41,-41,-41,-41,-41,-41,-41]),'isubseqp',num2cell([5,6,7,8,9,10,11,12,13,14,15,16,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([25,30,35,40,45,50,55,60,65,70,75,80,85]));
T = GenWFPlot(List, 4, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -41, subseq 14
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

%Fiber 42, high cf
List = struct('filename','M0542','iseqp',num2cell([-44,-44,-44,-44,-44,-44,-44,-44,-44,-44,-44,-44,-44,-44,-44]),'isubseqp',num2cell([3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([15,20,25,30,35,40,45,50,55,60,65,70,75,80,85]));
T = GenWFPlot(List, 4, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -44, subseq 14
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];


%Fiber 43, high cf
List = struct('filename','M0542','iseqp',num2cell([-46,-46,-46,-46,-46,-46,-46,-46,-46,-46,-46]),'isubseqp',num2cell([6,7,8,9,10,11,12,13,14,15,16]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([25,30,35,40,45,50,55,60,65,70,75]));
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -46, subseq 15
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

%Fiber 45, high cf
List = struct('filename','M0542','iseqp',num2cell([-48,-48,-48,-48,-48,-48,-48,-48,-48,-48,-48,-48]),'isubseqp',num2cell([5,6,7,8,9,10,11,12,13,14,15,16]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,35,40,45,50,55,60,65,70,75,80,85]));
T = GenWFPlot(List, 4, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -48, subseq 13
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

%Fiber 47, high cf
List = struct('filename','M0542','iseqp',num2cell([-52,-52,-52,-52,-52,-52,-52,-52,-52,-52,-52,-52,-52,-52]),'isubseqp',num2cell([5,6,7,8,9,10,11,12,13,14,15,16,17,18]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,25,30,35,40,45,50,55,60,65,70,75,80,85]));
T = GenWFPlot(List, 4, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds -52, subseq 15
%pause;close;
D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];

%Fiber 50 and further: high TH

echo off;                                                                                                                                         
                                                                                       
%-----------------------------------------------------------------                                                                                                                                              
nd=numel(D);

%add new field 'fibernr' to D and fill it
D(1).fibernr=NaN;
for i=1:nd
    % try-catch-construction used to handle rows of DLAT that have NaN for ds1.iseqp or ds1.iseqn
    try, D(i).fibernr = getFnr({D(i).ds1.filename},D(i).ds1.iseqp);
    catch, D(i).fibernr = getFnr({D(i).ds1.filename},D(i).ds1.iseqn);
    end
end

%add new field 'slope' to D and fill it
D(1).slope = NaN;
Args = num2cell(getTRatios(D));
[D.slope] = deal(Args{:});

%add new field 'cf' to D and fill it
D(1).cf=NaN;
for i=1:nd
    g = getCF4Cell(D(i).ds1.filename, D(i).fibernr);
    D(i).cf = g.thr.cf;
end                                                                                                                                                                                        

%-----------------------------------------------------------------
DLAT = D; clear('D');
save(mfilename, 'DLAT');
%-----------------------------------------------------------------
Dlo = structfilter(DLAT, '$cf$ <= 4000');
Dhi = structfilter(DLAT, '$cf$ > 4000');

%groupplot delay as a function of intensity
groupplot(Dlo, 'xval', 'yval', Dhi,'xval','yval', 'markers', {'o','*'}, 'colors', {'b','r'});
hold on;
xlabel('Intensity (dB SPL)');
ylabel('Delay (ms)');
title(['Plot-(delay,intensity) for M0542']);
hold off;

%groupplot slopes as a function of cf
groupplot(DLAT, 'cf', 'slope', 'markers', {'o'}, 'colors', {'b'});
hold on;
xlabel('CF (Hz)');
ylabel('Slope (microsec/dB)');
title('Plot-(cf,slope) for M0542');
line([0,30000], [0,0]);
hold off;