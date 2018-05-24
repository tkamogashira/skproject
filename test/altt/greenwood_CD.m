CFcombiselectALL=[CFcombiselect241,CFcombiselect242,CFcombiselect898,CFcombiselect8121];

for n=1:length(CFcombiselectALL)
    CFcombiselectALL(n).coch=greenwood(CFcombiselectALL(n).CF2)-greenwood(CFcombiselectALL(n).CF1);
end;

subplot(2,2,1)
linear=structfilter(CFcombiselectALL,'$pLinReg$ < 0.005');
for n=1:length(linear)
    plot(linear(n).coch, linear(n).CD, 'k.','markersize',6);hold on;
end;
nonlinear=structfilter(CFcombiselectALL,'$pLinReg$ >= 0.005');
for n=1:length(nonlinear)
    plot(nonlinear(n).coch, nonlinear(n).CD, 'ko','markersize',6);hold on;
end;
grid on;
title([{'All'},{'.:linear O:nonlinear'}]);xlabel('Delta CF on basal membrane (mm)');ylabel('CD (ms)');
axis([0 1.2 -1 1.5]);

subplot(2,2,2)
linear=structfilter(CFcombiselectALL,'$pLinReg$ < 0.005');
for n=1:length(linear)
    if linear(n).CF2 < 1000
    plot(linear(n).coch, linear(n).CD, 'k.','markersize',6);hold on;
    end;
end;
nonlinear=structfilter(CFcombiselectALL,'$pLinReg$ >= 0.005');
for n=1:length(nonlinear)
    if nonlinear(n).CF2 < 1000
    plot(nonlinear(n).coch, nonlinear(n).CD, 'ko','markersize',6);hold on;
    end;
end;
grid on;
title('CFi < 1000');xlabel('Delta CF on basal membrane (mm)');ylabel('CD (ms)');
axis([0 1.2 -1 1.5]);

subplot(2,2,3)
linear=structfilter(CFcombiselectALL,'$pLinReg$ < 0.005');
for n=1:length(linear)
    if 1000 <= linear(n).CF2 & linear(n).CF2 < 2000
    plot(linear(n).coch, linear(n).CD, 'k.','markersize',6);hold on;
    end;
end;
nonlinear=structfilter(CFcombiselectALL,'$pLinReg$ >= 0.005');
for n=1:length(nonlinear)
    if 1000 <= nonlinear(n).CF2 & nonlinear(n).CF2 < 2000
    plot(nonlinear(n).coch, nonlinear(n).CD, 'ko','markersize',6);hold on;
    end;
end;
grid on;
title('1000 <= CFi < 2000');xlabel('Delta CF on basal membrane (mm)');ylabel('CD (ms)');
axis([0 1.2 -1 1.5]);

subplot(2,2,4)
linear=structfilter(CFcombiselectALL,'$pLinReg$ < 0.005');
for n=1:length(linear)
    if 2000 <= linear(n).CF2
    plot(linear(n).coch, linear(n).CD, 'k.','markersize',6);hold on;
    end;
end;
nonlinear=structfilter(CFcombiselectALL,'$pLinReg$ >= 0.005');
for n=1:length(nonlinear)
    if 2000 <= nonlinear(n).CF2
    plot(nonlinear(n).coch, nonlinear(n).CD, 'ko','markersize',6);hold on;
    end;
end;
grid on;
title('2000 <= CFi');xlabel('Delta CF on basal membrane (mm)');ylabel('CD (ms)');
axis([0 1.2 -1 1.5]);


figure
linear=structfilter(CFcombiselectALL,'$pLinReg$ < 0.005');
for n=1:length(linear)
    x=linear(n).coch;
    y=linear(n).CF2;
    z=linear(n).CD;
    zmin=-1;zmax=1.5;m=64;
    index = fix((z-zmin)/(zmax-zmin)*m)+1;
    aaa=colormap(jet);
    CC=aaa(index,:);
    plot(x,y,'o','MarkerFaceColor',CC,'MarkerEdgeColor','k','MarkerSize',10);hold on;grid on;
end;
xlabel('Delta CF on basal membrane (mm)');ylabel('CFi (Hz)');xlim([0 1.2]);
qq=[-1;-0.5;0;0.5;1;1.5];
for k=1:length(qq)
    qqi(k,1)=fix((qq(k,1)-zmin)/(zmax-zmin)*m)+1;
end;
[qq qqi]
colorbar('YTick',qqi,'YTickLabel',qq);




