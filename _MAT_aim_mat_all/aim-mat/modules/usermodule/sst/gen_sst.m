% Function to calculate the size-shape image (SSI)
%
% (c) 2003-2008, University of Cambridge, Medical Research Council
%
% Marc A. Al-Hames
% April 2003
%
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function ssi=gen_ssi(sai,options)

%user information; open the 'calculation in progress' dialog box
waithand=waitbar(0,'reading in SAI');
disp('running the SSI function...');

%read in all of the frames in the SAI array - converting them into Irino's
%3d matrix

no_frames=size(sai);
SAI3d=[];

for ii=1:no_frames(2);
    fraction_complete=ii/no_frames(2);
    waitbar(fraction_complete);
    current_frame=sai{ii};
    SAI3d(:,:,ii)=getvalues(current_frame);
    if (options.flipimage == 1)
        SAI3d(:,:,ii) = fliplr(SAI3d(:,:,ii));
    end;
end;

%close the dialog box
close(waithand);

%assume that the sample rate is constant
sample_rate=getsr(sai{1});

SSI3d=Calssi(SAI3d,options,sample_rate);

%finally we output everything into frames
%we have to take the transpose to put it in the correct form for the
%display function

maxfreval=max(max(sum(SSI3d,2)));

for jj=1:no_frames(2);
    current_frame=SSI3d(:,:,jj);
    ssi{1,jj}=frame(current_frame);
    %set the sample rate of the frames
    ssi{1,jj}=setsr(ssi{1,jj},sample_rate);
    ssi{1,jj}=setxaxisname(ssi{1,jj},'0');
    ssi{1,jj}=setscalefrequency(ssi{1,jj},maxfreval);
end;



