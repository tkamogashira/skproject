% CONVERSION
%
% Decibels, ERBs & cochleas.
%   A2dB             - convert amplitude ratio to dB
%   dB2A             - convert dB to amplitude ratio
%   P2dB             - convert power ratio do dB
%   dB2P             - convert dB to power ratio
%   Cspec2Magn_Phase - convert complex spectrum into magnitude and phase
%   Magn_phase2Cspec - convert complex spectrum into magnitude and phase
%   dB2dBA           - convert dB SPL to dBA
%   RMS              - root mean square of an array.
%   RMSdB            - RMS in dB re RMS==1
%   SNR2std          - convert S/N ratio of spectral components to standard deviation
%   SNR2W            - convert S/N ratio of spectral components to weight factors
%   Freq2ERB         - converts frequency in Hz to Oxford ERB scale.
%   ERB2Freq         - converts Oxford ERB-scale to frequency in Hz
%   greenwood        - Greenwood's cochlear map for the cat
%
% Phases.
%   cangle           - phase angle of complex number in cycles
%   cunwrap          - unwrap phase data expressed in cycles
%   ucunwrap         - unwrap phase data expressed in cycles which are not sorted in frequency
%   delayPhase       - delay Phase-versus-frequency data
%   phaseMean        - vector avarage of phase values in cycles
%   LinPhaseFit      - linear fit of unwrapped phase data
%   phaseResidue     - sum of squared phase deviations
%   Cspec2Magn_Phase - convert complex spectrum into magnitude and phase
%   Magn_phase2Cspec - convert complex spectrum into magnitude and phase
%
% Structs.
%   CollectInStruct  - collect variables in struct
%   combineStruct    - combine two struct into one
%   structJoin       - combine struct vars into a single struct
%   structPart       - select subset of fields from struct
%   structCompare    - compare two structs
%   FullFieldnames   - change fieldnames of struct into their official versions
%   AddPrefix        - insert prefix into field names of struct
%   dePrefix         - remove prefix from field names of struct
%   structFlatten    - flatten struct by expanding any struct-valued fields
%   MultiStruct      - convert struct with multi-values fields to array of struct with single-valued fields
%   PackInStructStr  - command that packes variables in a struct
%   evalStructFields - evaluate the fields of a struct
%   emptystruct      - 0x0 sized struct with given field names
%   VoidStruct       - structure with all empty fields
%   structseparator  - helper function for structPart, etc
%   contour2struct   - convert CONTOUR output to struct.
%   struct2contour   - convert struct array to CONTOUR output format.
%
% Strings <-> numbers
%   vector2str       - convert numerical array to string
%   kstr2num         - kstr2num = convert k-string to number, e.g. 3k4 -> 3400
%   str2doublemat    - convert string to double precision matrix.
%   DurString        - string indicating a duration
%   MoutofNstr       - aligned 'M/N' string
%   Seed2Str         - convert integer to string
%   Str2Seed         - convert char string into unique integer.
%   sizeString       - string describing size
%   zeropadint2str   - convert integer to fixed length string by padding zeros
%
% Various numerical.
%   deciRound        - round towards given decimal precision
%   deciFloor        - truncate towards given decimal precision
%   DeciCeil         - upward rounding towards given decimal precision
%   NthFloor         - downward rounding to given set of values
%   isConstant       - test whether all elements of array are equal
%   LoopMean         - subaverage an array
%   LoopMedian       - median of the subsequent cycles of an array
%   fracLoopMean     - average subsequent cycles of an array; fractional lengths allowed
%   denan            - remove NaNs from array
%   impara           - impedance of parallel impedances
%   PolyDiff         - derivative of a polynomial
%   PtoZ             - convert Proportion to Z-Score
%   ZtoP             - convert Z-Score to proportion
%   reladev          - relative deviation between two values
%   PowerCompress    - instantaneous power-law compression of waveforms
%   harmApp          - approximate cyclic signal by first N harmonics
%   sparsify         - approximation of a function
%
% Sizes, syntax and all that.
%   SameSize         - SameSize - make set of variables equal in size
%   swap             - swap two input values
%   Columnize        - reshape array into column array
%   DealElements     - deal the elements of an array over different variables.
%   VectorZip        - interleave N equal-length vectors
%   Uniquify         - reduce vector to scalar if all elements are equal
%   cellify           - put value in 1-element cell array unless it is already a cell
%   pad              - pad values to a vector
%   horzPadCat       - hozrcat with padded numbers to make things fit
%   isemptynum       - checks if a number is equal to []
%   CheckRealNumber  - checks if the arg is a real number of correct size and value
%   issinglerealnumber - true for real scalars
%   isSingleHandle   - test if argument is a single handle
%   handleTest       - test if h is a valid graphics object handle and test object type
%   numericTest      - test whether a numeric meets a given condition
%   sortAccord       - sort array X according to the order of array Y
%   multisort        - sort multiple arrays together
%   TempColumnize    - temporary reshaping into column
%
% Various
%   FHANDLE          - convert filename to function handle
%   parentfigh       - handle of parent figure
%   parentAxesh      - handle of parent axes
%   ISFHANDLE        - true function handle
%   istypedhandle    - true for handle of a specified type
%   stripCallback    - remove obligatory Src, Event callback args
%   nope             - do nothing
%   ear2DAchan       - convert ear specification to DA-channel spec
%
% Obsolete and/or untested.
%   UnitConvert      - conversion factors for change of units
%   dimensionTest    - test dimension of a variable or constant
%   isFixedDimSpec   - true if specification of dimension represents a fixed size
%   FixObjectFormat  - ensure the consistency among different formats of a constructor call
%   GenericCellFun   - generalized Cellfun
%   DimFix           - clone elements of a single vector in order to comply with DimSpec


