%%% May 2001 M.A.Stone.  To design FIR filters for fir_corr.c
%%% produces output on screen, and to file dummy.??k where ?? is clock freq in kHz
%%% select variables below, such as ntaps (output is ntaps +1) fs,
%%% and inverse =1 sets for inverse filter, 0 for normal filter.
%%% and eq characteristic is set by choosing appropriate variables:
%%%% function_str and dB corrn.  Ff_ed , Df_ed, Midear, and Hz come
%%%% from a separate file [all_corrns.m]. Insert new characteristics
%%%% in there, eg ITU_erp_drp/ITU_Hz

%%%  FORMAT for output file
%%%  first line is comment
%%%% second line is number of taps (preferably odd)
%%%% third and subsequent lines are filter taps, one per line, floating point

all_corrns; %%%%%% external file for reference corrections, hz, midear, ff_ed, diffuse
%%%%%% NB, midear response has limit/flatten-off at lowest freqs to prevent enormous changes < 25 Hz
%%%%%%%% design parameters here
%%% NB sometomes for inverse, cannot have ntaps too high: claims index error in fir2.
fs = 50000;  %%%% sampling rate
ntaps = 1+2*(round(fs/24)); %% always odd
nFFT = 2.^(nextpow2(ntaps) + 1); %% FIR size is ntaps + 1, otherwise delay has extra half-sample
%% more taps require kaiser beta to be higher
inverse = 0; %% options 0/1 : whether to do forward or inverse filter

posh_print = 0; %%% just if we want publication figure, so no output file

beta = 6; %%% used to window INVERSE filter shape, and reduce ripple
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Uncomment which of the three sections below you require
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Section 1
% function_str= sprintf(' Frontal free-field to cochlea correction,fs=%d',fs);
%
% if fs <= 32000
%    dBcorrn = Ff_ed - Midear; %%%%% result in dB 
% else %% for high fs use truer version, without low freq fiddle
%    dBcorrn = Ff_ed - MidearAES; %%%%% result in dB 
% end
%%%%%%% Section 2
function_str= sprintf(' Diffuse-field to cochlea correction,fs=%d',fs);

if fs <= 32000
	dBcorrn = Diffuse - Midear; %%%%% result in dB  NB midear is inverted !!
else %% for high fs use truer version, without low freq fiddle
   dBcorrn = Diffuse - MidearAES; %%%%% result in dB
end
  
%%%%%%% Section 3
%%%%%% ITU corrections for telephony.
%%function_str= sprintf(' ITU Ear Ref Pnt via Drum Ref Pnt to cochlea,fs=%d',fs);
%%ITU_on_Hz = interp1(ITU_Hz,ITU_erp_drp,Hz,'spline');  %%%% corrn on linear frequency spacing
%%dBcorrn = ITU_on_Hz - Midear; %%%%% result in dB.  NB midear is inverted !!

%%%% END OF VARIABLE USER ENTRY/SET-UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% rest is just calculations
if ~inverse
    filename = sprintf('ff.%dk',floor(fs/1000));
else
    filename = sprintf('iff.%dk',floor(fs/1000));
end
if ~posh_print
	txt_file = fopen(filename,'wt');
end
%%%% spacing for linear frequency design grid
deltaf  = (fs)/nFFT;

linf = 0:deltaf:fs/2; %%%% frequencies of FFT bins (DC-nyq-1)

if inverse == 1
	dBcorrn = -dBcorrn;
	title_str = strcat('INVERSE',function_str);   
else
   title_str= function_str;
   title_str=' ';
end

if Hz(end) < fs/2  %% handle interpolation of high fs data
    dBcorrn_linf = interp1([Hz fs/2],[dBcorrn dBcorrn(end)],linf,'linear');  %%%% corrn on linear frequency spacing
else
    dBcorrn_linf = interp1(Hz,dBcorrn,linf,'linear');  %%%% corrn on linear frequency spacing
end
%%%%%% limit/flatten-off at lowest freqs
dBcorrn_linf_orig = dBcorrn_linf;
%%%dBcorrn_linf(2) = dBcorrn_linf(3) - (dBcorrn_linf(3)-dBcorrn_linf(2))/2;
%%%dBcorrn_linf(1) = dBcorrn_linf(2);

