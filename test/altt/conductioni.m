function conductioni(S)

for n=1:length(S)-1
    
    if S(n).BP==0
        previousset=[S(n).Order;n];
        for p=1:(S(n).Order-2)%remove segment with order1 becuse it is before FB
            previous=[];
            for k=(n+1):length(S)-1%remove segment with order1 becuse it is before FB
                if S(k).Order == S(n).Order - p
                    previous=[previous k];
                end;
            end
            previousset=[previousset ([(S(n).Order - p);previous(1)])];
            clear previous;
        end;
        S(n).previousset=previousset;
        clear previousset;
    else
        S(n).previousset=[0;0];
    end;
end;
for n=length(S)
    S(n).previousset=[0;0];
end;

for n=1:length(S)
    if S(n).BP==0
        seglengthall=S(n).SectionLength;
        avgdiaall=S(n).AvgDiameter;
        ctall=(S(n).SectionLength/1000)/(S(n).AvgDiameter*9.167);
        for p=2:size(S(n).previousset,2)
            m=S(n).previousset(2,p);
            seglength=S(m).SectionLength;
            seglengthall=[seglengthall seglength];clear seglength;
            avgdia=S(m).AvgDiameter;
            avgdiaall=[avgdiaall avgdia];clear avgdia;
            ct=(S(m).SectionLength/1000)/(S(m).AvgDiameter*9.167);
            ctall=[ctall ct];clear ct;
        end;
        S(n).seglengthall=seglengthall;clear seglengthall;
        S(n).avgdiaall=avgdiaall;clear avgdiaall;
        S(n).ctall=ctall;clear ctall;
    else
        S(n).seglengthall=0;
        S(n).avgdiaall=0;
        S(n).ctall=0;
    end;
end;

for n=1:length(S)
    S(n).ctsum=sum(S(n).ctall);
end;

assignin('base',[inputname(1) '_conduction'],S);
end



    
    
