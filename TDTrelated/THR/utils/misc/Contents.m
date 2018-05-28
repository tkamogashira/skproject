% misc: Miscellaneous utilities.
%
%  Plotting.
%    xplot               - add plot to existing plot(s)
%    dplot               - plot data using regular spaced X-axis
%    xdplot              - plot data using regular spaced X-axis to existing plot
%    xlog125             - set X-Axis to log and use decent labels a la .. 1 2 5 ..
%    ylog125             - set Y-Axis to log and use decent labels a la .. 1 2 5 ..
%    ylimstretch         - symmetrical stretching of y limits to cover given span
%    slope               - estimate slope of curve using mouse clicks
%    WithinCurve         - true if points lie within closed curve
%    AreaWithinCurve     - area enclosed by curve
%    OnPatch             - true if point lies on patch
%    patchArea           - area of a patch
%    RandDotsWithinCurve - RandDotsWithinCurve - N random points in the XY plane within given closed curve
%    patchdata           - Xdata and Ydata of a patch as complex numbers with first point repeated
%
%  Directories, files and local settings.
%    EarlyRootDir        - root directory of Early toolbox
%    versiondir          - grand parent dir of Early path
%    setupdir            - folder containing setup info
%    GUIdefaultsDir      - folder containing default values for GUIs
%    StimDefDir          - folder containing stimulus definitions
%    CompuName           - name of computer
%    SetCompuName        - set name of computer
%    Where               - location
%
%  Setup and cache utils.
%    ToSetupFile         - save parameters in setup file
%    FromSetupFile       - retrieve parameters from setup file
%    SetupList           - list current setup files
%    setupFilename       - full name of setup file in  setup directory 
%    username            - name of current user
%    getcache            - retrieve cached stuff(from getcache)
%    listcache           - paramlist for cache file. Helper file for putcache & getcache.
%    putcache            - store stuff cache
%    rmcache             - remove cache file(s)
%    ToCacheFile         - store data in cache file (OBSOLETE)
%    FromCacheFile       - retrieve data from cache file  (OBSOLETE)
%    CacheFileNmax       - default sizes of cache files (OBSOLETE)
%    EmptyCacheFile      - remove cached data  (OBSOLETE)
%    MyFlag              - collection of persistent variables for private use
%
%  Fitting.
%    wlinsolve           - solve linear system Y = A*X using weight factors for Y data
%    wpolyfit            - Fit polynomial to data using weight factors. 
%    GVD                 - generalized VanderMonde matrix using inline objects
%    Monomial            - Evaluate monomial in several variables
%    polyvalND           - evaluation of polynomials in N variables
%    VarAccount          - percentage variance accounted for
%    PolyVal2D           - Evaluate polynomial in two variables
%    ConstrMin           - minimize quadratic form with linear constraints
%
%  Other.
%    RandomInt           - random integer
%    logispace           - Truly logarithmically spaced vector
%    SetRandState        - set random generator in arbitrary but reproducible state 
%    deNaN               - remove NaNs from array
%    maxcorr             - max correlation value
%    minmax              - minimum and maximum in one call
%    vcolon              - colon operator accepting vector input
%    betwixt             - test if value is between two given values
%    Clip                - clip values between a min and a max value
%    partitions          - all partitions of an integer
%    DiffMatrix          - matrix of all differences of vector elements
%    getFieldOrDefault   - return field of struct or default valueif field is not in struct
%    NsamplesofChain     - return numbers of samples for a chain of durations
%    substitute          - replace specific value(s) in a matrix by other value(s)
%    areObjects          - test if args are objects of a given kind
%    tprod               - tensor product

