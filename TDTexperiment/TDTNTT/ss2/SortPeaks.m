%function SortPeaks(Root,FileIdx,PstRange)
%SortPeaks -- Sort the candidate spikes with easy GUI methed
%Extract samples of peak waveforms from specified file(s), and
%show PCA plot to determine template waveform. Then, root of sum of
%square differences (RSSDs) between the template and the peak waveforms
%to determine criterion RSSDs.
%
%Usage: SortPeaks(Root,FileIdx,PstRange,PeakSign)
%Root: Root directory for the data, eg, 'C:\shig\data\G010521\Unit010521_1_adapt1'
%FileIdx: Indeces to files that are used, eg., [0 3 5]
%PstRange: (Optional) 2-elements vector; Time range for analysis in ms (default all)
%PeakSign: (Optional) scalar; Positve, and negative numbers to indicate using only positive and negative
%               peaks, respectively. Zero indicates either signes. (default +1)
%
%The results will be saved in fullfile(Root,'Criterion') as a mat-file
%	The file will have the following variables:
%	 myTemplate : NPts-by-1 vector (NPts: number of points for one peak waveform)
%	 myIRange : Indeces for the template and the peak waveforms used for the sorting
%	 myCutRSSD : Criterion RSSD
%	 PkRoot, FileIdx (as the inputs)
%
%BY SF, 11/21/02

% if nargin<3
%     PstRange=[-inf inf];
% end

%Filenames
PkRoot=fullfile(Root,'peaks');
OutFName=fullfile(Root,'Criterion2');

%Load info about the peak files
CountFName=fullfile(PkRoot,'Count');
load(CountFName,'NRep');
NRep=NRep(FileIdx);

%Load peaks from the files and make a big matrix of peak waveforms
nFileIdx=length(FileIdx);
BigPeakMat=[];
BigStimTrlRegMat=[];
h=waitbar(0,'Loading Peaks...');
for iFile=1:nFileIdx
    PkFile=fullfile(PkRoot,sprintf('%03d.pk',FileIdx(iFile))); %Peak file name
    [peakmat, reg, srate]=pkload2(PkFile, 1); %Load 
    
    %Select time range
    if ~isempty(peakmat)
        I=find(reg(:,2)/100>=PstRange(1) & reg(:,2)/100<=PstRange(2));
        peakmat=peakmat(:,I);
        reg=reg(I,:);
    end
    
    %Append
    BigPeakMat=[BigPeakMat peakmat];
    n=size(reg,1);
    BigStimTrlRegMat=[BigStimTrlRegMat; [zeros(n,1)+FileIdx(iFile) reg]];
    
    waitbar(iFile/nFileIdx);
end
close (h);


tick=1e6/srate;
clear peakmat
%Determine number of time ticks
halfnpts=floor(size(BigPeakMat,1)/2);
t=(-halfnpts:halfnpts)*tick;
[mymin,It0]=min(abs(t)); %Index for the peak point

%
NTrial=size(unique(BigStimTrlRegMat,'rows'),1);
%NTrial=length(unique(BigRegMat(:,1)));

%Remove peaks if there are too many
if size(BigPeakMat,2)>2000
    skip=floor(size(BigPeakMat,2)/2000);  
else
    skip=1;
end
BigPeakMat=BigPeakMat(:,1:skip:end);
BigStimTrlRegMat=BigStimTrlRegMat(1:skip:end,:);

% if 0
%     RedoIdx=1;
%     while(1)
%         
%         if RedoIdx<=1
%         end        
figure(1)
hPk=plot(t(:),BigPeakMat,'b-');

