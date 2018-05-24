CFcombiselectALL=[CFcombiselect241,CFcombiselect242,CFcombiselect898,CFcombiselect8121];


linear=structfilter(CFcombiselectALL,'$pLinReg$ < 0.005');
for n=1:length(linear)
    plot(linear(n).DeltaCF, linear(n).CD, 'ko');hold on;
end;

nonlinear=structfilter(CFcombiselectALL,'$pLinReg$ >= 0.005');
for n=1:length(nonlinear)
    plot(nonlinear(n).DeltaCF, nonlinear(n).CD, 'ro');hold on;
end;
grid on