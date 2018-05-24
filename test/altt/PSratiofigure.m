D1_Ac(57).PSTHtype='O';
for n=1:length(D1_Ac)
    semilogy(D1_Ac(n).Indepval,D1_Ac(n).PSratio,'b');hold on
    semilogy(D1_Ac(n).Indepval,D1_Ac(n).PSratio2,'r');hold on
end;

figure
for k=1:length(D1_Ac)
    if strcmp(D1_Ac(k).PSTHtype,'PHL')==1
        M=find(isfinite(D1_Ac(k).PSratio2));[C,I]=max(D1_Ac(k).PSratio2(M));plot(D1_Ac(k).Indepval(I),C,'marker','+','color','k','markersize',12);hold on;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'PLN')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));[C,I]=max(D1_Ac(k).PSratio2(M));plot(D1_Ac(k).Indepval(I),C,'marker','^','color','k','markersize',12);hold on;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'PL')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));[C,I]=max(D1_Ac(k).PSratio2(M));plot(D1_Ac(k).Indepval(I),C,'marker','o','color','k','markersize',12);hold on;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'C')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));[C,I]=max(D1_Ac(k).PSratio2(M));plot(D1_Ac(k).Indepval(I),C,'marker','*','color','k','markersize',12);hold on;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'O')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));[C,I]=max(D1_Ac(k).PSratio2(M));plot(D1_Ac(k).Indepval(I),C,'marker','s','color','k','markersize',12);hold on;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oi')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));[C,I]=max(D1_Ac(k).PSratio2(M));plot(D1_Ac(k).Indepval(I),C,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;clear M;clear C;clear I;
    %elseif strcmp(D1_Ac(k).PSTHtype,'OL')==1;
        %M=find(isfinite(D1_Ac(k).PSratio2));[C,I]=max(D1_Ac(k).PSratio2(M));plot(D1_Ac(k).Indepval(I),C,'marker','s','color','k','markersize',12);hold on;
        %plot(D1_Ac(k).Indepval(I),C,'marker','s','color','k','markersize',6);hold on;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oc')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));[C,I]=max(D1_Ac(k).PSratio2(M));plot(D1_Ac(k).Indepval(I),C,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'X')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));[C,I]=max(D1_Ac(k).PSratio2(M));plot(D1_Ac(k).Indepval(I),C,'marker','x','color','k','markersize',12);hold on;clear M;clear C;clear I;
    else
        clear M;clear C;clear I;
    end;
end;

figure
for k=1:length(D1_Ac)
    if strcmp(D1_Ac(k).PSTHtype,'PHL')==1
        M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','+','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'PLN')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','^','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'PL')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','o','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'C')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','*','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'O')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','s','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oi')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;end;clear M;clear C;clear I;
    %elseif strcmp(D1_Ac(k).PSTHtype,'OL')==1;
        %M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','s','color','k','markersize',12);hold on;
        %loglog(D1_Ac(k).CF,C,'marker','s','color','k','markersize',6);hold on;end;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oc')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;end;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'X')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','x','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
    else
        clear M;clear C;clear I;
    end;
end;

%max P/Sratio2 plot infinity in the gutter
figure
for k=1:length(D1_Ac)
    if strcmp(D1_Ac(k).PSTHtype,'PHL')==1
        if nnz(isinf(D1_Ac(k).PSratio2))>0
            loglog(D1_Ac(k).CF,1000,'marker','+','color','k','markersize',12);hold on;
        else
            M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','+','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
        end;
    elseif strcmp(D1_Ac(k).PSTHtype,'PLN')==1;
        if nnz(isinf(D1_Ac(k).PSratio2))>0
            loglog(D1_Ac(k).CF,1000,'marker','^','color','k','markersize',12);hold on;
        else
            M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','^','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
        end;
    elseif strcmp(D1_Ac(k).PSTHtype,'PL')==1;
        if nnz(isinf(D1_Ac(k).PSratio2))>0
            loglog(D1_Ac(k).CF,1000,'marker','o','color','k','markersize',12);hold on;
        else
            M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','o','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
        end;
    elseif strcmp(D1_Ac(k).PSTHtype,'C')==1;
        if nnz(isinf(D1_Ac(k).PSratio2))>0
            loglog(D1_Ac(k).CF,1000,'marker','*','color','k','markersize',12);hold on;
        else
            M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','*','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
        end;
    elseif strcmp(D1_Ac(k).PSTHtype,'O')==1;
        if nnz(isinf(D1_Ac(k).PSratio2))>0
            loglog(D1_Ac(k).CF,1000,'marker','s','color','k','markersize',12);hold on;
        else
            M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','s','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
        end;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oi')==1;
        if nnz(isinf(D1_Ac(k).PSratio2))>0
            loglog(D1_Ac(k).CF,1000,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;
        else
            M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;end;clear M;clear C;clear I;
        end;
    %elseif strcmp(D1_Ac(k).PSTHtype,'OL')==1;
        %M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','s','color','k','markersize',12);hold on;
        %loglog(D1_Ac(k).CF,C,'marker','s','color','k','markersize',6);hold on;end;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oc')==1;
        if nnz(isinf(D1_Ac(k).PSratio2))>0
            loglog(D1_Ac(k).CF,1000,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;
        else
            M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;end;clear M;clear C;clear I;
        end;
    elseif strcmp(D1_Ac(k).PSTHtype,'X')==1;
        if nnz(isinf(D1_Ac(k).PSratio2))>0
            loglog(D1_Ac(k).CF,1000,'marker','x','color','k','markersize',12);hold on;
        else
            M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=max(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','x','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
        end;
    else
        clear M;clear C;clear I;
    end;
end;

%min P/Sratio2 plot infinity in the gutter
figure
for k=1:length(D1_Ac)
    if strcmp(D1_Ac(k).PSTHtype,'PHL')==1
        M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=min(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','+','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'PLN')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=min(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','^','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'PL')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=min(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','o','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'C')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=min(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','*','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'O')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=min(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','s','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oi')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=min(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','s','color','k','markerfacecolor','k','markersize',12);hold on;end;clear M;clear C;clear I;
    %elseif strcmp(D1_Ac(k).PSTHtype,'OL')==1;
        %M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=min(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','s','color','k','markersize',12);hold on;
        %loglog(D1_Ac(k).CF,C,'marker','s','color','k','markersize',6);hold on;end;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'Oc')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=min(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','s','color','k','markerfacecolor',[0.8 0.8 0.8],'markersize',12);hold on;end;clear M;clear C;clear I;
    elseif strcmp(D1_Ac(k).PSTHtype,'X')==1;
        M=find(isfinite(D1_Ac(k).PSratio2));if isnan(M)==0,[C,I]=min(D1_Ac(k).PSratio2(M));loglog(D1_Ac(k).CF,C,'marker','x','color','k','markersize',12);hold on;end;clear M;clear C;clear I;
    else
        clear M;clear C;clear I;
    end;
end;