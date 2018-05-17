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


function mellin=gen_mellin(sai,options)

%user information; open the 'calculation in progress' dialog box
waithand=waitbar(0,'reading in SAI'); 
%disp('running the mellin function...');

%read in all of the frames in the SAI array - converting them into Irino's
%3d matrix

no_frames=size(sai);
%disp('# frames:');
%disp(no_frames(2));

SAI3d=[];

for ii=1:no_frames(2);
    fraction_complete=ii/no_frames(2);
    waitbar(fraction_complete);
    current_frame=sai{ii};
    SAI3d(:,:,ii)=getvalues(current_frame);
    if (options.flipimage == 1)
        SAI3d(:,:,ii) = fliplr(SAI3d(:,:,ii));  % maah: for flipped pictures (ti1992)
    end;
end;

%close the dialog box
close(waithand); 

%now we use Irino's code to find the mellin coefficients of the SAI data
%the coefficients as a function of h are stored in frames for each time in
%the array 'mellin'

%assume that the sample rate is constant
sample_rate=getsr(sai{1});
%disp('the sample rate is;');
%disp(sample_rate);

MI3d=CalMI(SAI3d,options,sample_rate);
%MI3d=SAI3d;
%we take the magnitude of the values
%MI3d =  abs(MI3d); % maah: magnitude in Call_miRich

%if set inm parameter file takes the log of the values to smooth colourmap
if options.log==1
    MI3d=log(MI3d);
end;

%when generating the mellin image we need to know how to map colours, this
%piece of code finds the maximal value in the array and normalises the
%frames s.t. the maximal value=1
% max_value=max(max(max(MI3d))); % maah normalization in CalMI_Rich for
% maah: each frame!
% disp('the max value is:');
% disp(max_value);
% MI3d=MI3d/max_value;           % maah

%finally we output everything into frames
%we have to take the transpose to put it in the correct form for the
%display function
for jj=1:no_frames(2);
    current_frame=MI3d(:,:,jj);
    mellin{1,jj}=frame(current_frame);
   %set the sample rate of the frames
    mellin{1,jj}=setsr(mellin{1,jj},sample_rate);
    mellin{1,jj}=setxaxisname(mellin{1,jj},'0');
end;



