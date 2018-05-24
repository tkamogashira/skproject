function dendrogramc3(S)

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
MM=structfield(S,'Length');
blockx=(1:1:max(MM));
blocky=zeros(1,max(MM));
blockz=zeros(1,max(MM));

for n=1:length(S)-1
    line([S(n).Length-S(n).SectionLength S(n).Length],[S(n).AvgDiameter S(n).AvgDiameter],...
        'marker','none');hold on;
    line([S(n).Length-S(n).SectionLength S(n).Length-S(n).SectionLength],[S(S(n).previous).AvgDiameter S(n).AvgDiameter],...
        'marker','none');hold on;
    %make horizontal points
    hp=(ceil(S(n).Length-S(n).SectionLength):1:floor(S(n).Length));
    S(n).pointX=hp;
    S(n).pointY=ones(1,size(hp,2))*(S(n).AvgDiameter);
    
    blocky(hp)=blocky(hp) + ones(1,size(hp,2))*(S(n).AvgDiameter);
    blockz(hp)=blockz(hp) + ones(1,size(hp,2));
    
    if S(n).BP==0
        plot(S(n).Length,S(n).AvgDiameter,'ro');hold on;
    end;
end;
for n=length(S)
    line([S(n).Length-S(n).SectionLength S(n).Length],[S(n).AvgDiameter S(n).AvgDiameter],...
        'marker','none');hold on;
    %attention! '+1'
    hp=(ceil(S(n).Length-S(n).SectionLength)+1:1:floor(S(n).Length));
    S(n).pointX=hp;
    S(n).pointY=ones(1,size(hp,2))*(S(n).AvgDiameter);
    
    blocky(hp)=blocky(hp) + ones(1,size(hp,2))*(S(n).AvgDiameter);
    blockz(hp)=blockz(hp) + ones(1,size(hp,2));
    
    
end;

plot(blockx, blocky./blockz, 'g');

hold off;

title([inputname(1) '_dendrogram']);
xlabel('Axonal length from ML (\mum)');xlim([0 8000]);
ylabel('Mean diameter of segment (\mum)');ylim([0 3.5]);
assignin('base',[inputname(1) '_dendrogram'],S);

assignin('base',[inputname(1) '_meandiameter'],[blockx;blocky./blockz]);
end