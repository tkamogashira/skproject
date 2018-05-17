%
%   Demo Auditory Image/Mellin Image 
%   IRINO T
%   21 Jan. 2003
%
clear
NameFile.Snd = 'ct8ms';
%NameFile.Snd = 'damped_sinus2';

%NameFile.Snd = 'roy_a_canon';
%NameFile.Snd = 'dampedsinus';
%NameFile.Snd = 'MOak';
% NameFile.Snd = 'MJAra';

[Snd, fs] = wavread([NameFile.Snd '.wav']);

Snd = (2^15-1)*Snd(:)';
% PlaySound(Snd,fs);
plot(Snd);
drawnow
NameFile.MI = [NameFile.Snd '_Rslt.mat'];

%want to make the thing recalculate each time to see what's going on
%if exist(NameFile.MI) ~= 2
[MI3d, StrobeInfo, NAPparam, STBparam, SAIparam, MIparam]  ...
        = CalAIMIall(Snd,fs,[],[],[],[],NameFile.MI);
    %else
 %str = ['load ' NameFile.MI];
 %disp(str); eval(str);
 %end
MI3d=abs(MI3d);
max_value=max(max(max(MI3d)));
disp('the max value is:');
disp(max_value);
MI3d=MI3d/max_value;

[xx, yy, tt] = size(MI3d);
disp(tt);
for nn = 5
 matrix_of_current_frame =  abs(MI3d(:,:,nn));
 
%set the range of values for the axes
coef_range=[0,max(MIparam.c_2pi)];
h_range=[0,max(MIparam.TFval)];

%set the resolution of the axes
coef_step=(coef_range(1,2)-coef_range(1,1))/10;
%h_step=(h_range(1,2)-h_range(1,1))/10;
h_step=1;

%sets the axis divisions
coef_axis = [coef_range(1,1):coef_step:coef_range(1,2)];
h_axis = [h_range(1,1):h_step:h_range(1,2)];

%this section sets up the colormap to be the correct gray scale version that we want 
colormap_name=gray(128);
size_colormap=size(colormap_name);
% disp(size_colormap);
for ii=1:size_colormap(1);
    rich_map(ii,:)=colormap_name((129-ii),:);
end;
colormap(rich_map);

%now we generate the image matlab automatically scales the colours
%note that we take the magnitude of the components
%we reset the the colourmap, scaling it's maximum to 1
mellin_image = image(h_axis, coef_axis, matrix_of_current_frame,'CDataMapping','scaled');

set(gca,'CLimMode','manual');
set(gca,'CLim',[0 0.15]); %second of these values is the threshold

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
 
 
 
% %this section sets up the colormap to be the correct gray scale version that we want 
% colormap_name=gray(128);
% size_colormap=size(colormap_name);
% disp(size_colormap);
% for ii=1:size_colormap(1);
%     rich_map(ii,:)=colormap_name((129-ii),:);
% end;
% colormap(rich_map);
% 
% h = image(MIparam.TFval,MIparam.c_2pi,Mval,'CDataMapping','scaled');
% 
% set(gca,'CLimMode','manual');
% set(gca,'CLim',[0 0.7]);
% 
%  set(gca,'YDir','normal');	
%  ntick = [ 0:1:max(ceil(MIparam.TFval))];
%  set(gca,'XLim',[0 ceil(max(MIparam.TFval))]);
%  set(gca,'XTick',ntick);
%  set(gca,'XTickLabel', ntick);
%  ytv = 0:5:max(MIparam.c_2pi);
%  set(gca,'YTick',ytv);
%  set(gca,'YTickLabel', num2str(flipud(ytv(:))));
%  h = xlabel('Time-Interval frequency product');
%  h = ylabel('Mellin Coefficient');
% 
drawnow
end;

	
