% demonstration file for 'aim-mat'
%
% (c) 2006-2008, University of Cambridge, Medical Research Council 
% Written by Tom Walters (tcw24@cam.ac.uk)
% http://www.pdn.cam.ac.uk/cnbh/aim2006
% $Date: 2008-06-10 18:00:16 +0100 (Tue, 10 Jun 2008) $
% $Revision: 585 $

function plot_mellin(input, frame_no, current_scale, titlestr);

generating_module='mellin';
usermodule=input.data.usermodule;
current_frame_number=frame_no;
generating_functionline=['input.all_options.usermodule.' generating_module '.displayfunction'];
eval(sprintf('display_function=%s;',generating_functionline'));
if strcmp(display_function,'')
    str=get_graphics_options(handles,input.info.calculated_usermodule_module);
    plot(plotting_frame,str);
    xlabel('time interval (ms)');ylabel('Frequency (kHz)');title(titlestr);
else
    generating_options_line=['options=input.all_options.usermodule.' generating_module ';'];
    eval(generating_options_line);
    options.current_scale=current_scale;
    %options.handles=handles;
    plotstr=sprintf('%s(usermodule,options,%d)',display_function,current_frame_number);
    eval(plotstr);
    title(titlestr);
end
