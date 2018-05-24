for n=1:length(sacxac615_A1000)
    
    ds = dataset(sacxac615_A1000(n).ds1.filename, sacxac615_A1000(n).ds1.seqid);
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
    text(0.5,0.5,[sacxac615_A1000(n).ds1.filename ' ' sacxac615_A1000(n).ds1.seqid])
    %print
    close
    clear k;
    
    %aa=D1_Ac(n).thrfile;bb=D1_Ac(n).thrds;
    for x=1:length(Dthr186)
        if strcmp(Dthr186(x).ds.filename,sacxac615_A1000(n).thrfile)==1 & strcmp(Dthr186(x).ds.seqid,sacxac615_A1000(n).thrds)==1
            xxx=x;note=1;
        else
            note=0;
        end;
    end;
    
    if note==1 & Dthr186(xxx).tag~=0
        FigHdl = figure('NumberTitle', 'off', ...
            'Units', 'normalized', ...
            'OuterPosition', [0 0.025 1 0.975], ... %Maximize figure (not in the MS Windows style!) ...
            'PaperType', 'A4', ...
            'PaperPositionMode', 'manual', ...
            'PaperUnits', 'normalized', ...
            'PaperPosition', [0.05 0.05 0.90 0.90], ...
            'PaperOrientation', 'landscape');

        AxHdl_thr = axes('Position', [0.10 0.80 0.8 0.20], 'Visible', 'off');
        THRtext=strvcat(['ThrData lost'],['CF: ' num2str(D(n).CF) 'Hz'],['THR: ' num2str(D(n).THR) 'dB']);
        text(0.1,0.5,THRtext)
    else
        ds2 = dataset(sacxac615_A1000(n).thrfile,sacxac615_A1000(n).thrds);
        evalTHRs(ds2)
        figure(FigHdl)
        
    end;
    clear xxx;clear note;
    
    AxHdl2 = axes('Position', [0.10 0.10 0.40 0.15])
    AxHdl3 = axes('Position', [0.10 0.30 0.40 0.15])
    AxHdl4 = axes('Position', [0.55 0.50 0.20 0.30], 'Visible', 'off')
    AxHdl5 = axes('Position', [0.75 0.50 0.20 0.30], 'Visible', 'off')
    
    assignin('base','AxHdl2',AxHdl2);
    assignin('base','AxHdl3',AxHdl3);
    assignin('base','AxHdl4',AxHdl4);
    assignin('base','AxHdl5',AxHdl5);
    
    axes(AxHdl2)
    line(Mis1,Mis2);xlabel('Rho');ylabel('#Mistrigger');
    axes(AxHdl3)
    line(Mis1,Mis3);xlabel('Rho');ylabel('#Mistrigger/#TotalTrigger');
    axes(AxHdl4)
    text(0.1,0.95,[sacxac615_A1000(n).ds1.filename ' ' sacxac615_A1000(n).ds1.seqid ' depth: ' num2str(sacxac615_A1000(n).depth)],'FontSize',16)
    if sacxac615_A1000(n).approach==2
        text(0.1,0.8,'Midline approach')
    else
        text(0.1,0.8,'Transbulla approach')
    end;
    if sacxac615_A1000(n).RecSide==1
        text(0.1,0.7,'RecSide: Left')
    else
        text(0.1,0.7,'RecSide: Right')
    end;
    if sacxac615_A1000(n).StimSide==1
        text(0.1,0.6,'StimSide: Left')
    else
        text(0.1,0.6,'StimSide: Right')
    end;
    text(0.1,0.4,'Subjective evaluation of ISI:')
    text(0.1,0.3,[sacxac615_A1000(n).Evalisi])
    axes(AxHdl5)
    LIST=['Relevant dataset:'];
    for v=1:length(D1_Ac)
        if strcmp(D1_Ac(v).thrfile,sacxac615_A1000(n).thrfile)==1&...
                strcmp(D1_Ac(v).thrds,sacxac615_A1000(n).thrds)==1
            name=[D1_Ac(v).ds1.seqid ' PSTHtype = ' D1_Ac(v).PSTHtype];
            LIST=strvcat(LIST, name);
        end;
        clear name;
    end;
    for v=1:length(sacxac615_A1000)
        if strcmp(sacxac615_A1000(v).thrfile,sacxac615_A1000(n).thrfile)==1&...
                strcmp(sacxac615_A1000(v).thrds,sacxac615_A1000(n).thrds)==1
            name=sacxac615_A1000(v).ds1.seqid;
            LIST=strvcat(LIST, name);
        end;
        clear name;
    end;
    
    display(LIST)
    text(0.1,0.3,LIST)
    print %%%%%use this when you print
    clear NRHO;clear SPL;clear LIST;
    %clear ds;
    clear ds2;
    %close
    
    
end;


