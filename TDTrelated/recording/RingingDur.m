function dur=RingingDur(freq)
%function dur=RingingDur(freq)
%Compute the duration of 'ringing' at the output of a gammatone filter.
%
%Feed a signal with the specified frequency to a gammatone filter bank,
%look at the filter that has the greatest output RMS, and compute the
%duration of the output. The difference between the output duration and the
%stimulus duration is regarded as the ringing duration.
%
%Usage : dur=RingingDur(freq)
%freq :  Freq of the tone (Hz). Scalar or matrix.
%dur : The ringing duration (ms). Same size as freq
%
%by SF, 2/5/2003


%% Parameters %%%%%%%%%%%%%%
PlotFlag=1; %Flag for plotting the gammatone filter output
%Sampling rate (Hz)    
fs=4000;
%Params for the tone (ms)
dur_tone=200;
ramp=5;
Silence1=100;
Silence2=100;
%Params for the filter bank
%numChannels=200;
%lowFreq=90;
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Initialize
n=length(freq(:));
dur=zeros(size(freq));
for ii=1:n
    myfreq=freq(ii);
    
    %Generate the input stim
    myt=(1/fs:1/fs:dur_tone/1000);
    tone=sin(2*pi*myfreq*myt);
    tone=Cos2RampMs(tone,ramp,fs);
    tone=[zeros(1,ceil(Silence1/1000*fs)) tone zeros(1,ceil(Silence2/1000*fs))];
    t=(1:length(tone))/fs;
    
    %Coeficients for the filters
    %     fcoefs=MakeERBFiltersG(fs,numChannels,lowFreq);
    %     cfArray = ERBSpaceG(lowFreq, fs/2, numChannels); 
    fcoefs=MakeERBFiltersG(fs,1,myfreq);
    cfArray = ERBSpaceG(myfreq, myfreq, 1); 
    
    %Get the gammatone filter outputs
    tone_out = ERBFilterBankG(tone, fcoefs);
    %Use the filter that generates the greatest output
    %RMS=sqrt(mean(tone_out'.^2));
    %[dum,Imax]=max(RMS);
    %tone_out=tone_out(Imax,:);
    
    %Find the onset and offset
    I=find(abs(tone_out)>max(abs(tone_out))*0.001);
    
    %The difference between the onset and the offset is the effective tone
    %duration at the output of the filter
    dur_out=diff(t(I([1 end])))*1000;
    %Difference between the effective duration and the stimulus duration is
    %the ringing duration
    dur(ii)=dur_out-dur_tone;
    
    %Plot the output waveform if desired
    if PlotFlag
        plot(t*1000,tone_out,'-',t(I([1 end]))*1000,tone_out(I([1 end])),'r.');
        %mystr=sprintf('CF=%.0f Hz; Ringing=%.0f ms',cfArray(Imax),dur(ii));
        mystr=sprintf('CF=%.0f Hz; Ringing=%.0f ms',myfreq,dur(ii));
        title(mystr)
        drawnow
    end
end