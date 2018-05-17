% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
% function to generate an artificial vowel
function sig=gen_frog(sig,options)
% vowel,pitch,scale,halflifeconstant,onsettimeconstant,pitch_jitter,formant_jitter,formant_jitter_bw);% 

if nargin < 2
    options=[];
end


% the rise of a damped sinusoid is not instantaneous, but like a gamma
% functin with the following power of t:
if isfield(options,'onsettimeconstant')
    onsettimeconstant=options.onsettimeconstant;
else
    onsettimeconstant=0.5;
end% halflife of each formant is calculated by dividing this number by the
% formant frequency:
% if halflifeconstant<=0, then fixed to 4 ms
if isfield(options,'halflifeconstant')
    halflifeconstant=options.halflifeconstant;
else
    halflifeconstant=3;
end
% scaling = 1: normal speaker
if isfield(options,'scale')
    scale=options.scale;
else
    scale=1;
end
% f0
if isfield(options,'pitch')
    pitch=options.pitch;
else
    pitch=100;
end
% how long the decay should continue longer then the reprate
if isfield(options,'carry_decay')
    carry_decay_parameter=options.carry_decay;
else
    carry_decay_parameter=1;
end
% normal or is it the octave? In this case, we jump over each second 
if isfield(options,'do_octave')
    do_octave=options.do_octave;
else
    do_octave=0;
end
% type of vowel: 'a','e','i','o','u'
if isfield(options,'vowel')
    vowel=options.vowel;
else
    vowel='a';
end



if nargin < 1
    sig=signal(0.5,16000);
end
sr=getsr(sig);
dur_time=getlength(sig);


nr_formants=4;

for i=1:nr_formants
    formfre(i)=pitch*i;
end
level(1)=0;
% level(2)=-18;
% level(3)=-30;
% level(4)=-38;

level(2)=-4;
level(3)=-6;
level(4)=-9;



% % fix all formants to the nearest harmonic of the fundamental
% if isfield(options,'adjust_to_nearest_harmonic')
%     if options.adjust_to_nearest_harmonic==1
%         f0=options.pitch;
%         for formant=1:nr_formants
%             fre=formfre(formant);
%             newfre=round(fre/f0)*f0;
%             formfre(formant)=newfre;
%         end
%     end
% end


formfre=formfre.*scale;
dur_samp=dur_time.*sr;        %length of vowel defined in sample points
sgpp=1/pitch; %standard glottal pulse period.
pitch_jitter=0;
t=[0:1/sr:(dur_time-(1/sr))]; %our time sequence
dur_samp=dur_time.*sr;        %length of vowel defined in sample points


%we now generate a sequence, specified in sample points, which
%define the spacing of glottal pulses.  With zero pitch_jitter the sequence
%is regular (1/pitch). With a pitch_jitter value of 1 the spacing of glottal 
%pulses fall in a range with an upper limit of double the period of
%the pitch and a lower limit of 1/sampling rate.
%The average spacing of glottal pulses is approx 1/pitch
lwr_pth_jit=0.5-(pitch_jitter/2);
upr_pth_jit=0.5+(pitch_jitter/2);

gp=cell(nr_formants,1); %for each formant will store pulse time
for formant=1:nr_formants
    enough_pulses=0;
    pulse_number=0;
    while enough_pulses==0
        pulse_number=pulse_number+1;
        pulse_spacing(pulse_number)=max(1,floor(sr.*(sgpp.*2.*(lwr_pth_jit+(upr_pth_jit-lwr_pth_jit)*rand(1)))));
        pulse_time(pulse_number)=sum(pulse_spacing)-pulse_spacing(1)+1;
        if pulse_time(pulse_number)>=dur_samp
            pulse_time=pulse_time(1:pulse_number-1);
            pulse_number=pulse_number-1;
            enough_pulses=1;
        else
        end
    end
    
    gp{formant}=pulse_time;
    clear pulse_time;
    clear pulse_spacing;
    no_pulses(formant)=length(gp{formant});
    pulse_times{formant}=gp{formant};
end%formant

formant_jitter=0;

% if no gamma tone, then precalculate the damping function once for all
% if onsettimeconstant <= 0 && halflifeconstant==0
    hl=0.04;
    damping=exp(t.*log(0.5)/hl);  %this decays to 0.5 after hl seconds
    damping=damping/max(damping);
% end

onsettimes=power(t,onsettimeconstant);

formant_jitter_bw=0;
%--------------------------------------------------------------------------
for formant=1:nr_formants
    lw_log(formant)=max(log10(150), (log10(formfre(formant))- ((formant_jitter_bw.*.3)/2) ) ); %cannot go below 150Hz
    lw_log_adj(formant)=log10(formfre(formant))-((log10(formfre(formant))-lw_log(formant)).*formant_jitter);
    up_log(formant)=min(log10(4500),log10(formfre(formant))+ ((formant_jitter_bw.*.3)/2))  ; 
    up_log_adj(formant)=log10(formfre(formant))+((up_log(formant)-log10(formfre(formant))).*formant_jitter);
