function MinMotion_Const

% Define some parameters
nPixels = 160;				% Image size 
framesPerImage = 10;			% Movie runs for 4*framesPerImage, without repeats
nCycles = 2;					% Repeats
cyclePerImage=4;
nMeas=5;
bkglevel=0.4;
Color1=[bkglevel+0.3  bkglevel-0.3  bkglevel];
Color2=[bkglevel-0.3  bkglevel+0.3  bkglevel];
ColorL=[bkglevel bkglevel bkglevel]+0.15;
ColorL2=bkglevel-(ColorL-bkglevel);
Vcont=[0.2 0.4 0.6 0.8 1.0 1.2 1.4];


% trial order
nCont=length(Vcont);
order=repmat(1:nCont,1,nMeas);
order=[order order+nCont]; % reverse phase condition
Vcont=[Vcont Vcont];
order=order(randperm(length(order)));

bkgIndex=254;

% Open up the a window on the screen, initialize the clut,
[window,screenRect] = SCREEN(0,'OpenWindow',bkgIndex,[],8);
calCM = LoadCalFile(0);
calCM = SetGammaMethod(calCM,1);
offClut=repmat([0:255]',1,3);
offClut(bkgIndex+1,:) = PrimaryToSettings(calCM,[bkglevel bkglevel bkglevel]')';
offClut(1:4,:) = repmat(PrimaryToSettings(calCM,[bkglevel bkglevel bkglevel]')',4,1);
SCREEN(window,'SetClut',offClut);

[ms,mc]=MakeGrating(nPixels,cyclePerImage); % ms, mc, -1 or 1
gratingImage=zeros(size(ms,1),size(ms,2),4);
gratingImage(:,:,1)=1-(mc+1)/2+2; % 3 or 2 (reverse-phase)
gratingImage(:,:,2)=(ms+1)/2; % 0 or 1
gratingImage(:,:,3)=(mc+1)/2+2; % 2 or 3
gratingImage(:,:,4)=1-(ms+1)/2; % 1 or 0 (reverse-phase)


% 4frame offscreen image
frameRect = [0 0 size(ms)];
rect = CenterRect(frameRect,screenRect);
win=zeros(1,4);
for i=1:4
    win(i) = SCREEN(window,'OpenOffscreenWindow',0,frameRect);
    SCREEN(win(i),'PutImage',squeeze(gratingImage(:,:,i)));
end
clear gratingImage;

GetChar;
HideCursor;
resp=zeros(size(order));
for t=1:length(order);
    iVcont=order(t);
    if(iVcont>nCont), %reverse phase
        theCluts=ComputeCluts(Vcont(iVcont)*Color2,Color1,ColorL,ColorL2,calCM,offClut);
    else
        theCluts=ComputeCluts(Color1,Vcont(iVcont)*Color2,ColorL,ColorL2,calCM,offClut);
    end
    Present(window,win,framesPerImage,nCycles,frameRect,rect,theCluts,calCM);
    SCREEN(window,'SetClut',offClut);
    response=GetResp;
    if(response==9),
        ShowCursor;
        SCREEN('CloseAll');
        return;
    end    
    resp(t)=response;
    WaitSecs(1);
end
ShowCursor;
SCREEN('CloseAll');

data=NaN*ones(length(Vcont),nMeas);
for i=1:length(Vcont)
    id=find(order==i);
    data(i,:)=resp(id);
    mdata(i)=mean(resp(id));
end
save('MinMotion_con.mat','Color1','Color2', 'ColorL','Vcont','nCont','order','resp','data','mdata');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ms,mc]=MakeGrating(nPixels,cyclePerImage)
% Building the images
frameSize=nPixels/2;
x=meshgrid(-frameSize+0.5:frameSize-0.5);
ms=sin(cyclePerImage/(frameSize*2)*x*2*pi);
ms(ms>=0)=1;
ms(ms<0)=-1;
mc=cos(cyclePerImage/(frameSize*2)*x*2*pi);
mc(mc>=0)=1;
mc(mc<0)=-1;

function theClut=ComputeCluts(Color1,Color2,ColorL1,ColorL2,calCM,offClut)
clutEntries=zeros(4,3);
% color grating
id=1;
clutEntries(id,1:3) =  Color1;
clutEntries(id+1,1:3) =  Color2;
% luminance grating
clutEntries(id+2,1:3) =  ColorL1;
clutEntries(id+3,1:3) = ColorL2;

theClut = offClut;
theClut([1 2 3 4],:) = PrimaryToSettings(calCM,clutEntries')';
    
function Present(window,win,framesPerImage,nCycles,frameRect,rect,theClut,calCM);
%SCREEN(window,'WaitBlanking');
SCREEN(window,'SetClut',theClut);
for i=1:nCycles
    for j=1:4
        SCREEN('CopyWindow',win(j),window,frameRect,rect);
        SCREEN(window,'WaitBlanking',framesPerImage-1);
    end
end


function resp=GetResp
resp=-1;
key1=37; %left
key2=39; %right
%key1=KbName('.'); 
%key2=KbName('/'); 
key3=27; %escape
while(resp==-1),
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyCode(key1),resp=0;end
    if keyCode(key2),resp=1;end
    if keyCode(key3),resp=9;end
end

