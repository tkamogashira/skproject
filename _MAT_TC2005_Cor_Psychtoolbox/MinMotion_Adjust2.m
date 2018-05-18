function MinMotion_Adjust(framesPerImage,inc)

if nargin<1
    framesPerImage = 10;
end
if(nargin<2)
   inc=0.05;
end

% Define some parameters
nPixels = 144;				
nCycles = 1;					
cyclePerImage=4;
bkglevel=0.4;
Color1=[bkglevel+0.3  bkglevel-0.3  bkglevel];
Color2=[bkglevel-0.3  bkglevel+0.3  bkglevel];
ColorL=[bkglevel bkglevel bkglevel]+0.15;
ColorL2=bkglevel-(ColorL-bkglevel);
nMeas=2;




% Open up the a window on the screen, initialize the clut,
calCM = LoadCalFile(0);
calCM = SetGammaMethod(calCM,1);
[window,screenRect] = SCREEN(0,'OpenWindow',255,[],8);
offClut = ones(256,1)*PrimaryToSettings(calCM,[bkglevel bkglevel bkglevel]')';
SCREEN(window,'SetClut',offClut);
screenFramerate=FrameRate(0);

[ms,mc]=MakeGrating(nPixels,cyclePerImage); % ms, mc, -1 or 1
gratingImage=zeros(size(ms,1),size(ms,2),4);
gratingImage(:,:,1)=(ms+1)/2; % 0 or 1
gratingImage(:,:,2)=(mc+1)/2+2; % 2 or 3
gratingImage(:,:,3)=1-(ms+1)/2; % 1 or 0 (reverse-phase)
gratingImage(:,:,4)=1-(mc+1)/2+2; % 3 or 2 (reverse-phase)


% 4frame offscreen image
frameRect = [0 0 size(ms)];
rect = CenterRect(frameRect,screenRect);
win=zeros(1,4);
for i=1:4
    win(i) = SCREEN(window,'OpenOffscreenWindow',0,frameRect);
    SCREEN(win(i),'PutImage',squeeze(gratingImage(:,:,i)));
end
clear gratingImage ms mc;

WaitSecs(2);
% Adjustment
HideCursor;
for t=1:nMeas
    if inc==1, %demo mode
        Vcont=0.0;
    else
        Vcont=rand(1)*1.4; %initial contrast
    end
    resp=-1;
    while(resp~=0)
        resp=GetResp;
        if(resp==1)
            Vcont=Vcont+inc;
        elseif(resp==2)
            Vcont=Vcont-inc;
        elseif(resp==0)
            break;
        elseif(resp==9)
            SCREEN('CloseAll');
            return;
        end
        if Vcont<0, Vcont=0;
        elseif Vcont>1.4, Vcont=1.4;
        end
        theCluts=ComputeCluts(Color1,Vcont*Color2,ColorL,ColorL2,calCM,offClut);
        Present(window,win,framesPerImage,nCycles,frameRect,rect,theCluts);
    end
    
    SCREEN(window,'SetClut',offClut);
    Vcont_all(t)=Vcont;
    WaitSecs(1);
end
ShowCursor;
SCREEN('CloseAll');
WaitSecs(1);	% pause between runs

Vcont_mean=mean(Vcont_all);
save('MinMotion_Adj.mat','Color1','Color2','ColorL','Vcont_all', 'Vcont_mean');

function [ms,mc]=MakeGrating2(nPixels,cyclePerImage)
% Building the images
frameSize=nPixels/2;
[x,y]=meshgrid(-frameSize+0.5:frameSize-0.5,-frameSize+0.5:frameSize-0.5);
ms=sin(cyclePerImage/(frameSize*2)*x*2*pi);
ms(ms>=0.7)=1;
ms(ms<=-0.7)=-1;
ms(ms<1&ms>-1)=0;
mc=cos(cyclePerImage/(frameSize*2)*x*2*pi);
mc(mc>=0.7)=1;
mc(mc<=-0.7)=-1;
mc(mc<1&mc>-1)=0;

function [ms,mc]=MakeGrating1(nPixels,cyclePerImage)
% Building the images
frameSize=nPixels/2;
[x,y]=meshgrid(-frameSize+0.5:frameSize-0.5,-frameSize+0.5:frameSize-0.5);
ms=sin(cyclePerImage/(frameSize*2)*x*2*pi);
ms(ms>=0)=1;
ms(ms<=-0)=-1;
mc=cos(cyclePerImage/(frameSize*2)*x*2*pi);
mc(mc>=0)=1;
mc(mc<=0)=-1;

function [ms,mc]=MakeGrating(nPixels,cyclePerImage)
% Building the images
frameSize=nPixels/2;
[x,y]=meshgrid(-frameSize+0.5:frameSize-0.5,-frameSize+0.5:frameSize-0.5);
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
    

function Present(window,win,framesPerImage,nCycles,frameRect,rect,theClut);
%SCREEN(window,'WaitBlanking');
for i=1:nCycles
    SCREEN(window,'SetClut',theClut);
    for j=1:4
        SCREEN('CopyWindow',win(j),window,frameRect,rect);
        if(j==1)
            SCREEN(window,'WaitBlanking',framesPerImage-2);
        else
            SCREEN(window,'WaitBlanking',framesPerImage-1);
        end
    end
end


function resp=GetResp
[keyIsDown,secs,keyCode] = KbCheck;
resp=-1;
%key1=38; %up
%key2=40; %down
key1=KbName('['); 
key2=KbName(']'); 
key3=13; %return
key4=27; %escape
if keyCode(key1),
    resp=1;
end
if keyCode(key2),
    resp=2;
end
if keyCode(key3),
    resp=0;
end
if keyCode(key4),
    resp=9;
end