end


% if we want to generate the octave, we take exactly the same pulses and
% frequencies, but only every second one:
if do_octave
    pulse_step=2;
else
    pulse_step=1;
end

nr_points=length(t);
final_wave=zeros(dur_samp,nr_formants);
for formant=1:nr_formants
    for count=1:pulse_step:no_pulses(formant)-1
        oneortwo=randperm(2);
        if oneortwo(1)==1 
            freq=10.^((lw_log_adj(formant)+(log10(formfre(formant))-lw_log_adj(formant))*rand(1))); %lower range
        else
            freq=10.^((log10(formfre(formant))+(up_log_adj(formant)-log10(formfre(formant)))*rand(1))); %upper range
        end

%         if freq>1000
%             no_octave=((log10(freq)-3))/.3;
%             lev=-12.*no_octave;
%         else
%             lev=0;
%         end
%         amp=10.^(lev/20);

        lev=level(formant);
        amp=10.^(lev/20);

        if halflifeconstant<=0
            hl=0.004;
        else
            hl=halflifeconstant/freq;
        end

        nr_relevant_points=pulse_times{formant}(count+1)-pulse_times{formant}(count);
        
        nr_relevant_points=nr_relevant_points*carry_decay_parameter;
        
        if onsettimeconstant > 0
            damping=zeros(nr_relevant_points,1);
            for jj=1:nr_relevant_points
                damping(jj)=onsettimes(jj)*exp(t(jj)*log(0.5)/hl);  %this decays to 0.5 after hl seconds
            end
            damping=damping/max(damping);
        end
        grafix=0;
        if grafix==1
            figure(234)
            plot(damping);
        end
        
        this_formant=zeros(nr_relevant_points,1);
        for jj=1:nr_relevant_points
            sinsin=sin(2*pi*freq*t(jj));
            this_formant(jj)=amp*sinsin*damping(jj);
        end
        start_nr=pulse_times{formant}(count);
        stop_nr=start_nr+nr_relevant_points-1;
        
        if stop_nr> nr_points
            nr_new=nr_points-start_nr+1;
            this_formant=this_formant(1:nr_new);
            stop_nr=nr_points;
            final_wave(start_nr:stop_nr,formant)= final_wave(start_nr:stop_nr,formant)+this_formant;
        else
            final_wave(start_nr:stop_nr,formant)= final_wave(start_nr:stop_nr,formant)+this_formant;
        end
    end
end
final_wave_total=zeros(dur_samp,1);
for formant=1:nr_formants
    final_wave_total=final_wave_total+final_wave(:,formant);
end

% sig=signal(final_wave_total,sr);

if isfield(options,'rise_time')
    rise_time=options.rise_time;
else
    rise_time=0.015;
end

if isfield(options,'fall_time')
    fall_time=options.fall_time;
else
    fall_time=0.1;
end

% sigvals=
final_wave_total=gate_on_off(rise_time,fall_time,final_wave_total,sr);
sig=signal(final_wave_total,sr);
% 
% hold_time=length(sig)-rise_time-fall_time;
% attack=linspace(0,1,round(rise_time*sr));
% 
% hold=ones(1,round(hold_time*sr));
% release=linspace(1,0,round(fall_time*sr));
% envelope=[attack hold release];
% envelope=envelope(1:getnrpoints(sig));
% envelope=signal(envelope,sr);
% sig=sig*envelope;


function amp=calc_level(freq);
%determines the level of a signal at a given frequency after it 
%has been filtered with a low-pass filter of 12dB/octave at 1kHz
%first calculate if frequency is above 1kHz and if so by how many octaves
%then multiply by slope.
if freq>1000
    no_octave=((log10(freq)-3))/.3;
    lev=-12.*no_octave;
else
    lev=0;
end
amp=10.^(lev/20);



function output=gate_on_off(onset,offset,input,sr)
%check duration of signal is large enough for both the onset and offset
%values. 

sig_length_samp=length(input);
onset_length_samp=floor(onset.*sr);
offset_length_samp=floor(offset.*sr);

if (onset_length_samp+offset_length_samp)>sig_length_samp
    output=0;
    disp('---ERROR---  onset and offset duration too large for signal');
    return
else end


%generate onset and offset amplitudes
n_on=onset_length_samp;
k=[1:1:n_on];
onset_win=(1-cos(2.*pi.*(k./(2.*(n_on-1)))))./2;

n_off=offset_length_samp;
k=[1:1:n_off];
offset_win=0.5+((cos(2.*pi.*(k./(2.*(n_off-1)))))./2);



total_window=ones(sig_length_samp,1);
total_window(1:onset_length_samp)=onset_win;
total_window(sig_length_samp-offset_length_samp+1:sig_length_samp)=offset_win;



output=input.*total_window;

return
