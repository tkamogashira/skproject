clear all;
close all;
 
date = input('date: ');
 
d = strcat(home,'/dataa/monai/Leica/',state2,num2str(date));
NumDir = dir(d);
for nn = 1:size(NumDir,1)-2
    c = strcat(home,'/dataa/monai/Leica/',state2,num2str(date),'/data',num2str(nn));
    NumDir2 = dir(c);
    for dd = 1:size(NumDir2,1)-2
        a = strcat(home,'/dataa/monai/Leica/',state2,num2str(date),'/data',num2str(nn),'/data',num2str(dd));
        A = dir(a);
 
        b = strcat(home,'/dataa/monai/Leica/',state2,num2str(date),' analysis/data',num2str(nn),'/data',num2str(dd));
        mkdir(b);
 
        fmax = size(A,1)-2;
        ffmax = fmax;
        
        str4 = Image2Data2(a,b,dd,1,ffmax,8);
    end
end




















function str4 = Image2Data2(a,b,dd,file_start,file_end,N) %,pl    
% 
% nn:folder name
% N: ‰æ‘œ‚ð‰½•ª‚Ì‚P‚É‚·‚é‚©
%
str4=[];
for fff = file_start:file_end
    
    file = strcat(a,'/Image',num2str(dd),'_',num2str(fff),'.tif'); %num2str(fff,pl)
    %file = strcat(a,'/Image',num2str(fff,'%10.4d'),'.tif'); %num2str(fff,pl)
    
    %pl = strcat('%10.',num2str(fix(log10(file_end*10)+1)),'d');
    %file = strcat(a,'/Image',num2str(dd),'_',num2str(fff,pl),'.tif'); 
    
    fprintf('%d\n',fff);    
    str = imread(file,'tif');
 
    %http://mathforum.org/kb/message.jspa?messageID=6884726
    %Example for pxq binning
    M=str; p = N; q = N;
    [m,n]=size(M); %M is the original matrix
    M=sum( reshape(M,p,[]) ,1 );
    M=reshape(M,m/p,[]).'; %Note transpose
    M=sum( reshape(M,q,[]) ,1);
    M=reshape(M,n/q,[]).'; %Note transpose
    str3 = M;
    
    str4 = cat(2,str4,str3(:));
end        
 
%str4 = (str3 - mean(str3(:)))./mean(str3(:));
%str4 = str3;
fstr = strcat(b,'/str512.mat');
save(fstr,'str4');
 
mstr = mean(str4);
 
file2 = strcat(b,'/Event.tif');
h = figure;
plot(mstr);
saveas(h,file2,'tif');
end

