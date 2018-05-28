%DoPeakPick --


if 1
   DataCell={...
           'C:\Data\g030313\#0',;...
           'C:\Data\g030313\#1',;...
           'C:\Data\g030313\#2',;...
           'C:\Data\g030313\#3',;...
           'C:\Data\g030313\#4',;...
           'C:\Data\g030313\#5',;...
           'C:\Data\g030313\#6',;...
           'C:\Data\g030313\#7',;...
       }
  
%  N=18;
%  DataCell=cell(N,1);
%  for ii=0:N
%      DataCell{ii}=['d:\data\G021219\#' num2str(ii)];
%  end

end

NData=size(DataCell,1);
%diary d:\data\diary.txt
for iData=1:NData
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Root=DataCell{iData,1};
    disp(Root);
    
    %Set up the data directory
    RootNameIn=Root;
    RootNameOut=fullfile(Root,'peaks');
    if exist(RootNameOut,'dir')~=7
        mkdir(Root,'peaks')
    end
    %Get stim indeces
    d=dir(fullfile(RootNameIn,'*.raw'));
    n=length(d);
    StimIdx=zeros(1,n);
    for i=1:n
        myname=d(i).name;
        [Path,Name,Ext]=fileparts(myname);
        StimIdx(i)=str2num(Name);
    end
    
    %Run peak-picking
    [NRep, PkCount]=PeakPick(RootNameIn,RootNameOut,StimIdx);
end
%diary off
