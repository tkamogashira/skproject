% procedure for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% load the signal file and all files, that are in this directory
% set the project variables accordingly.
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



function [myaxes1,myaxes2,myaxes3,myaxes4]=aim_define_plot_areas(handles,relative_axis,options)

withtime=options.withtime;
withfre=options.withfre;
withsignal=options.withsignal;

current_plot=handles.info.current_plot;	

% calculate the position of the axes according to the tick-settings
% find out, which graphic we want:
if ~withtime && ~withfre && ~withsignal
	graphiccase=1;
else if ~withtime && ~withfre && withsignal
		if  current_plot==1
			graphiccase=8;
		else			
			graphiccase=2;
		end
	else if withtime && ~withfre && withsignal
			graphiccase=3;
		else if withtime && withfre && withsignal
				graphiccase=4;
			else if ~withtime && withfre && ~withsignal
					graphiccase=5;
				else if ~withtime && withfre && withsignal
						graphiccase=6;
					else if withtime && withfre && ~withsignal
							graphiccase=7;
						else if withtime && ~withfre && ~withsignal
								graphiccase=9;
							end
						end
					end
				end
			end
		end
	end
end


off=0.002; % between graphics
% width without frequency profile:
b11=0.96;
% width left and right with frequency profile:
b21=0.87-off;
b22=0.12; boff22=0.87-off;

% height signal without main or temp profile
h11=1;
% height signal with main window
h21=0.2;	hoff21=0.8+off;
h22=0.8;
% height temp profile with main window
h21a=0.8;	hoff21a=0.2+off;
h22a=0.2;

% height signal with main window and temporal profile
h31=0.15; 	hoff31=0.85+off+off+off;
h32=0.7;	hoff32=0.15+off;
h33=0.15;

if strcmp(handles.screen_modus,'paper')
	off=0.001; % between graphics
	% width without frequency profile:
	b11=0.95;
	% width left and right with frequency profile:
	b21=0.83-off;
	b22=0.12; boff22=0.83-off;
	
	% height signal without main or temp profile
	h11=1;
	% height signal with main window
	h21=0.2;	hoff21=0.75+off;
	h22=0.75;
	% height temp profile with main window
	h21a=0.8;	hoff21a=0.2+off;
	h22a=0.2;
	
	% height signal with main window and temporal profile
	h31=0.15; 	hoff31=0.83+off+off+off;
	h32=0.68;	hoff32=0.15+off;
	h33=0.15;
end


switch graphiccase
	case 1
		axpos2=[0,0,b11,h11];
	case 2
		axpos1=[0,hoff21,b11,h21];
		axpos2=[0,0,b11,h22];
	case 3
		axpos1=[0,hoff31,b11,h31];
		axpos2=[0,hoff32,b11,h32];
		axpos3=[0,0,b11,h33];
	case 4
		axpos1=[0,hoff31,b21,h31];
		axpos2=[0,hoff32,b21,h32];
		axpos3=[0,0,b21,h33];
		axpos4=[boff22,hoff32+off,b22,h32];
	case 5
		axpos2=[0,0,b21,h11];
		axpos4=[boff22,0,b22,h11];
	case 6
		axpos1=[0,hoff21,b21,h21];
		axpos2=[0,0,b21,h22];
		axpos4=[boff22,0 ,b22,h22];
	case 7
		axpos2=[0,hoff21a,b21,h21a];
		axpos3=[0,0,b21,h22a];
		axpos4=[boff22,hoff21a,b22,h21a];
	case 9
		axpos2=[0,hoff21a,b11,h21a];
		axpos3=[0,0,b11,h22a];
	otherwise
		axpos1=[0,hoff21,b11,h21];
end
		
ra=relative_axis;
% put a little space to the left side:
ra(1)=ra(1)+0.015;
if strcmp(handles.screen_modus,'paper')
	ra(2)=ra(2)+0.015;
end
if exist('axpos1','var')
	myaxes1=subplot('Position',[ra(1)+(axpos1(1)*ra(3)) ra(2)+(axpos1(2)*ra(4)) ra(3)*axpos1(3) ra(4)*axpos1(4)] );
	set(myaxes1,'Visible','on');
	cla;
else
	myaxes1=[];
end
if exist('axpos2','var')
	myaxes2=subplot('Position',[ra(1)+(axpos2(1)*ra(3)) ra(2)+(axpos2(2)*ra(4)) ra(3)*axpos2(3) ra(4)*axpos2(4)] );
	set(myaxes2,'Visible','on');
% 	cla;
else
	myaxes2=[];
end	
if exist('axpos3','var')
	myaxes3=subplot('Position',[ra(1)+(axpos3(1)*ra(3)) ra(2)+(axpos3(2)*ra(4)) ra(3)*axpos3(3) ra(4)*axpos3(4)] );
	set(myaxes3,'Visible','on');
% 	cla;
else
	myaxes3=[];
end	
if exist('axpos4','var')
	myaxes4=subplot('Position',[ra(1)+(axpos4(1)*ra(3)) ra(2)+(axpos4(2)*ra(4)) ra(3)*axpos4(3) ra(4)*axpos4(4)] );
	set(myaxes4,'Visible','on');
	cla;
else
	myaxes4=[];
end	