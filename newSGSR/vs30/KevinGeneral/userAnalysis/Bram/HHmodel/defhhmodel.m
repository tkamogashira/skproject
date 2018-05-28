function ModelParam = defhhmodel(varargin)
%DEFHHMODEL define Hodgkin and Huxley model of a Bushy cell
%   HH = DEFHHMODEL('property1', value1, 'property2', value2, ...) defines
%   a modelled Bushy cell based on the Hodgkin and Huxley membrane potential
%   equations. The model is an adendretic, anaxonal and single compartment 
%   model of a Bushy cell. Without any arguments each parameter in the model
%   is set to its default value. Parameters can be changed by supplying the
%   parameter name followed by its adjusted value.
%
%   List of parameters that can be changed in the model (default values 
%   between parenthesis):
%   Tc  : ambient temperature in degrees celsius (38)
%   Cs  : membrane capacitance in pico Farraday (23)
%   
%   Ae  : conductance strength for excitatory inputs in nano Sievert (54.4, 
%         suprathreshold)
%   De  : delay in conductance strength peak in ms (0.1)
%   Ne  : number of excitatory inputs
%
%   Ep  : equilibrium membrane potential for potassium ions in mV (-77)
%   Es  : equilibrium membrane potential for sodium ions in mV (55)
%   El  : equilibrium membrane potential for leakage ions in mV (2.8)
%   Ee  : equilibrium membrane potential for ions that are associated with
%         an excitatory synaps (-10)
%
%   Th  : spiketime threshold membrane potential in mV (-25)
%   V0  : starting membrane potential in mV (-60)
%   aw  : analysis window in ms ([0 10])
%
%   mp  : maximum number of permutations allowed when repetitions of nerve
%         inputs are supplied (50)
%
%   All parameters must be set to a scalar value, except the analysis window,
%   the conductance strength of excitatory inputs and the membrane potentials.
%   The analysis window must be defined as a two element vector. The membrane
%   potential parameters can be given as a scalar, but can also be set by giving
%   a two-element vector with the first element giving the outside concentration
%   of the ion and the second element giving the inside concentration. 
%   Concentrations must be given in mol/l(M). If the conductance strength is given
%   as a scalar, all the inputs are given the same conductance, when supplying a
%   vector all inputs can have a different conductance strength. The excitatory
%   synaptic conductances can be divided into three rough categories: 
%   subthreshold conductances (Ae < 16 nS) that do not produce spike outputs when
%   presented alone; near-threshold conductances (16 <= Ae <= 40 nS) and 
%   suprathreshold conductances.
%
%   E.g.: 
%                    bm = defhhmodel('ae', 18.2, 'th', -20); 
%   This example defines a model with the conductance strength of excitatory inputs
%   set 18.2nS and the spike time threshold set to -20mV.
%
%   See also HHMODEL

%Based on JASON S. ROTHMAN, ERIC D. YOUNG, PAUL B. MANIS, "Convergence of Auditory
%Nerve Fibers Onto Bushy Cells in the Ventral Cochlear Nucleus: Implications of a
%Computational Model", JOURNAL OF NEUROPHYSIOLOGY Vol.70, No. 6, December 1993

%B. Van de Sande 09-08-2004

%----------------------------------------------------------------------------------
%Default values...
DefModelParam.Tc = 38;       %Ambient temperature in degrees celsius ...
DefModelParam.Cs = 23;       %Membrane capacitance in pico Farraday ...

DefModelParam.Ae = 54.4;     %Conductance strength for excitatory inputs in nano Sievert ... (suprathreshold)
DefModelParam.De = 0.1;      %Delay in conductance strength peak in ms ...
DefModelParam.Ne = 2;        %Number of excitatory inputs ...

DefModelParam.Ep = -77;      %Equilibrium membrane potential for potassium ions in mV ...
DefModelParam.Es = 55;       %Equilibrium membrane potential for sodium ions in mV ...
DefModelParam.El = 2.8;      %Equilibrium membrane potential for leakage ions in mV ...
DefModelParam.Ee = -10;      %Equilibrium membrane potential for ions that are associated with an excitatory synaps ...

DefModelParam.Th = -25;      %Spiketime threshold membrane potential in mV ...
DefModelParam.V0 = -60;      %Starting membrane potential in mV ...
DefModelParam.aw = [0 1000];   %Analysis window in ms ...

DefModelParam.mp = 50;       %Maximum number of permutations allowed when repetitions of nerve inputs are supplied ...

%----------------------------------------------------------------------------------
%Checking parameters and their values ...
ModelParam = checkproplist(DefModelParam, varargin{:});

if ~isscalar(ModelParam.tc), error('Invalid value for parameter Tc.'); end
if ~isscalar(ModelParam.cs) || (ModelParam.cs < 0)
    error('Invalid value for parameter Cs.');
end

if ~isscalar(ModelParam.de) || (ModelParam.de < 0)
    error('Invalid value for parameter De.');
end
if ~isscalar(ModelParam.ne) || (ModelParam.ne < 0) || (round(ModelParam.ne) ~= ModelParam.ne)
    error('Invalid value for parameter Ne.');
end
if ~isnumeric(ModelParam.ae) || ~any(length(ModelParam.ae) == [1, ModelParam.ne]) || any(ModelParam.ae < 0)
    error('Invalid value for parameter Ae.');
end
if isscalar(ModelParam.ae)
    ModelParam.ae = repmat(ModelParam.ae, 1, ModelParam.ne);
end

ModelParam.ep = parseE(ModelParam.ep, ModelParam.tc);
if isnan(ModelParam.ep), error('Invalid value for parameter Ep.'); end
ModelParam.es = parseE(ModelParam.es, ModelParam.tc);
if isnan(ModelParam.es), error('Invalid value for parameter Ep.'); end
ModelParam.el = parseE(ModelParam.el, ModelParam.tc);
if isnan(ModelParam.el), error('Invalid value for parameter Ep.'); end
ModelParam.ee = parseE(ModelParam.ee, ModelParam.tc);
if isnan(ModelParam.ee), error('Invalid value for parameter Ep.'); end

if ~isscalar(ModelParam.th), error('Invalid value for parameter Th.'); end
if ~isscalar(ModelParam.aw(1)) || ~isscalar(ModelParam.aw(2)) || ...
        (ModelParam.aw(1) < 0) || (ModelParam.aw(2) < ModelParam.aw(1))
    error('Invalid value for parameter Th.');
end

if ~isscalar(ModelParam.mp) || (ModelParam.mp <= 0)
    error('Invalid value for parameter mp.');
end

%----------------------------------local functions---------------------------------
function boolean = isscalar(V)

if isnumeric(V) && (ndims(V) == 2) && (length(V) == 1)
    boolean = true;
else
    boolean = false;
end

%----------------------------------------------------------------------------------
function E = parseE(Val, Tc)

E = NaN;

if ~isnumeric(Val), return; end

if length(Val) == 1, 
    if ~isscalar(Val), return; else E = Val; end
elseif length(Val) == 2,
    if ~isscalar(Val(1)) || ~isscalar(Val(2)) || ~all(Val >= 0), return;
    else E = nernst(Tc, +1, Val(1), Val(2)); end
end

%----------------------------------------------------------------------------------