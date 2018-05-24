function staggerWFplot(Dhold, intensity, normto, sf, datafilenames)

% stackedWFplotPM
%
%
%

echo on;

D = struct([]);

% fields that need to be retrieved
XFieldName = 'ds2.discernvalue';
YFieldName = 'primpeak.delay';
ppnm = 'primpeak.normmagn';
spd = 'secpeaks.delay';
spnm = 'secpeaks.normmagn';
lagfn = 'lag';
normcofn = 'normco';

%smoothing and spline factor
smoothing = 3;
spline = 10;

%A0306--------------------------------------------------------------------------------------------------------------                                                                                                                                              
%Fiber 4
List = GenWFList(struct([]), 'A0306', [27;28], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 27                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 6
List = GenWFList(struct([]), 'A0306', [41;40], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 40                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 7
List = GenWFList(struct([]), 'A0306', [51;52;53], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 51                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 8
List = GenWFList(struct([]), 'A0306', [60;61;76;77;78;79;80], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 60                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 10
List = GenWFList(struct([]), 'A0306', [105;106;107], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 105                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 11
List = GenWFList(struct([]), 'A0306', [123;124;125], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 123                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 13
List = GenWFList(struct([]), 'A0306', [168;169;170], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 168                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 17
List = GenWFList(struct([]), 'A0306', [213;214;215], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 213                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 24
List = GenWFList(struct([]), 'A0306', [244;245;246], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 244                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 25
List = GenWFList(struct([]), 'A0306', [264;265;266], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 264                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;
 
%Fiber 29
List = GenWFList(struct([]), 'A0306', [295;296;297], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 295                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 31
List = GenWFList(struct([]), 'A0306', [319;320;321], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 319                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 33
List = GenWFList(struct([]), 'A0306', [327;328;329], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 327                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

% Fiber 35
List = GenWFList(struct([]), 'A0306', [348;349;350], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); %reference = ds 348                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 38
List = GenWFList(struct([]), 'A0306', [385;386;387], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 385                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 41, high cf
List = struct('filename','A0306','iseqp',num2cell([405,406,407]),'isubseqp',num2cell([1,1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 405                   

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close;
 
%Fiber 44
List = GenWFList(struct([]), 'A0306', [453;454;455], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 453                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 47
List = GenWFList(struct([]), 'A0306', [472;473;474], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 472                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 48
List = GenWFList(struct([]), 'A0306', [502;503], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 502                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 49
List = GenWFList(struct([]), 'A0306', [525;526;527], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 525                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 50 (!see ds 544: interaural corr -1 beetje onvolledig)
List = GenWFList(struct([]), 'A0306', [543;544], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 543                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%Fiber 51
List = GenWFList(struct([]), 'A0306', [553;554;555], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 553                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close;

%-----------------------------------------------------------------
Dhold = D; clear('D');
save('stackedWFplotPM1', 'Dhold');
%-----------------------------------------------------------------

% function staggerWFplot(Dhold, intensity, normto, sf, datafilenames)

figure(2);
xmin = -0.5;
xmax = 0.5;
ymin = 0;
ymax = 5000;

axis([xmin xmax ymin ymax]);
hold on;
title(['Crosscorrelograms @ ' num2str(intensity) ' dB normalized with respect to ' num2str(normto) ' dB. Data: ' datafilenames]);
xlabel('Delay (ms)');
ylabel('CF (Hz)');
line([(xmin+xmax)/2 (xmin+xmax)/2],[ymin ymax],'color',[0 0 0],'LineStyle','--');

nd = numel(Dhold);
D=Dhold;

for i=1:nd
    
    if ~isempty(find(D(i).xval==intensity))&~isempty(find(D(i).xval==normto))

        idx = find(D(i).xval==intensity);
    
        nidx = find(D(i).xval==normto);
        
        nfactor = D(i).ppnormmagn(nidx); % the normalize factor is the height of the central peak
        
        D(i).normco(idx,:) = (D(i).normco(idx,:))/nfactor; %normalize curves to primary peak of normto-intensity
         
        D(i).normco(idx,:) = D(i).normco(idx,:)*sf + D(i).cf;
        
        % plot curve (difcors are plotted blue, non-difcors red)
        if D(i).difcor == 1, line(D(i).lag(idx,:), D(i).normco(idx,:), 'LineStyle', '-', 'Marker', 'none', 'Color', [0 0 1]); % plot difcor
            
        elseif D(i).difcor == 0, line(D(i).lag(idx,:), D(i).normco(idx,:), 'LineStyle', '-', 'Marker', 'none', 'Color', [1 0 0]); % plot nt-difcor
            
        else, disp(['rij ' num2str(i) ' van D heeft een invalid difcor-waarde']);
        end
          
        % plot dot on primary peak
        line(D(i).yval(idx), D(i).normco(idx, find(abs(D(i).lag(idx,:)-D(i).yval(idx))<2.680e-014)), 'LineStyle', 'none', 'Marker', 'o', ...
        'Color', 'k','MarkerFace', [1 1 1]);
        
        % plot dots on secundary peaks
        try, %try used to handle correlograms without sec-peaks
        line(D(i).spdelay(idx,1), D(i).normco(idx, find(abs(D(i).lag(idx,:)-D(i).spdelay(idx,1))<2.680e-014)), 'LineStyle', 'none', 'Marker', 'v', ...
        'Color', 'k','MarkerFace', [1 1 1]);
        line(D(i).spdelay(idx,2), D(i).normco(idx,  find(abs(D(i).lag(idx,:)-D(i).spdelay(idx,2))<2.680e-014)), 'LineStyle', 'none', 'Marker', '^', ...
        'Color', 'k','MarkerFace', [1 1 1]);
        end
    end
end

%-------------------------
clear(Dhold);
%-------------------------


%A0307--------------------------------------------------------------------------------------------------------------

% %Fiber 4, high cf
% List = struct('filename','A0307','iseqp',num2cell([8,9]),'isubseqp',num2cell([2,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 8                   
% 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
% 
% if 0%Fiber 5 (bad thr)
% List = GenWFList(struct([]), 'A0307', [12;13], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 12                       
% 
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
% end
% 
% %Fiber 6 (bad thr?)
% List = GenWFList(struct([]), 'A0307', [18;19], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 18                       
% 
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
% 
% %Fiber 7 (bad thr?)
% List = GenWFList(struct([]), 'A0307', [25;26;27], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 25                       
% 
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
% 
% %Fiber 8 (bad thr?)
% List = GenWFList(struct([]), 'A0307', [47;48], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 47                       
% 
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
 
%Fiber 14
List = GenWFList(struct([]), 'A0307', [67;68], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); reference = ds 67                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

%Fiber 15
List = GenWFList(struct([]), 'A0307', [75;76], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); reference = ds 75                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

%Fiber 17
List = GenWFList(struct([]), 'A0307', [85;86], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); reference = ds 85                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

%Fiber 29 (weird thr-curve)
List = GenWFList(struct([]), 'A0307', [140;141], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 141                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;

%Fiber 30
List = GenWFList(struct([]), 'A0307', [168;169], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 168                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;

%Fiber 32
List = GenWFList(struct([]), 'A0307', [205;206;207], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 205                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;

%Fiber 43
List = GenWFList(struct([]), 'A0307', [280;281;282], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 280                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;

%Fiber 45
List = GenWFList(struct([]), 'A0307', [293;294;295], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 293                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;

if 0 %(see dot raster: ds 311 not good) 
%Fiber 48
List = GenWFList(struct([]), 'A0307', [310;311], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 310                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;
end

%Fiber 50
List = GenWFList(struct([]), 'A0307', [325;328;332], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 325                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;

if 0
%Fiber 51 (see dot raster: ds 369 not good)
List = GenWFList(struct([]), 'A0307', [368;369], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 368                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;
end

%Fiber 53
List = GenWFList(struct([]), 'A0307', [372;373;374], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 372                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;

if 0
%Fiber 54 (bad thr)
List = GenWFList(struct([]), 'A0307', [387;388;389], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 387                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;
end

%Fiber 55(bad thr?)
List = GenWFList(struct([]), 'A0307', [404;405;406], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 404                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;

%Fiber 56 (bad thr?)
List = GenWFList(struct([]), 'A0307', [419;420;421], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 419                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;

if 0 %bad thr
%Fiber 57
List = GenWFList(struct([]), 'A0307', [429;430;431], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 429                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;
end

%Fiber 58
List = GenWFList(struct([]), 'A0307', [444;445;446], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 444                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;

if 0 %bad thr
%Fiber 60
List = GenWFList(struct([]), 'A0307', [472;473], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 472                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;
end

%Fiber 61
List = GenWFList(struct([]), 'A0307', [486;487;488], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 486                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;

%Fiber 62 (ds 495 not good)

%Fiber 64
List = GenWFList(struct([]), 'A0307', [498;499;500], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 498                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;

%Fiber 65
List = GenWFList(struct([]), 'A0307', [517;519;520], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 517                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;

%Fiber 66
List = GenWFList(struct([]), 'A0307', [530;531;532], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 530                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;

% if 0 %bad thr
% %Fiber 69
% List = GenWFList(struct([]), 'A0307', [579;580], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 579                       
% 
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
% end
% 
% %Fiber 70 (ds 583 not good)
% 
% if 0
% %Fiber 73 (bad thr)
% List = GenWFList(struct([]), 'A0307', [601;602], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 601                       
% 
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
% end
% 
% if 0
% %Fiber 74 (bad thr)
% List = GenWFList(struct([]), 'A0307', [618;619;620], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 618                       
% 
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
% end
% 
% 
% %Fiber 77 (ds 642 not good, see dot raster)
% 
% if 0 %bad thr
% %Fiber 79
% List = GenWFList(struct([]), 'A0307', [656;657], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 656                       
% 
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
% end
%     
% %Fiber 81 (should ds 666 or ds 669 be chosen as NRHO @ 70 dB?)
% List = GenWFList(struct([]), 'A0307', [666;667;668], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 666                      
% 
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
% 
% %Fiber 82, high cf
% List = struct('filename','A0307','iseqp',num2cell([675,676,677]),'isubseqp',num2cell([2,1,1]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,90,50]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 82                   
% 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
% 
% %Fiber 83 (bad thr)
% 
% %Fiber 88 (ds 701 not good)
% List = GenWFList(struct([]), 'A0307', [699;700], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 699                       
% 
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;

%Fiber 91
List = GenWFList(struct([]), 'A0307', [707;708], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 707                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;

% %Fiber 92, high cf
% List = struct('filename','A0307','iseqp',num2cell([710,711,712]),'isubseqp',num2cell([1,1,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50,90]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 710                   
% 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
% 
% %Fiber 94, high cf
% List = struct('filename','A0307','iseqp',num2cell([715,716]),'isubseqp',num2cell([1,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 715                   
% 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
% 
% if 0 %bad thr
% %Fiber 96 (choose ds 721 or ds722 for 90 dB?)
% List = GenWFList(struct([]), 'A0307', [720;721], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 720                       
% 
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
% end
% 
% if 0%bad thr
% %Fiber 99
% List = GenWFList(struct([]), 'A0307', [729;730;731], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 729                       
% 
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
% end
% 
% if 0%bad thr
% %Fiber 100
% List = GenWFList(struct([]), 'A0307', [733;734], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 733                       
% 
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
% end

% %Fiber 101 (bad thr?)
% List = GenWFList(struct([]), 'A0307', [738;739], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 738                       
% 
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;

%Fiber 103
List = GenWFList(struct([]), 'A0307', [744;745;746], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 744                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
close all;

% %Fiber 104 (choose ds 749 or 751 for 90 dB?)
% List = GenWFList(struct([]), 'A0307', [748;749;750], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 748                       
% 
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;

% %Fiber 110, high cf
% List = struct('filename','A0307','iseqp',num2cell([775,776,777]),'isubseqp',num2cell([2,2,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,90,50]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 775                   
% 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
% 
% %Fiber 111 (ds 782 not good at interaural correlation -1), high cf
% List = struct('filename','A0307','iseqp',num2cell([781,782]),'isubseqp',num2cell([2,1]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,90]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 781                   
% 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;
% 
% %Fiber 112 (choose 786 or 787 for 90dB?), high cf
% List = struct('filename','A0307','iseqp',num2cell([785,786,788]),'isubseqp',num2cell([2,1,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,90,50]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 785                   
% 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;
% close all;

%-----------------------------------------------------------------
Dhold = D; clear('D');
save('stackedWFplotPM2', 'Dhold');
%-----------------------------------------------------------------

% function staggerWFplot(Dhold, intensity, normto, sf, datafilenames)

figure(2);
xmin = -0.5;
xmax = 0.5;
ymin = 0;
ymax = 5000;

axis([xmin xmax ymin ymax]);
hold on;
title(['Crosscorrelograms @ ' num2str(intensity) ' dB normalized with respect to ' num2str(normto) ' dB. Data: ' datafilenames]);
xlabel('Delay (ms)');
ylabel('CF (Hz)');
line([(xmin+xmax)/2 (xmin+xmax)/2],[ymin ymax],'color',[0 0 0],'LineStyle','--');

nd = numel(Dhold);
D=Dhold;

for i=1:nd
    
    if ~isempty(find(D(i).xval==intensity))&~isempty(find(D(i).xval==normto))

        idx = find(D(i).xval==intensity);
    
        nidx = find(D(i).xval==normto);
        
        nfactor = D(i).ppnormmagn(nidx); % the normalize factor is the height of the central peak
        
        D(i).normco(idx,:) = (D(i).normco(idx,:))/nfactor; %normalize curves to primary peak of normto-intensity
         
        D(i).normco(idx,:) = D(i).normco(idx,:)*sf + D(i).cf;
        
        % plot curve (difcors are plotted blue, non-difcors red)
        if D(i).difcor == 1, line(D(i).lag(idx,:), D(i).normco(idx,:), 'LineStyle', '-', 'Marker', 'none', 'Color', [0 0 1]); % plot difcor
            
        elseif D(i).difcor == 0, line(D(i).lag(idx,:), D(i).normco(idx,:), 'LineStyle', '-', 'Marker', 'none', 'Color', [1 0 0]); % plot nt-difcor
            
        else, disp(['rij ' num2str(i) ' van D heeft een invalid difcor-waarde']);
        end
          
        % plot dot on primary peak
        line(D(i).yval(idx), D(i).normco(idx, find(abs(D(i).lag(idx,:)-D(i).yval(idx))<2.680e-014)), 'LineStyle', 'none', 'Marker', 'o', ...
        'Color', 'k','MarkerFace', [1 1 1]);
        
        % plot dots on secundary peaks
        try, %try used to handle correlograms without sec-peaks
        line(D(i).spdelay(idx,1), D(i).normco(idx, find(abs(D(i).lag(idx,:)-D(i).spdelay(idx,1))<2.680e-014)), 'LineStyle', 'none', 'Marker', 'v', ...
        'Color', 'k','MarkerFace', [1 1 1]);
        line(D(i).spdelay(idx,2), D(i).normco(idx,  find(abs(D(i).lag(idx,:)-D(i).spdelay(idx,2))<2.680e-014)), 'LineStyle', 'none', 'Marker', '^', ...
        'Color', 'k','MarkerFace', [1 1 1]);
        end
    end
end

%-------------------------
clear(Dhold);
%-------------------------