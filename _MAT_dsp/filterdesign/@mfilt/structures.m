%   MFILT.<STRUCTURE> can be one of the following (type help mfilt.<STRUCTURE>
%   to get help on a specific structure - e.g. help mfilt.firdecim).
%
%   Note that one usually does not construct multirate filters explicitly.
%   Instead, one obtains these filters as a result from a design using
%   <a href="matlab:help fdesign">FDESIGN</a>. 
%
%   -----------------------------------------------------------------------
%             Decimators 
%   -----------------------------------------------------------------------
%   <a href="matlab:help mfilt.firdecim">firdecim</a>           - Direct-form FIR polyphase decimator
%   <a href="matlab:help mfilt.firtdecim">firtdecim</a>          - Direct-form transposed FIR polyphase decimator 
%   <a href="matlab:help mfilt.cicdecim">cicdecim</a>           - Cascaded integrator-comb (CIC) decimator (*)
%   <a href="matlab:help mfilt.iirdecim">iirdecim</a>           - IIR polyphase decimator
%   <a href="matlab:help mfilt.iirwdfdecim">iirwdfdecim</a>        - IIR wave digital decimator
%
%   -----------------------------------------------------------------------
%             Interpolators 
%   -----------------------------------------------------------------------
%   <a href="matlab:help mfilt.firinterp">firinterp</a>          - Direct-form FIR polyphase interpolator
%   <a href="matlab:help mfilt.cicinterp">cicinterp</a>          - Cascaded integrator-comb (CIC) interpolator (*)
%   <a href="matlab:help mfilt.linearinterp">linearinterp</a>       - FIR linear interpolator
%   <a href="matlab:help mfilt.holdinterp">holdinterp</a>         - FIR hold interpolator
%   <a href="matlab:help mfilt.fftfirinterp">fftfirinterp</a>       - Overlap-add FIR polyphase interpolator
%   <a href="matlab:help mfilt.iirinterp">iirinterp</a>          - IIR polyphase interpolator
%   <a href="matlab:help mfilt.iirwdfinterp">iirwdfinterp</a>       - IIR wave digital interpolator
%
%   -----------------------------------------------------------------------
%             Rational Sample-Rate Converters 
%   -----------------------------------------------------------------------
%   <a href="matlab:help mfilt.firsrc">firsrc</a>             - Direct-form FIR polyphase sample-rate converter
%   <a href="matlab:help mfilt.firfracdecim">firfracdecim</a>       - Direct-form FIR polyphase fractional decimator
%   <a href="matlab:help mfilt.firfracinterp">firfracinterp</a>      - Direct-form FIR polyphase fractional interpolator
%   <a href="matlab:help mfilt.farrowsrc">farrowsrc</a>          - Farrow sample-rate converter
%
%   -----------------------------------------------------------------------
%             Multi-stages
%   -----------------------------------------------------------------------
%   <a href="matlab:help mfilt.cascade">cascade</a>            - Cascade (filters arranged in series)
%
%   (*) Fixed-Point Designer Required
%   
%   See also MFILT, FDESIGN

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.



% [EOF]
