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

function tentsurface(framestruct_a);
% plots the current frame (cframe)
% all relevant data must be in the frame-object
% same as aisurface, only of the tent


if ~isstruct(framestruct_a)
%     error('AIsum must be called with a structure');
    framestruct.current_frame=framestruct_a;
else
    framestruct=framestruct_a;
end
current_frame=framestruct.current_frame;
current_frame=buildtent(current_frame);
framestruct.current_frame=current_frame;

aisurface(framestruct);