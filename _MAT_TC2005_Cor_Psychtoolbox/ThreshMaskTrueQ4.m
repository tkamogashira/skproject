function [mdata,data]=Thresh(Color1,Color2)
% RGratio > 1

% Set parameters
imageSize = 144;			  			% Image size in pixels
expandSize = 1;		% Amount to expand image for display

cyclesPerImage = [8 8 8 8];					% Spatial freq, c/image.
dimSignal=[0 1 0 1];
dimNoise=[0 0 0 0];
noiseType=[1 1 0 0]; % 0: grating+random 1: random
cyclesPerImageNoise=8;
noiseContrast=0.8;
noiseContrastMask=0.8;

spaceConstant=imageSize/4;	% Gaussian grating envelope
minITIsec=1;
white=[255 255 255];
black=[0 0 0];
meanColor=(Color1+Color2)/2;
nTrialsPerCond=20;

contrastValues=[0.01:0.01:1];


% Stimulus location
xy=zeros(4,2);
xy(1,:)=[-1 -1]*96;
xy(2,:)=[1 -1]*96;
xy(3,:)=[-1 1]*96;
xy(4,:)=[1 1]*96;


% Seed random number generator
ClockRandSeed;

% Read screen calibration and compute cluts.
calCT = LoadCalFile(0);
calCT = SetGammaMethod(calCT,1);


