function drawarrow(x1,x2,y1,y2)
%DRAWARROW Draws an arrow

%   Author(s): A. Charry  
%   Copyright 1999-2002 The MathWorks, Inc.

x=[x1 x2];
y=[y1 y2];
line(x,y,'color',[0 0 0]);
if y2==y1
    patch([x2-0.01 x2-0.01 x2],[y2-0.01 y2+0.01 y2],'k');
elseif x2==x1
    patch([x2-0.01 x2+0.01 x2],[y2+0.01 y2+0.01 y2],'k');
end

