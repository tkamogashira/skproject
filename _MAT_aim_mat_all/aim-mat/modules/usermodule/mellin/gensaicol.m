% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
%  tester generating function for 'aim-mat'
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


function colormap=gensaicol(sai,options)

%user information; open the 'calculation in progress' dialog box
waithand=waitbar(0,'reading in SAI'); 
disp('running the mellin function...');

%read in all of the frames in the SAI array - converting them into Irino's
%3d matrix

no_frames=size(sai);
disp('# frames:');
disp(no_frames(2));

SAI3d=[];

for ii=1:no_frames(2);
    fraction_complete=ii/no_frames(2);
    waitbar(fraction_complete);
    current_frame=sai{ii};
    SAI3d(:,:,ii)=getvalues(current_frame);
end;

%close the dialog box
close(waithand); 

%now we use Irino's code to find the mellin coefficients of the SAI data
%the coefficients as a function of h are stored in frames for each time in
%the array 'mellin'

%assume that the sample rate is constant
sample_rate=getsr(sai{1});
disp('the sample rate is;');
disp(sample_rate);

%MI3d=CalMI_Rich(SAI3d,options,sample_rate);
MI3d=SAI3d;
%we take the magnitude of the values
MI3d =  abs(MI3d);

%when generating the mellin image we need to know how to map colours, this
%piece of code finds the maximal value in the array and normalises the
%frames s.t. the maximal value=1
max_value=max(max(max(MI3d)));
disp('the max value is:');
disp(max_value);
MI3d=MI3d/max_value;

%finally we output everything into frames
for jj=1:no_frames(2);
    colormap{1,jj}=frame(MI3d(:,:,jj));
end;



