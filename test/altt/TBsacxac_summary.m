for n=41:86 %length(sacxac615_A1000)
    ds=dataset(sacxac615_A1000(n).ds1.filename,sacxac615_A1000(n).ds1.seqid);
    T = EvalSACXAC(ds, [+1, -1], 'anwin', [50 1000],'plot','yes');
    print
    clear T;
    
    figure
    % confidence level of peak sign, based on 100 Monte Carlo trials
    % p is the confidence level. See help SACPeakSign.
    binwidth=0.05;Ntrial=100;AnaWindow=[50 1000];
    
    SPT = AnWin(ds, AnaWindow);
    SPT1=SPT(1,:);
    SPT2=SPT(2,:);
    
    % have a look at the sac (not needed for CI stats, but for getting the normalization)
    Dur = diff(AnaWindow); % duration in ms - needed for normalization
    [Sac1, tau1, Norm1] = sptcorr(SPT1, 'nodiag', 3, binwidth, Dur, 'DriesNorm');
    [Sac2, tau2, Norm2] = sptcorr(SPT2, 'nodiag', 3, binwidth, Dur, 'DriesNorm');
    subplot(3,1,1);
    plot(tau1, Sac1,'-');hold on
    plot(tau2, Sac2,'--');hold off
    xlabel('tau (ms)');
    ylabel('SAC');
    
    [p1, NcoScrambled1, Ppdf1, Pcdf1, Nco1] = SACPeakSign(SPT1, binwidth, Ntrial);
    [p2, NcoScrambled2, Ppdf2, Pcdf2, Nco2] = SACPeakSign(SPT2, binwidth, Ntrial);
    % NcoScrambled is the X-axis of the Nco distrib (see help SACpeakSign)
    % By applying Dries' normalization, it is turned into the X axis of the CI distribution
    CIscrambled1 = NcoScrambled1/Norm1.DriesNorm;
    CIscrambled2 = NcoScrambled2/Norm2.DriesNorm;
    subplot(3,1,2);
    plot(CIscrambled1,Pcdf1,'-');hold on
    plot(CIscrambled2,Pcdf2,'--');hold off
    ylim([-0.05 1.05]); % save visibility of horizontal asymptotes
    xlabel('CI');
    ylabel('cumulative CI distr');
    
    % text box with summary
    icenter1 = ceil(length(Sac1)/2);% index of central Sac peak
    icenter2 = ceil(length(Sac2)/2);
    CI1 = Sac1(icenter1);
    CI2 = Sac2(icenter2);
    subplot(3,1,3); set(gca,'xtick',[], 'ytick',[], 'box', 'on');
    text(0.1, 0.8, [ds.title ' subseq 1 (' ds.x.ShortName ' = ' num2str(ds.xval(1)) ' ' ds.xunit ')']);
    text(0.1, 0.7, ['CI = ' num2str(CI1)])
    text(0.1, 0.6, ['Confidence level = ' num2str(100*p1) ' % (N=' num2str(Ntrial) ')']);
    text(0.1, 0.3, [ds.title ' subseq 2 (' ds.x.ShortName ' = ' num2str(ds.xval(2)) ' ' ds.xunit ')']);
    text(0.1, 0.2, ['CI = ' num2str(CI2)])
    text(0.1, 0.1, ['Confidence level = ' num2str(100*p2) ' % (N=' num2str(Ntrial) ')']);
    
    print
    close all
end;

