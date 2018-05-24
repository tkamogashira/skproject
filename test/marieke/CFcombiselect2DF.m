SIZE=size(CFcombiselect);
for n=1:SIZE(2)
    for m=1:51
        if strcmp(DFall(m).Fiber1,CFcombiselect(n).Fiber1)==1
            %CFcombiselectWithDF(n)=CFcombiselect(n);
            CFcombiselect(n).DF1=DFall(m).DF;break
        end;
        
    end;
end;
for N=1:SIZE(2)
    for M=1:51
        if strcmp(DFall(M).Fiber1,CFcombiselect(N).Fiber2)==1
            %CFcombiselectWithDF(N)=CFcombiselect(N);
            CFcombiselect(N).DF2=DFall(M).DF;break
        end;
    end;
end;
assignin('base','CFcombiselectWithDF',CFcombiselect);
end


    