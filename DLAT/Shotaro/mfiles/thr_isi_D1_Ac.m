D1=structsort(Dspl,'$Evalisi$');
for s=1:length(D1)
    if isempty(find(D1(s).RaySig<=0.001))==1
        D1(s).maxR=NaN;
        D1(s).maxRRaySig=NaN;
        D1(s).StimFreq=D1(s).BinFreq(1);
    else
        [a,n]=max(D1(s).R(find(D1(s).RaySig<=0.001)));
        D1(s).maxR=a;
        select=D1(s).RaySig(find(D1(s).RaySig<=0.001));
        D1(s).maxRRaySig=select(n);
        clear a;clear n;clear select
        D1(s).StimFreq=D1(s).BinFreq(1);
    end;
end;
D1_A=D1([1 3:57 58:81 82:89 90 91:108 109:124 125:129]);
D1_Ac=structfilter(D1_A,'$CF$-$StimFreq$<1 & $CF$-$StimFreq$>-1');

D1_B=D1([130:178]);
D1_Bc=structfilter(D1_B,'$CF$-$StimFreq$<1 & $CF$-$StimFreq$>-1');

%structplot(D1_A,'StimFreq','maxR',D1_Ac,'StimFreq','maxR',...
    %D1_B,'StimFreq','maxR',D1_Bc,'StimFreq','maxR',...
    %'markers',{'o','o','o','o'}, 'Colors',{'k','r','b','c'})

D1_A_R=structfilter(D1_A,'isnan($maxR$)==0');
D1_A_RN=structfilter(D1_A,'isnan($maxR$)');

D1_B_R=structfilter(D1_B,'isnan($maxR$)==0');
D1_B_RN=structfilter(D1_B,'isnan($maxR$)');

for u=1:length(D1_Ac)
    
    for x=1:length(Dthr186)
        if strcmp(Dthr186(x).ds.filename,D1_Ac(u).thrfile)==1 & strcmp(Dthr186(x).ds.seqid,D1_Ac(u).thrds)==1
            xxx=x;
        end;
    end;
    D1_Ac(u).depth=Dthr186(xxx).depth;
    
end;


for u=1:length(D1_Ac)
    ds = dataset(D1_Ac(u).ds1.filename, D1_Ac(u).ds1.seqid);
    figure('Units', 'normalized', ...
    'OuterPosition', [0 0.025 1 0.975], ...
    'PaperType', 'A4', ...
    'PaperPositionMode', 'manual', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0.05 0.05 0.90 0.90], ...
    'PaperOrientation', 'landscape')
    ISItest
    
    Title = axes('Position', [0.10 0.10 0.80 0.10], 'Visible', 'off');
    axes(Title)
    text(0.5,0.5,[D1_Ac(u).ds1.filename ' ' D1_Ac(u).ds1.seqid])
    %print
    close
    clear k;
    
    %aa=D1_Ac(u).thrfile;bb=D1_Ac(u).thrds;
    for x=1:length(Dthr186)
        if strcmp(Dthr186(x).ds.filename,D1_Ac(u).thrfile)==1 & strcmp(Dthr186(x).ds.seqid,D1_Ac(u).thrds)==1
            xxx=x;
        end;
    end;
    
    if Dthr186(xxx).tag==0
        ds2 = dataset(D1_Ac(u).thrfile,D1_Ac(u).thrds);
        evalTHRs(ds2)
        figure(FigHdl)
    else
        FigHdl = figure('NumberTitle', 'off', ...
            'Units', 'normalized', ...
            'OuterPosition', [0 0.025 1 0.975], ... %Maximize figure (not in the MS Windows style!) ...
            'PaperType', 'A4', ...
            'PaperPositionMode', 'manual', ...
            'PaperUnits', 'normalized', ...
            'PaperPosition', [0.05 0.05 0.90 0.90], ...
            'PaperOrientation', 'landscape');

        AxHdl_thr = axes('Position', [0.10 0.80 0.8 0.20], 'Visible', 'off');
        THRtext=strvcat(['ThrData lost'],['CF: ' num2str(D1_Ac(u).CF) 'Hz'],['THR: ' num2str(D1_Ac(u).THR) 'dB']);
        text(0.1,0.5,THRtext)
    end;
    
    AxHdl2 = axes('Position', [0.10 0.10 0.40 0.15])
    AxHdl3 = axes('Position', [0.10 0.30 0.40 0.15])
    AxHdl4 = axes('Position', [0.55 0.50 0.20 0.30], 'Visible', 'off')
    AxHdl5 = axes('Position', [0.75 0.50 0.20 0.30], 'Visible', 'off')
    
    assignin('base','AxHdl2',AxHdl2);
    assignin('base','AxHdl3',AxHdl3);
    assignin('base','AxHdl4',AxHdl4);
    assignin('base','AxHdl5',AxHdl5);
    
    axes(AxHdl2)
    line(Mis1,Mis2);xlabel('Level (dB SPL)');ylabel('#Mistrigger');
    axes(AxHdl3)
    line(Mis1,Mis3);xlabel('Level (dB SPL)');ylabel('#Mistrigger/#TotalTrigger');
    axes(AxHdl4)
    text(0.1,0.95,[D1_Ac(u).ds1.filename ' ' D1_Ac(u).ds1.seqid ' depth: ' num2str(D1_Ac(u).depth)])
    if D1_Ac(u).approach==2
        text(0.1,0.8,'Midline approach')
    else
        text(0.1,0.8,'Transbulla approach')
    end;
    if D1_Ac(u).RecSide==1
        text(0.1,0.7,'RecSide: Left')
    else
        text(0.1,0.7,'RecSide: Right')
    end;
    if D1_Ac(u).StimSide==1
        text(0.1,0.6,'StimSide: Left')
    else
        text(0.1,0.6,'StimSide: Right')
    end;
    text(0.1,0.4,'Subjective evaluation of ISI:')
    text(0.1,0.3,[D1_Ac(u).Evalisi])
    axes(AxHdl5)
    LIST=['Relevant dataset:'];
    for v=1:length(F)
        if strcmp(F(v).thrfile,D1_Ac(u).thrfile)==1&...
                strcmp(F(v).thrds,D1_Ac(u).thrds)==1
            name=F(v).ds1.seqid;
            LIST=strvcat(LIST, name);
        end;
        clear name;
    end;
    for v=1:length(D1_A)
        if strcmp(D1_A(v).thrfile,D1_Ac(u).thrfile)==1&...
                strcmp(D1_A(v).thrds,D1_Ac(u).thrds)==1
            name=D1_A(v).ds1.seqid;
            LIST=strvcat(LIST, name);
        end;
        clear name;
    end;
    
    display(LIST)
    text(0.1,0.3,LIST)
    print
    clear NRHO;clear SPL;clear LIST;
    %clear ds;
    clear ds2;
end;