% generating function for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function displaymellin(mellin,options,frame_number)

%setup the scale bar to alter to range of the colour map
%converts the exponential scale on the scale bar to a value 0<x<1
if (isfield(options, 'handles'))
    slider_value = slidereditcontrol_get_value(options.handles.slideredit_scale);    
else
    slider_value = options.current_scale; 
end
options.max_value=(-log10(slider_value)+3.001)/6;

% disp('the max value of the colour map is:');
% disp(options.max_value);

%read in the mellin information to matricies
current_frame=mellin{1,frame_number};
matrix_of_current_frame=getvalues(current_frame);

% maah: Normalization for each frame
if (max(max(matrix_of_current_frame))>0) % TCW AIM2006 - fixed divide by zero warnings
    matrix_of_current_frame = matrix_of_current_frame / max(max(matrix_of_current_frame));
end
    
% % maah: Maybe a threshold can help against this blur!   
% if (options.threshold ~= 0)
%     if (options.threshold ~= 1)
%         matrix_of_current_frame(matrix_of_current_frame < options.threshold) = 0;
%     else
%         mean_value = mean(mean(matrix_of_current_frame));
%         matrix_of_current_frame(matrix_of_current_frame < mean_value) = 0;
%     end;
% end;

%set the range of values for the axes
coef_range=[0,max(options.c_2pi)];
h_range=[0,max(options.TFval)];

%set the resolution of the axes
coef_step=(coef_range(1,2)-coef_range(1,1))/10;
%h_step=(h_range(1,2)-h_range(1,1))/10;
h_step=1;

%sets the axis divisions
coef_axis = [coef_range(1,1):coef_step:coef_range(1,2)];
h_axis = [h_range(1,1):h_step:h_range(1,2)];

%this section sets up the colormap to be the correct gray scale version that we want 
colormap_name=gray(128);  % maah: was = gray(128)
size_colormap=size(colormap_name);
%disp(size_colormap);
for ii=1:size_colormap(1);
   rich_map(ii,:)=colormap_name((129-ii),:);
end;
colormap(rich_map);


%now we generate the image matlab automatically scales the colours
%note that we take the magnitude of the components
%we reset the the colourmap, scaling it's maximum to 1
%matrix_of_current_frame = matrix_of_current_frame'; %removed the transpose
%in the display function and put it into the generating function 
mellin_image = image(h_axis, coef_axis, matrix_of_current_frame,'CDataMapping','scaled');

set(gca,'CLimMode','manual');
set(gca,'CLim',[0 options.max_value]);

%now we scale the image so that it fills the display area
limitx=ceil(max(h_axis));
limity=ceil(max(coef_axis));
set(gca,'XLim',[0 limitx]);
set(gca,'YLim',[0 limity]);

%here we setup the scale and location of the axes
set(gca,'XTick', h_axis);
set(gca,'XTickLabel', h_axis,'FontSize',8);

set(gca,'YTick', coef_axis);
set(gca,'YTickLabel', coef_axis,'FontSize',8,'YAxisLocation','right');

%flip the y axis
set(gca,'YDir','normal')

%and put on the labels
mellin_image = xlabel('Time-Interval, Peak-Frequency product, \ith','FontSize',8);
mellin_image = ylabel('Mellin variable, \it{c/2\pi}','FontSize',8);