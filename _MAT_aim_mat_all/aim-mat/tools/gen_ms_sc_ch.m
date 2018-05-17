%  
% sig = function gen_ms_sc_ch(segment_len, carrier_fq, envelope_fq, halflife, d_r, sample_fq) 
%
%   The size of the vectors corresponds to the number of segments
%   All vectors must have the same size or must be a scalar instead
%   If a scalar is used, this value is the same for each segment
%
%   INPUT VALUES:
% 		segment_len         length of each segment in s (vector/scalar)
%       carrier_fq          carrier frequence  (vector/scalar)
%       envelope_fq         envelope frequence = modulator fq (vector/ scalar)
%       halflife            Half life (vector/ scalar) in seconds !!!
%       d_r                 0 = damped, 
%                            1 = ramped  (vector/scalar)
%       sample_fq           the sample frequence
%
%   RETURN VALUE:
%		sig                 the signal (object of class signal)
% 
%   REMARK:             Sample frequence should be a multiple of both, the
%                       carrier frequence as well as the envelope frequence
% 
% (c) 2003-2008, University of Cambridge, Medical Research Council 
% Christoph Lindner
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



function sig = gen_ms_sc_ch(segment_len, carrier_fq, envelope_fq, halflife, d_r, sample_fq)

% sample_fq should be a multiple of carrier and envelope_fq 
if (mod(sample_fq, carrier_fq) ~= 0)
    warning('Sample frequence should be a multiple of carrier frequence for a smooth transition between the segemnts');
end
if (mod(sample_fq, envelope_fq) ~= 0)
    warning('Sample frequence should be a multiple of envelope frequence for a smooth transition between the segemnts');
end

% find out the number of segments
nos = max([length(segment_len) length(carrier_fq) length(envelope_fq) length(halflife) length(d_r)]);

sig = signal(0, sample_fq);
% loop the segments         
for i =1:nos
    % vector vs scalar
    if length(segment_len) > 1
        sl = segment_len(i);
    else
        sl = segment_len;
    end
    % Special workaround to avoid aliases at the trasition (one
    % point will be deleted)
    if length(carrier_fq) > 1
        cf = carrier_fq(i);
    else
        cf = carrier_fq;
    end
    if length(envelope_fq) > 1
        ef = envelope_fq(i);
    else
        ef = envelope_fq;
    end
    if length(halflife) > 1
        hl = halflife(i);
    else
        hl = halflife;
    end
    if length(d_r) > 1
        dr = d_r(i);
    else
        dr = d_r;
    end
    
    % generate object
    sig_obj = signal(sl, sample_fq);
    
    % generate signal
    if dr == 1
        sig_tmp = generaterampsinus(sig_obj, cf, ef, 1, hl);
    else
        sig_tmp = generatedampsinus(sig_obj, cf, ef, 1, hl);
    end
    % add the segement to the main signal vector
    % Special workaround to avoid aliases at the trasition (one
    % point will be deleted)

    sig = append(sig, sig_tmp);
end

    