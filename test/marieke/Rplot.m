
D1_Ac_R=structfilter(D1_Ac,'isnan($maxR$)==0');
D1_Ac_RN=structfilter(D1_Ac,'isnan($maxR$)');
for n=1:length(D1_Ac_RN)
    D1_Ac_RN(n).dummyR=0;
end;
for n=1:length(D1_A_RN)
    D1_A_RN(n).dummyR=0;
end;


D1_Bc_R=structfilter(D1_Bc,'isnan($maxR$)==0');
D1_Bc_RN=structfilter(D1_Bc,'isnan($maxR$)');
for n=1:length(D1_Bc_RN)
    D1_Bc_RN(n).dummyR=0;
end;
for n=1:length(D1_B_RN)
    D1_B_RN(n).dummyR=0;
end;


structplot(D1_Ac_R,'StimFreq','maxR',D1_Ac_RN,'StimFreq','dummyR',...
    D1_Bc_R,'StimFreq','maxR',D1_Bc_RN,'StimFreq','dummyR',...
    D1_A_R,'StimFreq','maxR',D1_A_RN,'StimFreq','dummyR',...
    D1_B_R,'StimFreq','maxR',D1_B_RN,'StimFreq','dummyR',...
    'markers',{'*','*','*','*','o','o','o','o'}, 'Colors',{'r','m','b','c','r','m','b','c'})
figure
structplot(D1_Ac_R,'StimFreq','maxR',D1_Ac_RN,'StimFreq','dummyR',...
    D1_Bc_R,'StimFreq','maxR',D1_Bc_RN,'StimFreq','dummyR',...
    'markers',{'*','*','*','*'}, 'Colors',{'r','m','b','c'})

