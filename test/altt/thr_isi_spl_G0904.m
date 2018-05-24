


for u=1:length(D)
    ds = dataset(D(u).ds1.filename, D(u).ds1.seqid);
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
    text(0.5,0.5,[D(u).ds1.filename ' ' D(u).ds1.seqid])
    %print
    close
    clear k;
    
    %aa=D1_Ac(u).thrfile;bb=D1_Ac(u).thrds;
    for x=1:length(Dthr36)
        if strcmp(Dthr36(x).ds.filename,D(u).thrfile)==1 & strcmp(Dthr36(x).ds.seqid,D(u).thrds)==1
            xxx=x;
        end;
    end;
    
    if Dthr36(xxx).tag==0
        ds2 = dataset(D(u).thrfile,D(u).thrds);
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
        THRtext=strvcat(['ThrData lost'],['CF: ' num2str(D(u).CF) 'Hz'],['THR: ' num2str(D(u).THR) 'dB']);
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
    text(0.1,0.95,[D(u).ds1.filename ' ' D(u).ds1.seqid ' depth: ' num2str(D(u).depth)])
    if D(u).approach==2
        text(0.1,0.8,'Midline approach')
    else
        text(0.1,0.8,'Transbulla approach')
    end;
    if D(u).RecSide==1
        text(0.1,0.7,'RecSide: Left')
    else
        text(0.1,0.7,'RecSide: Right')
    end;
    if D(u).StimSide==1
        text(0.1,0.6,'StimSide: Left')
    else
        text(0.1,0.6,'StimSide: Right')
    end;
    text(0.1,0.4,'Subjective evaluation of ISI:')
    text(0.1,0.3,[D(u).Evalisi])
    axes(AxHdl5)
    LIST=['Relevant dataset:'];
    for v=1:length(F)
        if strcmp(F(v).thrfile,D(u).thrfile)==1&...
                strcmp(F(v).thrds,D(u).thrds)==1
            name=F(v).ds1.seqid;
            LIST=strvcat(LIST, name);
        end;
        clear name;
    end;
    for v=1:length(D)
        if strcmp(D(v).thrfile,D(u).thrfile)==1&...
                strcmp(D(v).thrds,D(u).thrds)==1
            name=D(v).ds1.seqid;
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