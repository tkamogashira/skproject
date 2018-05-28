%DoMakeStimAndPstEz --


if 1
   DataCell={...
           'd:\data\G030123\#0',;...
           'd:\data\G030123\#1',;...
           'd:\data\G030123\#2',;...
           'd:\data\G030123\#3',;...
           'd:\data\G030123\#4',;...
           'd:\data\G030123\#5',;...
           'd:\data\G030123\#6',;...
           'd:\data\G030123\#7',;...
           'd:\data\G030123\#9',;...
       }
  
%  N=18;
%  DataCell=cell(N+1,1);
%  for ii=0:N
%      DataCell{ii+1}=['d:\data\G021219\#' num2str(ii)];
%  end

end

NData=size(DataCell,1);
%diary d:\data\diary.txt
for iData=1:NData
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Root=DataCell{iData,1};
    disp(Root);    
    %Run
    [StimIdx,pst]=MakeStimAndPstEz(Root);
end
%diary off
