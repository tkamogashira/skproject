% pslatDEMO
%
% PM 12/12

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


%==============================================================
% D0120
%==============================================================
% Fiber 5: CF = 31.383Hz ---------------------------------------------------------------------------

% NSPL
% tag 2 (noisy SAC)
List = struct('filename','D0120','iseqp',num2cell([-9,-9,-9,-9,-9,-9]),'isubseqp',num2cell([1,2,3,4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,50,40,30,20,10]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all; 

% A-
% tag 2 (noisy SAC)
List = struct('filename','D0120','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-10,-10,-10,-10,-10,-10]),'isubseqn',num2cell([1,2,3,4,5,6]),'discernvalue',num2cell([60,50,40,30,20,10]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% B
% tag 3 (VERY noisy SAC)
List = struct('filename','D0120','iseqp',num2cell([-11,-11,-11]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,70,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline);
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all; 

% Fiber 9: CF = 6373Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% NSPL
% tag 2 (noisy SAC)
List = struct('filename','D0120','iseqp',num2cell([-27,-27,-27]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,70,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline);
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

%======================================================================================================================================  
%======================================================================================================================================  

nd=numel(D);

%add new field 'fibernr' to D and fill it
D(1).fibernr=NaN;
for i=1:nd
    % try-catch used construction used to handle rows of DLAT that have NaN for ds1.iseqp or ds1.iseqn
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

%add new field 'difcor' to D and fill it
D(1).difcor=NaN;
for i=1:nd
    if (~isnan(D(i).ds1.iseqn))&(~isnan(D(i).ds1.iseqp)), D(i).difcor=1;
    else, D(i).difcor=0;
    end
end

%==============================================================
DLATTBCAT = D; clear('D');
save('pslatTBcatPM', 'DLATTBCAT');
%==============================================================

Ddif=DLATTBCAT;
Dnodif=DLATTBCAT;

%groupplot delay as a function of intensity
groupplot(Ddif, 'xval', 'yval', Dnodif, 'xval', 'yval', 'markers', {'o', '*'}, 'colors', {'b','r'});
hold on;
xlabel('Intensity (dB SPL)');
ylabel('Delay (ms)');
title(['Plot-(delay,intensity) for TB data']);
hold off;

%groupplot slopes as a function of cf
groupplot(Ddif, 'cf', 'slope', Dnodif, 'cf', 'slope', 'markers', {'o', '*'}, 'colors', {'b','r'});
hold on;
xlabel('CF (Hz)');
ylabel('Slope (\mus/dB)');
title('Plot-(cf,slope) for TB data');
line([0,30000], [0,0]);
hold off;

if 0
    
%delay-intensityplots in groups defined by CF
Dnodif100 = structfilter(Dnodif, '($cf$>100)&($cf$<=200)');Ddif100 = structfilter(Ddif, '($cf$>100)&($cf$<=200)');
Dnodif200 = structfilter(Dnodif, '($cf$>200)&($cf$<=400)');Ddif200 = structfilter(Ddif, '($cf$>200)&($cf$<=400)');
Dnodif400 = structfilter(Dnodif, '($cf$>400)&($cf$<=800)');Ddif400 = structfilter(Ddif, '($cf$>400)&($cf$<=800)');
Dnodif800 = structfilter(Dnodif, '($cf$>800)&($cf$<=1600)');Ddif800 = structfilter(Ddif, '($cf$>800)&($cf$<=1600)');
Dnodif1600 = structfilter(Dnodif, '($cf$>1600)&($cf$<=3200)');Ddif1600 = structfilter(Ddif, '($cf$>1600)&($cf$<=3200)');
Dnodif3200 = structfilter(Dnodif, '$cf$>3200');Ddif3200 = structfilter(Ddif, '$cf$>3200');

groupplot(Ddif100, 'xval', 'yval', Dnodif100, 'xval', 'yval', 'markers', {'o', '*'}, 'colors', {'b','r'});title('CF ]100Hz;200Hz]');xlabel('Intensity (dB SPL)');ylabel('Delay (ms)');gp1=gcf;
figure;fig=gcf;putplot(fig,getplot(gp1,2),2,3,1);
groupplot(Ddif200, 'xval', 'yval', Dnodif200, 'xval', 'yval', 'markers', {'o', '*'}, 'colors', {'b','r'});title('CF ]200Hz;400Hz]');xlabel('Intensity (dB SPL)');ylabel('Delay (ms)');gp2=gcf;
putplot(fig,getplot(gp2,2),2,3,2);
groupplot(Ddif400, 'xval', 'yval', Dnodif400, 'xval', 'yval', 'markers', {'o', '*'}, 'colors', {'b','r'});title('CF ]400Hz;800Hz]');xlabel('Intensity (dB SPL)');ylabel('Delay (ms)');gp3=gcf;
putplot(fig,getplot(gp3,2),2,3,3);
groupplot(Ddif800, 'xval', 'yval', 'markers', {'o', '*'}, 'colors', {'b','r'});title('CF ]800Hz;1600Hz]');xlabel('Intensity (dB SPL)');ylabel('Delay (ms)');gp4=gcf;
putplot(fig,getplot(gp4,2),2,3,4);
groupplot(Ddif1600, 'xval', 'yval', Dnodif1600, 'xval', 'yval', 'markers', {'o', '*'}, 'colors', {'b','r'});title('CF ]1600Hz;3200Hz]');gp5=gcf;
putplot(fig,getplot(gp5,2),2,3,5);
groupplot(Ddif3200, 'xval', 'yval', Dnodif3200, 'xval', 'yval', 'markers', {'o', '*'}, 'colors', {'b','r'});title('CF ]3200Hz;30000Hz]');gp6=gcf;
putplot(fig,getplot(gp6,2),2,3,6);

close(gp1);close(gp2);close(gp3);close(gp4);close(gp5);close(gp6);
end

%============================================================================================================================================ 
%============================================================================================================================================

function staggerWFplot(DLATTBCAT, intensity, normto, sf, datafilenames)

% StaggerWFplot(DLATTBCAT, intensity, normto, sf, datafilenames)
% Stacked-on-CF-plots
% e.g. StaggerWFpot(DLATTBCAT, 50, 70, 1000, 'D0120')
% plots all correlograms at 50dB with the 70dB correlogram as a reference

xmin = -0.5;
xmax = 0.5;
ymin = 0;
ymax = 5000;

figure;
axis([xmin xmax ymin ymax]);
hold on;
title(['Crosscorrelograms @ ' num2str(intensity) ' dB normalized with respect to ' num2str(normto) ' dB. Data: ' datafilenames]);
xlabel('Delay (ms)');
ylabel('CF (Hz)');
line([(xmin+xmax)/2 (xmin+xmax)/2],[ymin ymax],'color',[0 0 0],'LineStyle','--');

nd = numel(DLATTBCAT);
D=DLATTBCAT;

for i=1:nd
    
    line(D(i).lag(dx(i),:), D(i).normco(dx(i),:), 'LineStyle', '-', 'Marker', 'none', 'Color', [1 0 0]);
    
    if ~isempty(find(D(i).xval==intensity))&~isempty(find(D(i).xval==normto))

        dx(i) = find(D(i).xval==intensity);

% De volgende lijnen geven vaak problemen ("exceeds matrix dimensions" type, ook wanneer dit niet het geval kan zijn) --------------------------------

        
        ndx(i) = find(D(i).xval==normto); 
        
        nfactor = D(i).ppnormmagn(nidx); 
        
        D(i).normco(dx(i),:) = (D(i).normco(dx(i),:))/nfactor; 
         
        D(i).normco(dx(i),:) = D(i).normco(dx(i),:)*sf + D(i).cf;
        
        line(D(i).lag(dx(i),:), D(i).normco(dx(i),:), 'LineStyle', '-', 'Marker', 'none', 'Color', [1 0 0]);

% Volgende lijnen werken correct ----------------------------------------------------------------------------------------------------------------------- 
        
        %plot curve (difcors are plotted blue, non-difcors red)
        if D(i).difcor == 1, line(D(i).lag(dx(i),:), D(i).normco(dx(i),:), 'LineStyle', '-', 'Marker', 'none', 'Color', [0 0 1]); %plot difcor
            
        elseif D(i).difcor == 0, 
        line(D(i).lag(dx(i),:), D(i).normco(dx(i),:), 'LineStyle', '-', 'Marker', 'none', 'Color', [1 0 0]);% plot nt-difcor
            
        else, disp(['rij ' num2str(i) ' van D heeft een invalid difcor-waarde']);
        end
        
     
        
%         plot dot on primary peak
        line(D(i).yval(dx(i)), D(i).normco(dx(i), find(abs(D(i).lag(dx(i),:)-D(i).yval(dx(i)))<2.680e-014)), 'LineStyle', 'none', 'Marker', 'o', ...
        'Color', 'k','MarkerFace', [1 1 1]);
        
    
        % plot dots on secundary peaks
        try, %try used to handle correlograms without sec-peaks
        line(D(i).spdelay(dx(i),1), D(i).normco(dx(i), find(abs(D(i).lag(dx(i),:)-D(i).spdelay(dx(i),1))<2.680e-014)), 'LineStyle', 'none', 'Marker', 'v', ...
        'Color', 'k','MarkerFace', [1 1 1]);
        line(D(i).spdelay(dx(i),2), D(i).normco(dx(i),  find(abs(D(i).lag(dx(i),:)-D(i).spdelay(dx(i),2))<2.680e-014)), 'LineStyle', 'none', 'Marker', '^', ...
        'Color', 'k','MarkerFace', [1 1 1]);
        end
    end
end
