function ComData = datasetcom(DS1,DS2);
[ArgOut,BF,BP,CD,CP,CF1,CF2]=EvalFS3(DS1,DS2, 'plotmode', 'ALL');
Fiber1=[num2str(getfield(DS1,'ID','FileName')),' ',num2str(getfield(DS1,'ID','SeqID'))];
Fiber2=[num2str(getfield(DS2,'ID','FileName')),' ',num2str(getfield(DS2,'ID','SeqID'))];
ComData(1)=struct('Fiber1',Fiber1,'Fiber2',Fiber2,'BF',BF,'BP',BP,'CD',CD,'CP',CP,'CF1',CF1,'CF2',CF2);
assignin('base','ComData',ComData);
end

    