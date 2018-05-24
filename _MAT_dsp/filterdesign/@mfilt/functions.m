%   The following functions are available for multirate filters (type help
%   mfilt/<FUNCTION> to get help on a specific function - e.g. help
%   mfilt/filter):
%
%   -----------------------------------------------------------------------
%             Analyses 
%   -----------------------------------------------------------------------
%   <a href="matlab:help mfilt/info">info</a>         - Filter information.
%   <a href="matlab:help mfilt/polyphase">polyphase</a>    - Polyphase decomposition of multirate filters.
%   <a href="matlab:help mfilt/freqz">freqz</a>        - Frequency response of a multirate filter.
%   <a href="matlab:help mfilt/phasez">phasez</a>       - Phase response of a multirate filter.
%   <a href="matlab:help mfilt/zerophase">zerophase</a>    - Zero-phase response of a multirate filter.
%   <a href="matlab:help mfilt/grpdelay">grpdelay</a>     - Group delay of a multirate filter.
%   <a href="matlab:help mfilt/phasedelay">phasedelay</a>   - Phase delay of a multirate filter.
%   <a href="matlab:help mfilt/impz">impz</a>         - Impulse response of a multirate filter.
%   <a href="matlab:help mfilt/impzlength">impzlength</a>   - Length of the impulse response for a multirate filter.
%   <a href="matlab:help mfilt/stepz">stepz</a>        - Step response of a multirate filter.
%   <a href="matlab:help mfilt/zplane">zplane</a>       - Pole/Zero plot.
%   <a href="matlab:help mfilt/cost">cost</a>         - Cost Estimate. 
%
%   <a href="matlab:help mfilt/order">order</a>        - Filter order.
%   <a href="matlab:help mfilt/coeffs">coeffs</a>       - Filter coefficients.
%   <a href="matlab:help mfilt/gain">gain</a>         - Gain of a Cascaded Integrator-Comb (CIC) filter.
%   <a href="matlab:help mfilt/firtype">firtype</a>      - Determine the type (1-4) of a linear phase FIR filter.
%   <a href="matlab:help mfilt/tf">tf</a>           - Convert to transfer function.
%   <a href="matlab:help mfilt/zpk">zpk</a>          - multirate filter zero-pole-gain conversion.
%
%   <a href="matlab:help mfilt/isfir">isfir</a>        - True for FIR multirate filter.
%   <a href="matlab:help mfilt/islinphase">islinphase</a>   - True for linear multirate filter.
%   <a href="matlab:help mfilt/ismaxphase">ismaxphase</a>   - True if maximum phase.
%   <a href="matlab:help mfilt/isminphase">isminphase</a>   - True if minimum phase.
%   <a href="matlab:help mfilt/isreal">isreal</a>       - True for multirate filter with real coefficients.
%   <a href="matlab:help mfilt/isstable">isstable</a>     - True if the filter is stable.
%
%   Fixed-Point (Fixed-Point Designer Required)
%   <a href="matlab:help mfilt/qreport">qreport</a>      - Quantization report.
%   <a href="matlab:help dfilt/autoscale">autoscale</a>    - Dynamic range scaling.
%   <a href="matlab:help mfilt/set2int">set2int</a>      - Scale the coefficients to integer numbers.
%   <a href="matlab:help mfilt/filtmsb">filtmsb</a>      - Most significant bit of a CIC filter.
%   <a href="matlab:help mfilt/norm">norm</a>         - Filter norm.
%   <a href="matlab:help dfilt/double">double</a>       - Cast filter to double-precision floating-point arithmetic.
%   <a href="matlab:help mfilt/reffilter">reffilter</a>    - Reference double-precision floating-point filter.
%
%   -----------------------------------------------------------------------
%             Multi-stages 
%   -----------------------------------------------------------------------
%   <a href="matlab:help mfilt/cascade">cascade</a>      - Cascade filter objects.
%   <a href="matlab:help dfilt/nstages">nstages</a>      - Number of stages in a cascade filter.
%   <a href="matlab:help dfilt/addstage">addstage</a>     - Add a stage to a cascade filter.
%   <a href="matlab:help dfilt/removestage">removestage</a>  - Remove a stage in a cascade filter.
%   <a href="matlab:help dfilt/setstage">setstage</a>     - Set a stage in a cascade filter.
%
%   -----------------------------------------------------------------------
%             Simulations 
%   -----------------------------------------------------------------------
%   <a href="matlab:help mfilt/filter">filter</a>       - Execute ("run") multirate filter.
%   <a href="matlab:help mfilt/reset">reset</a>        - Reset multirate filter.
%   <a href="matlab:help mfilt/nstates">nstates</a>      - Number of states in multirate filter.
%   <a href="matlab:help mfilt/convert">convert</a>      - Convert structure of DFILT object.
%   <a href="matlab:help mfilt/copy">copy</a>         - Copy multirate filter.
%
%   -----------------------------------------------------------------------
%             Code Generation
%   -----------------------------------------------------------------------
%   <a href="matlab:help mfilt/realizemdl">realizemdl</a>         - Filter realization diagram       (Simulink Required). 
%   <a href="matlab:help mfilt/block">block</a>              - Generate a Digital Filter block. (Simulink Required).
%   <a href="matlab:help mfilt/generatehdl">generatehdl</a>        - Generate HDL                     (Filter Design HDL Coder Required).
%   <a href="matlab:help mfilt/generatetb">generatetb</a>         - Generate an HDL Test Bench       (Filter Design HDL Coder Required).
%   <a href="matlab:help mfilt/generatetbstimulus">generatetbstimulus</a> - Generate HDL Test Bench Stimulus (Filter Design HDL Coder Required).
%   <a href="matlab:help mfilt/fcfwrite">fcfwrite</a>           - Write a filter coefficient file.
%
%   See also MFILT

%   Author(s): V. Pellissier
%   Copyright 2005-2010 The MathWorks, Inc.



% [EOF]
