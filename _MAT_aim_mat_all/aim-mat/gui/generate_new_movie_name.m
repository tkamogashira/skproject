% procedure for 'aim-mat'
% 
% function handles=do_aim_calculate(handles)
%
%   INPUT VALUES:
%   RETURN VALUE:
%     a new unique movie name
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



function new_name=generate_new_movie_name(handles)
% looks through the directory and decides, what name a new movie should get

dirname=handles.info.directoryname;
cd(dirname);

allmovies=dir('*.mov');
nr_movies=length(allmovies);
newnumber=nr_movies+1;
new_name=sprintf('%s.movie%d.mov',handles.info.uniqueworkingname,newnumber);
cd ..
