% psLATgen_M0542BBN
% popscript to study effect of SPL on delay
% PXJ 8/2005
%
% this version of the script contains broadband noise-data from M0542
% also in this version, in the resulting struct array DLAT, some fields are added, e.g. 'slope', 'cf' and 'fibernr'
% containing the slope (as estimated using linear regression with polyfit()),
% the number of the fiber and the characteristic frequency
%
% A (delay,intensity)- and a (slope,cf)-plot are made.
% For the delay-intensity plot, individual fibers are staggered according to their CF.
% This is done by plotting the delay value 0 ms at the CF-height.
% So there is a ordinate for delay and one for CF, the proportion of those two scales is given by
% the value SF (Hz per ms). (see code for current value of SF)
%
% TF 02/09/2005

echo on;

D = struct([]);

% fields that need to be retrieved
XFieldName = 'ds2.discernvalue';
YFieldName = 'primpeak.delay';

SF = 30000;
                                                                                                                                              
                                                                                                                                              
                                                                                                                                              
                                                                                                                                              
                                                                                                                                            
%M0542--------------------------------------------------------------------------------------------------------------
%Fiber 2, high cf
%interaural correlation -1
List = struct('filename','M0542','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([15,33,34,35]),'isubseqn',num2cell([1,2,2,2]),'discernvalue',num2cell([70,50,90,80]));
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 15, subseq 1

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;
%interaural correlation +1
List = struct('filename','M0542','iseqp',num2cell([15,33,34,35]),'isubseqp',num2cell([2,1,1,1]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50,90,80]));
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 15, subseq 2

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;                                                                                          

