% method of class @signal
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function [val,height,width,widthvals,base_peak_y]=qvalue2(sig,where)
% similar to qvalue, but returns the value of height divided by width
% when height is calculated from maximum to the nearest minimum


vals=sig.werte;
nr_bin=time2bin(sig,where);
nr_values=getnrpoints(sig);

[maxpos,minpos,maxs,mins]=getminmax(sig);

[pos_min_left,minval_left]=getminimumleftof(where,maxpos,minpos,maxs,mins);
[pos_min_right,minval_right]=getminimumrightof(where,maxpos,minpos,maxs,mins);

if isempty(pos_min_left)
	pos_min_left=0;
	minimal_left=gettimevalue(sig,pos_min_left);
end
if isempty(pos_min_right)
	pos_min_right=getmaximumtime(sig);
	minval_right=gettimevalue(sig,pos_min_right);
end

if minval_left > minval_right
	new_height=minval_left;
	pos_left=pos_min_left;
	widthvals(1)=pos_left;
	
	pos_right=nr_values+1;
	for i=nr_bin:nr_values
		if vals(i)< minval_left
			pos_right=bin2time(sig,i);
			break;
		end
	end
else
	new_height=minval_right;
	pos_right=pos_min_right;
	widthvals(2)=bin2time(sig,pos_right);
	
	pos_left=0;
	for i=nr_bin:-1:1
		if vals(i)< minval_right
			pos_left=bin2time(sig,i);
			break;
		end
	end
end

width=pos_right-pos_left;
widthvals(1)=pos_left;
widthvals(2)=pos_right;

height=gettimevalue(sig,where)-new_height;

base_peak_y=new_height;


val=height/width;




