function aboutdspsystbx
%ABOUTDSPSYSTBX Displays version number of the DSP System Toolbox
%             and the copyright notice in a modal dialog box.

%   Copyright 1995-2010 The MathWorks, Inc.
 
a=ver('dsp');
str1=a.Name;
str2=a.Version;
tmp=a.Date;b=tmp(end-3:end);
str3=['Copyright 1995-',b,' MathWorks, Inc.'];
str = sprintf([str1,' ',str2,'\n',str3]);
msgbox(str,'About the DSP System Toolbox','modal');

% [EOF] aboutdspsystbx.m