[smth_b smth_a] = butter(4,.5); %% smooth to control roughness
eq_linf = filtfilt(smth_b,smth_a,dBcorrn_linf);

if posh_print, figure(1); plot(linf,eq_linf,'r','linewidth',1.8); hold on; end

%%%%% design fir filter: NB taming of response by (gentle) Kaiser window
if inverse
    halfwid = 10.^(eq_linf/20.);
    npi = pi*mod((0:nFFT/2),2);  %% include phase shift to put response in middle of aperture
    phase_shift = exp(i*npi);
    halfwid = halfwid .* phase_shift;
    fullwid = [halfwid conj(halfwid(nFFT/2:-1:2))];
    t_filt = real(ifft(fullwid));
    %%%%%%%%figure(2); plot(real(t_filt)); figure(1);
    ntaps2 = floor(ntaps/2);  %% extract relevant portion
    fir_eq = t_filt((nFFT/2+1)-ntaps2 : (nFFT/2+1)+ntaps2);
    fir_eq = fir_eq.*kaiser(ntaps,beta)';
else
    fir_eq = fir2(ntaps,linf./(fs/2),10.^(eq_linf/20.)); % f= 1 is Nyquist
end
    

%%%%% and plot response
if posh_print
	[hz,fz] = freqz(fir_eq,1,16384,fs);

%  GET AN OUTPUT FILE
%    outfile=fopen('frq_res.ff','w');
%    fprintf(outfile,'%.4f,%.4f\n',[fz,20*log10(abs(hz))]');
%    fclose(outfile);
	plot(fz,20*log10(abs(hz)),'b','linewidth',1.8);
	set(gca,'box','on'); %%%% default with R12 is off
	title(title_str,'fontsize',13); xlabel('Frequency (Hz)','fontsize',11); ylabel('Relative transmission (dB)','fontsize',11);
	set(gca,'TickDirMode','manual','TickLength',[0 0]); %% turn off ticking

	xfl = 20-.1; xfh = fs/2;
	xticking = [20 50 100 200 500 1000 2000 5000 10000];
    if fs/2 > 20e3, xticking = [xticking 20e3]; end
    if fs/2 > 50e3, xticking = [xticking 50e3]; end % no point in any higher
        
	set(gca,'xlim',[xfl xfh],'xscale','log');
	set(gca,'xtickmode','manual','xtick',xticking,'xticklabel',xticking); 

	if inverse, dBl = -10; dBh = 40; else dBl = -40; dBh = 10; end
	yticking = [dBl:5:dBh];
	set(gca,'linewidth',1.3,'ylim',[dBl dBh],'fontsize',11);
	set(gca,'ytickmode','manual','ytick',yticking,'yticklabel',yticking); 

%%	grid on ; set(gca,'GridLineStyle','-');
%%%%%% to overcome bugs in MATLAB with xscale producing extra ticks 20-06-2001
	for ix = 1:length(xticking) %% draw ylines
		line([xticking(ix) xticking(ix)],[min(yticking), max(yticking)],'linewidth',0.6,'linestyle','--');
	end
	for ix = 1:length(yticking) %% draw xlines
		line([xfl xfh],[yticking(ix), yticking(ix)],'linewidth',0.6,'linestyle','--');
	end

else
	freqz(fir_eq,1,8192,fs);
	subplot(2,1,1); set(gca,'xlim',[10 fs/2],'xscale','log');
	hold on ; grid on;
	semilogx(linf,dBcorrn_linf_orig,'r');
	title(title_str); xlabel('frequency (Hz)'); ylabel('dB (red=target, blue=actual)');
	subplot(2,1,1); hold off
	subplot(2,1,2); hold off
end

hold off  % for figure(1)

%%%% print out design values to file (and was screen)
if ~posh_print
	fprintf(1,'\nThis version has also created the file %s\n',filename);
	fprintf(1,'%s\n',function_str);
	fprintf(1,'%d\n',length(fir_eq));
%%	fprintf(1,'%11.8f\n',fir_eq);
	fprintf(txt_file,'%s\n',function_str);
	fprintf(txt_file,'%d\n',length(fir_eq));
	fprintf(txt_file,'%f\n',fir_eq);
	fclose(txt_file);
end

WriteDSAMFIRParFile(fir_eq, fs, inverse);
