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

structplot(D1_A,'StimFreq','maxR',D1_Ac,'StimFreq','maxR',...
    D1_B,'StimFreq','maxR',D1_Bc,'StimFreq','maxR',...
    'markers',{'o','o','o','o'}, 'Colors',{'k','r','b','c'})

D1_A_R=structfilter(D1_A,'isnan($maxR$)==0');
D1_A_RN=structfilter(D1_A,'isnan($maxR$)');

D1_B_R=structfilter(D1_B,'isnan($maxR$)==0');
D1_B_RN=structfilter(D1_B,'isnan($maxR$)');


for u=1:length(E)
    %ds = dataset(E(u).ds1.filename, E(u).ds1.seqid);
    %figure('Units', 'normalized', ...
    %'OuterPosition', [0 0.025 1 0.975], ...
    %'PaperType', 'A4', ...
    %'PaperPositionMode', 'manual', ...
    %'PaperUnits', 'normalized', ...
    %'PaperPosition', [0.05 0.05 0.90 0.90], ...
    %'PaperOrientation', 'landscape')
    %ISItest
    %Title = axes('Position', [0.10 0.10 0.80 0.10], 'Visible', 'off');
    %axes(Title)
    %text(0.5,0.5,[E(u).ds1.filename ' ' E(u).ds1.seqid])
    %print
    %clear k;
    
    ds2 = dataset(E(u).thrfile,E(u).thrds);
    evalTHRs(ds2)
    figure(FigHdl)
    axes(AxHdl2)
    line(Mis1,Mis2);xlabel('Level (dB SPL)');ylabel('#Mistrigger');
    axes(AxHdl3)
    line(Mis1,Mis3);xlabel('Level (dB SPL)');ylabel('#Mistrigger/TotalTrigger');
    axes(AxHdl4)
    text(0.1,0.95,[E(u).ds1.filename ' ' E(u).ds1.seqid])
    if E(u).approach==2
        text(0.1,0.8,'Midline approach')
    else
        text(0.1,0.8,'Transbulla approach')
    end;
    if E(u).RecSide==1
        text(0.1,0.7,'RecSide: Left')
    else
        text(0.1,0.7,'RecSide: Right')
    end;
    if E(u).StimSide==1
        text(0.1,0.6,'StimSide: Left')
    else
        text(0.1,0.6,'StimSide: Right')
    end;
    text(0.1,0.4,'Subjective evaluation of ISI:')
    text(0.1,0.3,[E(u).Evalisi])
    axes(AxHdl5)
    NRHO=['Relevant dataset:'];
    for v=1:length(F)
        if strcmp(F(v).thrfile,E(u).thrfile)==1&...
                strcmp(F(v).thrds,E(u).thrds)==1
            name=F(v).ds1.seqid;
            NRHO=strvcat(NRHO, name);
        end;
        clear name;
    end;
    for v=1:length(E)
        if strcmp(E(v).thrfile,E(u).thrfile)==1&...
                strcmp(E(v).thrds,E(u).thrds)==1
            name=E(v).ds1.seqid;
            SPL=strvcat(SPL, name);
        end;
        clear name;
    end;
    LIST=[SPL;NRHO];
    display(LIST)
    text(0.1,0.3,LIST)
    %print
    clear NRHO;clear SPL;clear LIST;
    %clear ds;
    clear ds2;
end;