% Open window and set the linear clut for the experiment
bkgColor=PrimaryToSettings(calCT,meanColor')';
[window,screenRect]=SCREEN(0,'OpenWindow',bkgColor,[],32);
screenFramerate=FrameRate(0);

% Start trials
conditions=1:length(cyclesPerImage);
conditions=conditions(randperm(length(conditions)));
data = zeros(length(conditions),4);

% Make a rect of correct size.
signalRect=ScaleRect(SetRect(0,0,imageSize,imageSize),expandSize,expandSize);
for loc=1:4, 
    putRect{loc} = CenterRect(signalRect,screenRect);
    putRect{loc} = OffsetRect(putRect{loc},xy(loc,1),xy(loc,2));
end

bkg1(1:imageSize,1:imageSize,1) = meanColor(1); % 0-1
bkg1(1:imageSize,1:imageSize,2) = meanColor(2);
bkg1(1:imageSize,1:imageSize,3) = meanColor(3);
bkgstm=GammaCorrectImage(bkg1,calCT);
SCREEN(window,'PutImage',bkgstm,screenRect);
    
fixationRect=CenterRect(SetRect(0,0,4,4),screenRect);
instString = 'Hit any key when ready';
SCREEN(window,'DrawText',instString,50,100,black);
GetChar;
SCREEN(window,'PutImage',bkgstm,screenRect);
HideCursor;

tic;
cnd=1;

for cnd=1:length(conditions),
    
    icnd=conditions(cnd);
    
    nIntervals=4; nResponses = 4;
    beta=3.5; delta=0.01; gamma=1/nIntervals;
    pCorrect=0.625;
    thresholdGuess = log10(0.1);
    priorSd = 4;
    q=QuestCreate(thresholdGuess,priorSd,pCorrect,beta,delta,gamma);
    
    switch(dimSignal(icnd))
        case 0, %lum
            RcontS=Color1(1)-meanColor(1);
            GcontS=Color1(1)-meanColor(1);
            BcontS=Color1(1)-meanColor(1);
        case 1, % RG
            RcontS=Color1(1)-meanColor(1);
            GcontS=Color1(2)-meanColor(2);
            BcontS=Color1(3)-meanColor(3);
    end
    switch(dimNoise(icnd))
        case 0, %lum
            RcontN=Color1(1)-meanColor(1);
            GcontN=Color1(1)-meanColor(1);
            BcontN=Color1(1)-meanColor(1);
        case 1, % RG
            RcontN=Color1(1)-meanColor(1);
            GcontN=Color1(2)-meanColor(2);
            BcontN=Color1(3)-meanColor(3);
    end
    
    for t=1:nTrialsPerCond
        stmloc=ceil(randi(4));
        
        % Make signal and noise
        signal=MakeSignalsCT(imageSize,cyclesPerImage(icnd),spaceConstant);
        noise=MakeNoisesCT(imageSize,noiseContrast,cyclesPerImageNoise,noiseType(icnd));
        stimulus = zeros([size(signal) 3]);
        
        noise1(:,:,1) = meanColor(1)*(RcontN*noise+1); % 0-1
        noise1(:,:,2) = meanColor(2)*(GcontN*noise+1);
        noise1(:,:,3) = meanColor(3)*(BcontN*noise+1);
        noisestm=GammaCorrectImage(noise1,calCT);
    
         % Get level to test
        [mv mid]=min(abs(10^QuestQuantile(q)-contrastValues));
        trialCon=contrastValues(mid);
    
        stimulus(:,:,1)=noise1(:,:,1)+trialCon*RcontS*signal;
        stimulus(:,:,2)=noise1(:,:,2)+trialCon*GcontS*signal;
        stimulus(:,:,3)=noise1(:,:,3)+trialCon*BcontS*signal;
        stimulus=GammaCorrectImage(stimulus,calCT);
        
        % fixation spot
        SCREEN(window,'WaitBlanking',minITIsec*screenFramerate+randi(screenFramerate));
        SCREEN(window,'FillRect',black,fixationRect);
        SCREEN(window,'WaitBlanking',randi(screenFramerate));
        SCREEN(window,'FillRect',bkgColor,fixationRect);
        SCREEN(window,'WaitBlanking',screenFramerate/2);
        
        % present
        for loc=1:4
            if(loc==stmloc)
                SCREEN(window,'PutImage',stimulus,putRect{loc});
            else
                SCREEN(window,'PutImage',noisestm,putRect{loc});
            end
        end
        SCREEN(window,'WaitBlanking',screenFramerate/10);
        for loc=1:4
            SCREEN(window,'PutImage',bkgstm,putRect{loc});
        end
        
        %response
        while(1)
            response=GetResp(stmloc);
            if(response==9),
                ShowCursor;
                SCREEN('CloseAll');
                return;
            end
            if(response~=-1),break;end
        end
        GiveFeedback(response);
        
        % Update Quest and store data
        q = QuestUpdate(q,log10(trialCon),response);
        theData(cnd,t,1) = trialCon;
        theData(cnd,t,2) = response;
        theData(cnd,t,3) = QuestMean(q);
        theData(cnd,t,4) = QuestSd(q);
        
    end
    data(cnd,1) = conditions(cnd);
    data(cnd,2) = cyclesPerImage(conditions(cnd));
    data(cnd,3) = QuestMean(q);   
    data(cnd,4) = QuestSd(q);
    cnd=cnd+1;
end

% Close up
ShowCursor;
SCREEN('CloseAll');


save('ThreshMaskQ4.mat','data','theData');

toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
function signal=MakeSignalsCT(imageSize,cyclesPerImage,spaceConstant)
 % Generate the waveform
x=1:imageSize;
x=(x-mean(x));
wave=sign(randn(1))*sin(2*pi*cyclesPerImage*x/imageSize);

% Generate the Gaussian
gaussianX=exp(-(x/spaceConstant).^2);
gaussianY=exp(-(x/spaceConstant).^2);

% Put them together as an image
signal = (gaussianX.*wave)'*gaussianY;

function noise=MakeNoisesCT(imageSize,noiseContrast,noiseCyclesPerImage,noiseType)
if(noiseContrast>0)
    noiseBound=2;
    x=-noiseBound:.001:noiseBound;
    pdf=exp(-0.5*x.^2);
    noisePowerFactor=sum(pdf.*x.^2)/sum(pdf);
    clear x pdf;
    
    % Make noises
    noise=randn(imageSize,imageSize);
    maxNoiseCon=-Inf;
    minNoiseCon=Inf;
    while (1)
        elements=find(noise<-noiseBound | noise>noiseBound);
        if isempty(elements);break;end;
        noise(elements)=randn(size(elements));
    end
    noise=noise*(noiseContrast/sqrt(noisePowerFactor));
    
    if noiseType==1, % add sin mask
        xx=meshgrid(1:imageSize)';
        noise=noise+noiseContrast*sin(2*pi*noiseCyclesPerImage*xx/imageSize+2*pi*rand(1));
    end
else
    noise=zeros(imageSize,imageSize);
end

function image=GammaCorrectImage(image01,calCT)
image01_2d=reshape(image01,size(image01,1)*size(image01,2),3);
image=PrimaryToSettings(calCT,image01_2d')';
image=reshape(image,size(image01,1),size(image01,2),3);


function resp=GetResp(stmloc)
[keyIsDown,secs,keyCode] = KbCheck;
resp=-1;
key1=192;
key2=219;
key3=186;
key4=221;
key5=27;
if keyCode(key1),
    if(stmloc==1), resp=1;
    else resp=0;
    end
end
if keyCode(key2),
    if(stmloc==2), resp=1;
    else resp=0;
    end
end
if keyCode(key3),
    if(stmloc==3), resp=1;
    else resp=0;
    end
end
if keyCode(key4),
    if(stmloc==4), resp=1;
    else resp=0;
    end
end
if keyCode(key5),
    resp=9;
end

       