%Fiber 5
List = GenWFList(struct([]), 'M0542', [74;75;76;77;78;79;80], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 74                       

D = [D; ExtractPSentry(T, XFieldName, YFieldName)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all; 

%Fiber 7 (broad thr-curve)
List = GenWFList(struct([]), 'M0542', [120;121;122;123;124], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 120                       

D = [D; ExtractPSentry(T, XFieldName, YFieldName)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all; 

%Fiber 11
List = GenWFList(struct([]), 'M0542', [150;161;162;163;164], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 150                       

D = [D; ExtractPSentry(T, XFieldName, YFieldName)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all; 

%Fiber 12
List = GenWFList(struct([]), 'M0542', [175;176;177;178], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 175                       

D = [D; ExtractPSentry(T, XFieldName, YFieldName)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;

%Fiber 17, high cf
%interaural correlation -1
List = struct('filename','M0542','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([212,213,214]),'isubseqn',num2cell([1,2,1]),'discernvalue',num2cell([70,90,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 212

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;
%interaural correlation +1
List = struct('filename','M0542','iseqp',num2cell([212,213,214]),'isubseqp',num2cell([2,1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,90,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 212

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;

%Fiber 19, high cf
%interaural correlation -1
List = struct('filename','M0542','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([268,269,270]),'isubseqn',num2cell([2,2,1]),'discernvalue',num2cell([70,90,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 268

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;
%interaural correlation +1
List = struct('filename','M0542','iseqp',num2cell([268,269,270]),'isubseqp',num2cell([1,1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,90,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 268

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;

%Fiber 23
List = GenWFList(struct([]), 'M0542', [293;294;295], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 293                       

D = [D; ExtractPSentry(T, XFieldName, YFieldName)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;

%Fiber 24
List = GenWFList(struct([]), 'M0542', [316;317;318], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 316                       

D = [D; ExtractPSentry(T, XFieldName, YFieldName)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;

if 0 %(cfr WFplot)
%Fiber 27, high cf
%interaural correlation -1
List = struct('filename','M0542','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([340,341,342]),'isubseqn',num2cell([2,2,1]),'discernvalue',num2cell([70,90,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 340

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;
%interaural correlation +1
List = struct('filename','M0542','iseqp',num2cell([340,341,342]),'isubseqp',num2cell([1,1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,90,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 340

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;
end

if 0 %(cfr WFplot)
%Fiber 28, high cf
%interaural correlation -1
List = struct('filename','M0542','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([345,346]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([70,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 345

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;
%interaural correlation +1
List = struct('filename','M0542','iseqp',num2cell([345,346]),'isubseqp',num2cell([2,1]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 345

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;
end

%Fiber 31
List = GenWFList(struct([]), 'M0542', [351;352], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 351                       

D = [D; ExtractPSentry(T, XFieldName, YFieldName)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;

if 0 %(cfr WFplot)
%Fiber 45, high cf
%interaural correlation -1
List = struct('filename','M0542','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([373,374,375]),'isubseqn',num2cell([1,2,1]),'discernvalue',num2cell([90,70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 374

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;
%interaural correlation +1
List = struct('filename','M0542','iseqp',num2cell([373,374,375]),'isubseqp',num2cell([2,1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([90,70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 374

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;
end

if 0 %(cfr WFplot)
%Fiber 47, high cf
%interaural correlation -1
List = struct('filename','M0542','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([379,380,381]),'isubseqn',num2cell([1,2,1]),'discernvalue',num2cell([70,90,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 379

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;
%interaural correlation +1
List = struct('filename','M0542','iseqp',num2cell([379,380,381]),'isubseqp',num2cell([2,1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,90,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 379

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;
end

%Fiber 50 and further: high TH

%Fiber 62, high cf (better TH at THR-curve)
if 0 %(cfr WFplot)
%interaural correlation -1
List = struct('filename','M0542C','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([4,5]),'isubseqn',num2cell([2,1]),'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 4

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;
end
%interaural correlation +1
List = struct('filename','M0542C','iseqp',num2cell([4,5]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 4

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;

%Fiber 66, high cf (better TH at THR-curve)
%interaural correlation -1
List = struct('filename','M0542C','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([16,17]),'isubseqn',num2cell([2,1]),'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 16

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;
%interaural correlation +1
List = struct('filename','M0542C','iseqp',num2cell([16,17]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 16

D = [D; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);%pause;close all;

%Fiber 67 and further : bad TH
                                                                                                                                              
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

%add new fields 'cf' and 'yvalscaledtocf' to D and fill them
D(1).cf=NaN;D(1).yvalscaledtocf=NaN;
for i=1:nd
    g = getCF4Cell(D(i).ds1.filename, D(i).fibernr);
    D(i).cf = g.thr.cf;
    D(i).yvalscaledtocf=SF*(D(i).yval)+(D(i).cf);
end

%add new field 'difcor' to D and fill it
D(1).difcor=NaN;
for i=1:nd
    if (~isnan(D(i).ds1.iseqn))&(~isnan(D(i).ds1.iseqp)), D(i).difcor=1;
    else, D(i).difcor=0;
    end
end

if 0 %the following was meant to be used when you want to display the reference dots bigger or so.
%add fields refxval and refyval to D and fill them
D(1).refxval=NaN; D(1).refyval=NaN;
for i=1:nd
    idx = find((D(i).xval)==70);
    D(i).refxval = 70;
    D(i).refyval = D(i).yvalscaledtocf(idx);
end
end

%-----------------------------------------------------------------
DLAT = D; clear('D');
save(mfilename, 'DLAT');
%-----------------------------------------------------------------
Ddif=structfilter(DLAT, '$difcor$ == 1');
Dnondif=structfilter(DLAT, '$difcor$ == 0');

%groupplot delay as a function of intensity
groupplot(Ddif, 'xval', 'yvalscaledtocf', Dnondif, 'xval', 'yvalscaledtocf', 'markers', {'o', '*'}, 'colors', {'b','r'});
hold on;
xlabel('Intensity (dB SPL)');
ylabel('CF (Hz)');
title('Plot-(delay,intensity) for M0542BBN');

% Plotting delay-unit box
% Calculate sizes of current axis ...
A=axis; XRng=A(1:2); YRng=A(3:4);
Xsize = abs(diff(XRng)); Ysize = abs(diff(YRng));
%Find coordinates of lower left corner ...
[Xllc, Yllc] = deal(XRng(1) + 0.050*Xsize, YRng(1) + 0.025*Ysize);
%Find width and height of box ...
[Width, Height] = deal(0.005*Xsize, 1*(SF/5));
%Plot unitbox ...
rectangle('Position', [Xllc, Yllc, Width, Height], 'EdgeColor', 'k', ...
    'FaceColor', [1 1 1], 'LineStyle', '-');
rectangle('Position', [Xllc, Yllc, Width, Height/2], 'EdgeColor', 'k', ...
    'FaceColor', [0 0 0], 'LineStyle', '-');
%Plot legend ...
text(Xllc+Width+0.010*Xsize, Yllc, '0.0', 'fontsize', 5, ...
    'fontweight', 'light');
text(Xllc+Width+0.010*Xsize, Yllc+(Height/2), '0.1', 'fontsize', 5, ...
    'fontweight', 'light');
text(Xllc+Width+0.010*Xsize, Yllc+Height, '0.2', 'fontsize', 5, ...
    'fontweight', 'light');
text(Xllc-0.02*Xsize, Yllc+0.2*Height,'Delay (ms)', 'fontsize', 10, 'fontweight', 'normal', 'Rotation', 90);
hold off;
%Show scaling factor
text(XRng(2) - 0.2*Xsize, Yllc, ['current SF: ' num2str(SF) ' Hz/ms'], 'fontsize', 10, 'fontweight', 'light');

%groupplot slopes as a function of cf
groupplot(Ddif, 'cf', 'slope', Dnondif, 'cf', 'slope', 'markers', {'o', '*'}, 'colors', {'b','r'});
hold on;
xlabel('CF (Hz)');
ylabel('Slope (microsec/dB)');
title('Plot-(cf,slope) for M0542');
line([0,30000], [0,0]);
hold off;