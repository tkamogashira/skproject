function sig=reduce_tilt(sig,options)


plot_switch=1;

lowpassfactor=100;	% relationship between Samplefrequency and lowpassfrequency

% shift all values that are zero at the beginning to the first
% positive value. This makes the lowpass continuous for high
% frequencies
sr=getsr(sig);
stip=getvalues(sig);

indx=find(stip>0);
if ~isempty(indx)
	first_non_zero=stip(indx(1));
	stip(1:indx(1))=first_non_zero;
	stip=[ones(200,1)*first_non_zero;stip];
end
s=signal(stip,sr);
s=reverse(s);
s2=lowpass(s,sr/lowpassfactor);
diff=s-s2;

% s2=getpart(s2,0,getlength(sig));


if plot_switch
	figure(4)
	clf
	plot(s);
	hold on
	plot(s2,'r');
	plot(diff,'g')
	axis([0 getnrpoints(sig) min(diff)-10 max(sig)+10]);
end

diff=getpart(diff,0,getlength(sig));
diff=reverse(diff);


% return value
sig=diff;