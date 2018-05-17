% method of class @frame
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/03/13 14:48:37 $
% $Revision: 1.5 $

function nap=phasealign(nap,options)

if nargin < 2
	options=[];
end


%'off','maximum_envelope','nr_cycles','envelope_finestructure'

if ~isfield(options,'do_phase_alignment')%
	options.do_phase_alignment='nr_cycles';
end

if ~isfield(options,'phase_alignment_nr_cycles')
	options.phase_alignment_nr_cycles=3;
end



% values needed by all functions
vals=getvalues(nap);
new_vals=zeros(size(vals));
nr_chan=size(vals,1);
nr_dots=size(vals,2);
sr=getsr(nap);
cfs=getcf(nap);


if strcmp(options.do_phase_alignment,'nr_cycles')
	for ii=1:nr_chan
		shift=options.phase_alignment_nr_cycles/cfs(ii);
		intshift=round(shift*sr);
		dots=vals(ii,:);
		ndots=[dots(intshift:end) zeros(intshift-1,1)'];
		%     vals(ii,:)=ndots/log(cfs(ii));
		vals(ii,:)=ndots;
	end
end


if strcmp(options.do_phase_alignment,'envelope_finestructure')
	% phase alignment according to Holdswoth 1988
	EarQ = 9.26449;				%  Glasberg and Moore Parameters
	minBW = 24.7;
	order = 4;
	ERB = ((cfs/EarQ).^order + minBW^order).^(1/order);
	b=1.019.*ERB;
	B=1.019*2*pi.*ERB;
	envelopecomptime=(order-1)./B;
	phasealign=-2*pi.*cfs.*envelopecomptime;
	phasealign=mod(phasealign,2*pi);
	phasealign=phasealign./(2*pi.*cfs);
	% first align to the envelope
	% introduce phase shift in each channel
	for ii=1:nr_chan
		shift=envelopecomptime(ii);
		intshift=round(shift*sr);
		dots=vals(ii,:);
		ndots=[dots(intshift:end) zeros(intshift-1,1)'];
		%     vals(ii,:)=ndots/log(cfs(ii));
		vals(ii,:)=ndots;
	end
	% then align to the fine structure
	for ii=1:nr_chan
		shift=phasealign(ii);
		intshift=round(shift*sr);
		dots=vals(ii,:);
		ndots=[dots(intshift:end) zeros(intshift-1,1)'];
		vals(ii,:)=ndots;
	end
end


if strcmp(options.do_phase_alignment,'maximum_envelope')
	% phase alignment according to Holdswoth 1988 without fine structure
	EarQ = 9.26449;				%  Glasberg and Moore Parameters
	minBW = 24.7;
	order = 4;
	ERB = ((cfs/EarQ).^order + minBW^order).^(1/order);
	b=1.019.*ERB;
	B=1.019*2*pi.*ERB;
	envelopecomptime=(order-1)./B;
	phasealign=-2*pi.*cfs.*envelopecomptime;
	phasealign=mod(phasealign,2*pi);
	phasealign=phasealign./(2*pi.*cfs);
	
	% first align to the envelope
	% introduce phase shift in each channel
	for ii=1:nr_chan
		shift=envelopecomptime(ii);
		intshift=round(shift*sr);
		dots=vals(ii,:);
		ndots=[dots(intshift:end) zeros(intshift-1,1)'];
		%     vals(ii,:)=ndots/log(cfs(ii));
		vals(ii,:)=ndots;
	end
end


if strcmp(options.do_phase_alignment,'nr_cycles_freq')
    phase_alignment_nr_cycles=0.6796.*log(cfs)-1.3836;
     	
	for ii=1:nr_chan
        shift=phase_alignment_nr_cycles(ii)./cfs(ii);
		intshift=round(shift*sr);
		dots=vals(ii,:);
		ndots=[dots(intshift:end) zeros(intshift-1,1)'];
		%     vals(ii,:)=ndots/log(cfs(ii));
		vals(ii,:)=ndots;
	end
end





nap=setvalues(nap,vals);