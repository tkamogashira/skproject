img = imread(file,'tif');


M = img; p = NumBinning; q = NumBinning;
    [m,n] = size(M); %M is the original matrix
    M = sum( reshape(M,p,[]) ,1 );
    M = reshape(M,m/p,[]).'; %Note transpose
    M = sum( reshape(M,q,[]) ,1);
    M = reshape(M,n/q,[]).'; %Note transpose
    img2 = M;
    
    
    function img3 = Image2Data(file_start,file_end,NumBinning)
    for fff = file_start:file_end
        fprintf('%d\n',fff);    
        img = imread(file,'tif');

        %http://mathforum.org/kb/message.jspa?messageID=6884726
        %Example for pxq binning
        M = str; p = NumBinning; q = NumBinning;
        [m,n] = size(M); %M is the original matrix
        M = sum( reshape(M,p,[]) ,1 );
        M = reshape(M,m/p,[]).'; %Note transpose
        M = sum( reshape(M,q,[]) ,1);
        M = reshape(M,n/q,[]).'; %Note transpose
        img2 = M;

        img3 = cat(2,img3,img2(:));
    end        
    end

    
    
    filename = strcat(SaveDir,'/img3.mat');
save(filename,'img3');



mimg3 = mean(img3,1);

file2 = strcat(SaveDir,'/Event.tif');
h = figure;
plot(mimg3);
saveas(h,file2,'tif');



img3 = strcat(ReadDir,'/img3.mat');
importfile(img3);



avg = nanmean(FFF(:,1:600),2)*ones(1,size(FFF,2));
DF = (FFF - avg)./avg.*100;


function outputColorMap(str6,fstart,fend,N,dir,min,max)    
% 
% Matrix to ColorMap and make tiffs
%
    for fff = fstart:fend %1:size(str6,2)
        close all;
        fprintf('%d\n',fff);
        str = str6(:,fff);
        str2 = reshape(str,N,N);
        h = figure('visible','off');
        set(h, 'PaperPositionMode', 'manual');
        set(h, 'PaperUnits', 'inches');
         %set(h,'papersize',[3 3],'PaperPosition', [0, 0, 3, 3]);

        ti(1) = 0; ti(2) = 0; ti(3) = 0; ti(4) = 0;
        pos(3) = 3; pos(4) = 3;
        
        set(gca,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);

        set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
        set(gcf, 'PaperPosition',[0 0 pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
        
        set(h,'InvertHardcopy','off')
        b = imagesc(str2);
        axis ij
        axis square
        axis off
        caxis([min max])
        
        file = strcat(dir,'/Image_',num2str(fff),'.tif');
        saveas(h,file,'tif');
    end
end


[sROI] = ReadImageJROI(RoiSetFile); 


xv = sROI{1,m}.mnCoordinates(:,1);
      yv = sROI{1,m}.mnCoordinates(:,2);
      
      
function [ROIindex,numROI] = ReadROIindex(RoiSetFile)
% RoiSetFile = '0044-0257-0253.roi'
% RoiSetFile = 'RoiSet.zip'

    [sROI] = ReadImageJROI(RoiSetFile);
    numROI = size(sROI,2);
    ROIindex = cell([1,numROI]);

    for m = 1:numROI
        xv = sROI{1,m}.mnCoordinates(:,1);
        yv = sROI{1,m}.mnCoordinates(:,2);
        index = [];

        for x = 1:512
            for y = 1:512
                B = (x-1).*512+y;
                in = inpolygon(x,y,xv,yv);
                if in == 1
                   index = cat(1,index,B);
                end
            end
        end
        ROIindex{1,m} = index;       
    end
end


RoiSetFile = strcat(RoiSavedDir,'/RoiSet.zip');
[ROIindex,numROI] = ReadROIindex(RoiSetFile);
file = strcat(RoiSavedDir,'/ROIindex.mat');
save(file,'ROIindex');


      
      



