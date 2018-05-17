% support file for 'aim-mat'
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function scalefigure(hand,x,y)
% change the size of the window in hand by the factors in x and y without
% changing the top left corner
% checks that the graphic does not become bigger then the screen

screensize=get(0,'ScreenSize');
sw=screensize(3);
sh=screensize(4);

np=get(hand,'pos');
% np comes as x,y,width,height
newheigh=np(4)*y;
newwidth=np(3)*x;
heightdiff=np(4)-newheigh;
widthdiff=np(3)-newwidth;
%     np(2)=np(2)-np(4)/1.5;
%     np(4)=np(4)*1.5;
% np(2)=0;
% nullp=get(0,'ScreenSize');
% np(4)=nullp(4);


x=np(1);
y=np(2)+heightdiff;
w=newwidth;
h=newheigh;
% check for the screensize. If its too high then push it upwards. If its
% still too high then make it smaller
if y<0
%     y=-62;  % bug in version 7. Zero sits not at the bottom
    y=0;  % bug in version 7. Zero sits not at the bottom
    if h>sh
%         h=sh-10;
        h=sh-62;
    end
end

if x+w>sw
    x=sw-w;
    if x<0
        x=0;
        w=sw;
    end
end

newnp(1)=x;
newnp(2)=y;
newnp(3)=w;
newnp(4)=h;

set(hand,'pos',newnp);

%and bring to front
figure(gcf)
