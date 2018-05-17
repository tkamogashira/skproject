% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function back=mysubplot(nr_y,nr_x,nr,rect, hint)
% usage: mysubplot(nr_y,nr_x,nr,rect, hint))
% exact like subplot, but can draw into arbitrary figures
% the rect in which the new axis are plottet are given by rect. 
% if rect is not given, 0 0 1 1 is taken
% rect is (x_min,y_min,x_width,y_width)
% hint gives additionally information about spaces in the graphic
% hint=0: normal with spaces everywere (every figure has its own axis)
% hint=1: Space only at the bottom and on the left. of the outer pictures. There are the titles

spacing=0.05;

if nargin < 4
    rect=[0 0 1 1];
end

if nargin < 5
    hint=0;
end

rectleft=rect(1);
rectbottom=rect(2);
rectwidth=rect(3);
rectheight=rect(4);


if hint==0
    distleft=rectwidth*spacing;  % der Abstand, der vom Rand eingehalten werden soll
    distright=rectwidth*spacing; 
    disthochzwischen=rectheight*spacing; % Abstand zwischen zwei vertikalen Bildern
    distbreitzwischen=rectwidth*spacing; % Abstand zwischen zwei vertikalen Bildern
    distunten=rectwidth*spacing; % Abstand nach unten
end
if hint==1
    distleft=rectwidth*spacing;  % der Abstand, der vom Rand eingehalten werden soll
    distright=0; 
    disthochzwischen=rectheight*0.01; % Abstand zwischen zwei vertikalen Bildern
    distbreitzwischen=0; % Abstand zwischen zwei vertikalen Bildern
    distunten=rectwidth*spacing; % Abstand nach unten
end    

if hint==0
    x=rectwidth/nr_x;
    y=rectheight/nr_y;
    
    nnx=mod(nr-1,nr_x);
    ges=nr_x*nr_y;
    nny=ges/nr_x - round((nr-1)/nr_x+0.5);
    
    left=distleft+x*nnx;
    bottom=distunten+y*nny;
    width=x-distleft-distright;
    height=y-distunten-disthochzwischen;
end
if hint==1
    x=(rectwidth-distleft)/nr_x;
    y=(rectheight-distunten)/nr_y;
    
    nnx=mod(nr-1,nr_x);
    ges=nr_x*nr_y;
    nny=ges/nr_x - round((nr-1)/nr_x+0.5);
    
    left=distleft+x*nnx;
    bottom=distunten+y*nny;
    width=x-distbreitzwischen;
    height=y-disthochzwischen;
end

back=[rectleft+left rectbottom+bottom width height];

axes('position',back);
