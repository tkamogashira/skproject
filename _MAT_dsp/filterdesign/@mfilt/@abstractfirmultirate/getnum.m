function num = getnum(Hm,dummy)
%GETNUM Get the numerator vector.

%   Author: R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

num = formnum(Hm,Hm.privpolym);
