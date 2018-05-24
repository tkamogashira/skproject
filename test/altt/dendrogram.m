function dendrogram(S)

for n=1:length(S)-1
    previous=[];
    for k=(n+1):length(S)
        if S(k).Order == S(n).Order - 1
            previous=[previous k];
        end;
    end
    S(n).previous=previous(1);
    clear previous;
end;
for n=1:length(S)-1
    line([S(n).MLtoSegEnd-S(n).SectionLength S(n).MLtoSegEnd],[S(n).AvgDiameter S(n).AvgDiameter],...
        'marker','none');hold on;
    line([S(n).MLtoSegEnd-S(n).SectionLength S(n).MLtoSegEnd-S(n).SectionLength],[S(S(n).previous).AvgDiameter S(n).AvgDiameter],...
        'marker','none');hold on;
    if S(n).BP==0
        plot(S(n).MLtoSegEnd,S(n).AvgDiameter,'ro');hold on;
    end;
end;
for n=length(S)
    line([S(n).MLtoSegEnd-S(n).SectionLength S(n).MLtoSegEnd],[S(n).AvgDiameter S(n).AvgDiameter],...
        'marker','none');hold on;
end;hold off;

assignin('base','',S);
end