figure(2)
[U,S,V]=svd(BigPeakMat',0); %PCA
subplot(1,3,1);
hU12=plot(U(:,1),U(:,2),'b.');
xlabel('PC1');
ylabel('PC2');
subplot(1,3,2);
hU13=plot(U(:,1),U(:,3),'b.');
xlabel('PC1');
ylabel('PC3');
subplot(1,3,3);
hU23=plot(U(:,2),U(:,3),'b.');
xlabel('PC2');
ylabel('PC3');

ZeroOne=ones(size(BigPeakMat,2),1);
while(1)
    rtn=input('Criterion No.: ');
    if isempty(rtn)
        break;
    end
    
    if rtn==0
        figure(1);
        [x,y]=ginput(2);
        if length(x)==2
            x(1:2)=x(1);
            y=sort(y);
            myy=y;
            if y(2)>max(ylim)
                y(2)=inf;
                myy(2)=max(ylim);
            elseif y(1)<min(ylim)
                y(1)=-inf;
                y(1)=min(ylim);
            end
            [dum,I]=min(abs(t-x(1)));
            myZeroOne=(BigPeakMat(I,:)>=min(y) & BigPeakMat(I,:)<=max(y));
            ZeroOne=ZeroOne.*myZeroOne(:);
            hold on
            plot(x,myy,'k.-');
            hold off
        end
    elseif rtn==1
        figure(2);
        subplot(1,3,1)
        [x,y]=ginput;
        if length(x)>2
            X=[x(:); x(1)];
            Y=[y(:); y(1)];
            myZeroOne=inpolygon(U(:,1),U(:,2),X,Y);
            ZeroOne=ZeroOne.*myZeroOne(:);
            I=find(ZeroOne);
            %Draw box indicating the selected area
            hold on
            plot(X,Y,'k-');
            hold off
            
        end
    elseif rtn==2
        figure(2);
        subplot(1,3,2)
        [x,y]=ginput;
        if length(x)>2
            X=[x(:); x(1)];
            Y=[y(:); y(1)];
            myZeroOne=inpolygon(U(:,1),U(:,3),X,Y);
            ZeroOne=ZeroOne.*myZeroOne(:);
            I=find(ZeroOne);
            %Draw box indicating the selected area
            hold on
            plot(X,Y,'k-');
            hold off
        end
    elseif rtn==3
        figure(2);
        subplot(1,3,3)
        [x,y]=ginput;
        if length(x)>2
            X=[x(:); x(1)];
            Y=[y(:); y(1)];
            myZeroOne=inpolygon(U(:,2),U(:,3),X,Y);
            ZeroOne=ZeroOne.*myZeroOne;
            %Draw box indicating the selected area
            hold on
            plot(X,Y,'k-');
            hold off
            
        end 
    end
    
    I=find(ZeroOne);
    figure(1)
       set(hPk,'Color','b');
    set(hPk(I),'Color','r');
    figure(2)
    subplot(1,3,1);
    hU12=plot(U(:,1),U(:,2),'b.',U(I,1),U(I,2),'r.');
    xlabel('PC1');
    ylabel('PC2');
        subplot(1,3,2);
    hU12=plot(U(:,1),U(:,3),'b.',U(I,1),U(I,3),'r.');
    xlabel('PC1');
    ylabel('PC3');
    subplot(1,3,3);
    hU12=plot(U(:,2),U(:,3),'b.',U(I,2),U(I,3),'r.');
    xlabel('PC1');
    ylabel('PC3');


    
    
    
end
%         
%         
%         if 0      
%             
%             
%             
%             
%             
%             
%             
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             % Determine time range used for the analysis
%             
%             %Display STD of amplitude at each time point
%             figure(1)
%             
%             
%             
%             subplot(2,1,1);
%             [n,x]=hist(BigPeakMat',128);
%             n=n./repmat(max(n),[128,1]);
%             colormap(jet(128));       
%             imagesc(t,x,n);
%             set(gca,'YDir','normal');
%             xlabel('Time re peak (ms)')
%             ylabel('Amplitude')        
%             subplot(2,1,2)
%             plot(t,std(BigPeakMat'),'b.-')
%             xlim([min(t) max(t)])
%             xlabel('Time re peak (ms)')
%             ylabel('STD')
%             
%             %Set cut threshold
%             subplot(2,1,1);
%             myxlim=xlim;
%             myylim=ylim;
%             disp('Specify upper and lower thresh (RET to end)')
%             ZeroOneCutThresh=ones(1,size(BigPeakMat,2));
%             while(1)
%                 [x,y]=ginput(2);
%                 if isempty(x)
%                     break;
%                 elseif min(x)<min(myxlim) | max(x)>max(myxlim)
%                     break;
%                 end
%                 [mymin,Ix]=min(abs(t-x(1))); %Index for the peak point
%                 myZeroOne=(BigPeakMat(Ix,:)>=min(y) & BigPeakMat(Ix,:)<=max(y));
%                 ZeroOneCutThresh=ZeroOneCutThresh.*myZeroOne;
%                 
%                 hold on
%                 plot([1; 1]*t(Ix),y,'w.-');
%                 xlim(myxlim);
%                 ylim(myylim);
%                 hold off
%             end
%             ISkip2=find(ZeroOneSkip.*ZeroOneCutThresh);
%             
%             %Prompt for time range to analyze
%             subplot(2,1,2);
%             disp('Specify time range (RET for all)')
%             [x,y]=ginput(2);
%             if length(x)<2
%                 if length(x)<1
%                     TRange=[min(t) max(t)];
%                 else
%                     TRange=[x max(t)];
%                 end
%             else
%                 TRange=sort(x);
%             end
%             myIRange=find(t>=min(TRange) & t<=max(TRange));
%             hold on
%             plot(t(myIRange),std(BigPeakMat(myIRange,:)'),'r.-')
%             hold off
%         end
%         
%         if RedoIdx<=2
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             % Run PCA and select peak waveforms to make a template
%             [U,S,V]=svd(BigPeakMat(myIRange,ISkip2)',0); %PCA
%             myxlim=[];
%             myylim=[];
%             while(1) %Repeat until finding the best selection
%                 
%                 %Plot PC2 vs PC1
%                 figure(2)
%                 plot(U(:,1),U(:,2),'.')
%                 
%                 %Use the axes limits that were set before
%                 if ~isempty(myxlim)&~isempty(myylim)
%                     xlim(myxlim)
%                     ylim(myylim);
%                 end
%                 
%                 %Select the area. You can adjust axes properties in the KEYBOARD prompt that is
%                 %evoked by clicking outside the current axes limits.
%                 while(1)
%                     disp('Specify corners (>2) of a the selection and hit return (<3 for KEYBOARD)');
%                     [x,y]=ginput;
%                     
%                     %Remember the current limits
%                     myxlim=xlim; 
%                     myylim=ylim;
%                     %Evoke KEYBOARD prompt if less than 3 points were selected, otherwise, use it as the selection
%                     if length(x)<3
%                         keyboard
%                     else
%                         break;
%                     end
%                 end %while(1)
%                 
%                 %Remember the current axes limits
%                 myxlim=xlim;
%                 myylim=ylim;
%                 
%                 %Coordinates of the polygon
%                 X=[x(:); x(1)];
%                 Y=[y(:); y(1)];
%                 
%                 %Draw box indicating the selected area
%                 hold on
%                 plot(X,Y,'k-');
%                 hold off
%                 %Find peak waveforms that fall in the selected area
%                 %            ISelect=find(U(:,1)>=x(1) & U(:,1)<=x(2) & U(:,2)>=y(1) & U(:,2)<=y(2));
%                 ISelect=find(inpolygon(U(:,1),U(:,2),X,Y));
%                 %Show the selected waveforms by red lines.
%                 figure(3)
%                 %plot(t(myIRange),BigPeakMat(myIRange,ISkip),'b-',t(myIRange),BigPeakMat(myIRange,ISkip(ISelect)),'r-');
%                 plot(t(myIRange),BigPeakMat(myIRange,ISkip1),'b-',t(myIRange),BigPeakMat(myIRange,ISkip2(ISelect)),'r-');
%                 
%                 %Ask if you like the current selection
%                 OKStr=input('Do you like the selection? (y/n [n]): ','s');
%                 if isempty(OKStr)
%                     OKStr='n';
%                 end
%                 if strcmpi(OKStr(1),'y')
%                     break;
%                 end
%             end %end of while(1)
%             
%             %Make template as the mean of the selected waveforms
%             myTemplate=mean(BigPeakMat(:,ISkip2(ISelect))')'; 
%         end
%         
%         if RedoIdx<=3
%             
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             % Show the histogram of RSSDs between the template and the peak
%             % waveforms, from which criterion RSSD is determined
%             %Square root of sum of squared difference
%             
%             rssd=sqrt(sum((BigPeakMat(myIRange,:)-repmat(myTemplate(myIRange),[1 size(BigPeakMat,2)])).^2));
%             
%             %keyboard
%             %Show the histogram
%             figure(4)
%             subplot(1,2,1);
%             [n,x]=hist(rssd(ISkip1),50);
%             bar(x,n,1);
%             %Red bars indicate the section in the PCA plot
%             hold on
%             [n,x]=hist(rssd(ISkip2(ISelect)),x);
%             bar(x,n,1,'r')
%             hold off
%             
%             %Determine criterion RSSD
%             disp(' ');
%             disp('Set the criterion RSSD');
%             while(1)
%                 %
%                 figure(4);
%                 subplot(1,2,1);
%                 [myCutRSSD,dum]=ginput(1); %GUI to set the criterion
%                 
%                 %Draw the line indication the cut RSSD
%                 hCriterionLine=line([1 1]*myCutRSSD,ylim); 
%                 set(hCriterionLine,'Color','k');
%                 %Indicate the selected RSSD with black lines
%                 figure(3)
%                 IGood=find(rssd(ISkip1)<myCutRSSD);
%                 hBlackLine=line(t(myIRange),BigPeakMat(myIRange,ISkip1(IGood)));
%                 set(hBlackLine,'Color','k');
%                 %Green line indicates the template
%                 hGreenLine=line(t(myIRange),myTemplate(myIRange));
%                 set(hGreenLine,'Color','g');
%                 %title(sprintf('%.1f peaks per trial',sum(rssd(ISkip)<myCutRSSD)/NTrial));
%                 title(sprintf('%.1f peaks per trial',sum(rssd<myCutRSSD)/NTrial));
%                 
%                 %Show ISI histogram
%                 myIGood=find(rssd<myCutRSSD);
%                 %myreg=BigRegMat(myIGood,:);
%                 myreg=BigStimTrlRegMat(myIGood,:);
%                 myreg(:,3)=myreg(:,3)/100;
%                 mydiff=diff(myreg);
%                 ISIvec=mydiff(find(~mydiff(:,1) & ~mydiff(:,2)),3);
%                 figure(4);
%                 subplot(1,2,2);
%                 hist(ISIvec,0:0.2:10);
%                 xlim([-0.1 6.1]);
%                 
%                 % Show raster
%                 figure(5)
%                 %ntrials=max(BigStimTrlRegMat(:,2));
%                 ntrials=max(NRep);
%                 StimList=FileIdx;
%                 %StimList=unique(BigStimTrlRegMat(:,1));
%                 nStim=length(StimList);
%                 myStimTrl=BigStimTrlRegMat(myIGood,1:2);
%                 x=[];
%                 y=[];
%                 for iStim=1:nStim
%                     myI=find(myStimTrl(:,1)==StimList(iStim));
%                     if ~isempty(myI)
%                         x=[x; myreg(myI,3)];
%                         y=[y; (iStim-1)*ntrials+myStimTrl(myI,2)];
%                     end
%                 end
%                 if isempty(x)
%                     clf
%                 else
%                     plot(x,y,'.');
%                     set(gca,'YTick',0.5+((1:nStim)-1)*ntrials,'YTickLabel',StimList,'YGrid','on');
%                     myxlim=PstRange;       
%                     if isinf(myxlim(1))
%                         myxlim(1)=0;
%                     end
%                     if isinf(myxlim(2))
%                         myxlim(2)=max(BigStimTrlRegMat(:,3))/100;
%                     end
%                     xlim(myxlim);
%                     
%                     xlabel('PST (ms)');
%                     ylabel('Stim Number');
%                 end
%                 
%                 %Repeat until you like the current cut RSSD
%                 OKStr=input('OK? (y/n [n]): ','s');
%                 if isempty(OKStr)
%                     OKStr='n';
%                 end
%                 if strcmpi(OKStr(1),'y')
%                     break;
%                 end
%                 
%                 %Delete the lines
%                 delete(hCriterionLine);
%                 delete(hBlackLine);
%                 delete(hGreenLine);
%             end %while(1)
%         end %if RedoIdx<=3
%         
%         if RedoIdx~=4
%             %Check with raw waveforms
%             OKStr=input('Do you want to check with raw waveforms? (y/n [n]): ','s');
%             if isempty(OKStr)
%                 OKStr='n';
%             end
%             if strcmpi(OKStr(1),'y')
%                 RedoIdx=4;;
%             end
%         end
%         if RedoIdx==4
%             while(1)
%                 stimtrl=input('[StimIdx TrialNo XMin XMax] (RET for end): ');
%                 if length(stimtrl)<2
%                     break;
%                 end
%                 
%                 try
%                     figure(6);
%                     
%                     %Load wav
%                     [Wav,Fs]=GetWavFilt(Root,stimtrl(1),stimtrl(2));
%                     Wav=resample(Wav,4,1);
%                     Fs=Fs*4;
%                     
%                     %Plot waveform
%                     n=length(Wav);
%                     t=(1:n)/Fs;
%                     plot(t,Wav,'b-');
%                     hold on
%                     
%                     %Indicate spikes
%                     ITrial=find(BigStimTrlRegMat(:,1)==stimtrl(1) & BigStimTrlRegMat(:,2)==stimtrl(2) & rssd(:)<myCutRSSD);
%                     if ~isempty(ITrial)
%                         I=ceil(BigStimTrlRegMat(ITrial,3)/100000*Fs);
%                         plot(t(I),Wav(I),'r.');
%                     end
%                     hold off
%                     
%                     if length(stimtrl)==4
%                         xlim(sort(stimtrl(3:4)));
%                     else
%                         xlim([min(t) max(t)]);
%                     end
%                 catch
%                     disp('Error when drawing a raw waveform...');
%                     disp(lasterr);
%                 end
%             end
%         end
%         
%         disp('######## End of Sorting ########')
%         disp('Select the process to start over, or RET to finish)')
%         disp('[1] Analysis time range')
%         disp('[2] PCA Plot')
%         disp('[3] Criterion for template matching')
%         disp('[4] Check with raw waveforms')
%         disp('[Return] Finish');
%         RedoIdx=input(': ');
%         if isempty(RedoIdx)
%             break
%         end
%         
%     end %while(1)
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % Save the results
%     
%     if exist(OutFName,'file')==2 | exist([OutFName '.mat'],'file')==2
%         myans=input([OutFName ' already exists. Do you want to append, overwrite, or cancel? (a/o/c [a]): '],'s');
%         if isempty(myans)
%             myans='a';
%         end
%         switch lower(myans)
%             case 'a'
%                 %Load the previous data
%                 load (OutFName, 'Template', 'IRange', 'CutRSSD')
%                 if ~iscell(Template) %Convert to cell array if not
%                     Template={Template};
%                     IRange={IRange};
%                     CutRSSD={CutRSSD};
%                 end
%                 NUnit=length(Template); %Number of units so far
%                 
%                 %Append
%                 Template{NUnit+1}=myTemplate;
%                 IRange{NUnit+1}=myIRange;
%                 CutRSSD{NUnit+1}=myCutRSSD;
%                 
%                 %Save
%                 save(OutFName,'Template','IRange','CutRSSD','-append');
%             case 'o'
%                 Template=myTemplate;
%                 IRange=myIRange;
%                 CutRSSD=myCutRSSD;
%                 save(OutFName,'Template','IRange','CutRSSD','PkRoot','FileIdx');
%             case 'c'
%                 return;
%         end
%     else
%         Template=myTemplate;
%         IRange=myIRange;
%         CutRSSD=myCutRSSD;
%         save(OutFName,'Template','IRange','CutRSSD','PkRoot','FileIdx');
%     end
%     
%     
% end