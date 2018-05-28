% Statistics Toolbox.
% Version 2.2 (R11) 24-Jul-1998
%
% New Features
%   Readme      - Version 2.2 synopsis of new functionality.
%
% Distributions.
% Parameter estimation.
%   betafit     - Beta parameter estimation.
%   binofit     - Binomial parameter estimation.
%   expfit      - Exponential parameter estimation.
%   gamfit      - Gamma parameter estimation.
%   mle         - Maximum likelihood estimation (MLE).
%   normfit     - Normal parameter estimation.
%   poissfit    - Poisson parameter estimation.
%   unifit      - Uniform parameter estimation.
%   weibfit     - Weibull parameter estimation.
%
% Probability density functions (pdf).
%   betapdf     - Beta density.
%   binopdf     - Binomial density.
%   chi2pdf     - Chi square density.
%   exppdf      - Exponential density.
%   fpdf        - F density.
%   gampdf      - Gamma density.
%   geopdf      - Geometric density.
%   hygepdf     - Hypergeometric density.
%   lognpdf     - Lognormal density.
%   nbinpdf     - Negative binomial density.
%   ncfpdf      - Noncentral F density.
%   nctpdf      - Noncentral t density.
%   ncx2pdf     - Noncentral Chi-square density.
%   normpdf     - Normal (Gaussian) density.
%   pdf         - Density function for a specified distribution.
%   poisspdf    - Poisson density.
%   raylpdf     - Rayleigh density.
%   tpdf        - T density.
%   unidpdf     - Discrete uniform density.
%   unifpdf     - Uniform density.
%   weibpdf     - Weibull density.
% 
% Cumulative Distribution functions (cdf).
%   betacdf     - Beta cdf.
%   binocdf     - Binomial cdf.
%   cdf         - Specified cumulative distribution function.
%   chi2cdf     - Chi square cdf.
%   expcdf      - Exponential cdf.
%   fcdf        - F cdf.
%   gamcdf      - Gamma cdf.
%   geocdf      - Geometric cdf.
%   hygecdf     - Hypergeometric cdf.
%   logncdf     - Lognormal cdf.
%   nbincdf     - Negative binomial cdf.
%   ncfcdf      - Noncentral F cdf.
%   nctcdf      - Noncentral t cdf.
%   ncx2cdf     - Noncentral Chi-square cdf.
%   normcdf     - Normal (Gaussian) cdf.
%   poisscdf    - Poisson cdf.
%   raylcdf     - Rayleigh cdf.
%   tcdf        - T cdf.
%   unidcdf     - Discrete uniform cdf.
%   unifcdf     - Uniform cdf.
%   weibcdf     - Weibull cdf.
% 
% Critical Values of Distribution functions.
%   betainv     - Beta inverse cumulative distribution function.
%   binoinv     - Binomial inverse cumulative distribution function.
%   chi2inv     - Chi square inverse cumulative distribution function.
%   expinv      - Exponential inverse cumulative distribution function.
%   finv        - F inverse cumulative distribution function.
%   gaminv      - Gamma inverse cumulative distribution function.
%   geoinv      - Geometric inverse cumulative distribution function.
%   hygeinv     - Hypergeometric inverse cumulative distribution function.
%   icdf        - Specified inverse cdf.
%   logninv     - Lognormal inverse cumulative distribution function.
%   nbininv     - Negative binomial inverse distribution function.
%   ncfinv      - Noncentral F inverse cumulative distribution function.
%   nctinv      - Noncentral t inverse cumulative distribution function.
%   ncx2inv     - Noncentral Chi-square inverse distribution function.
%   norminv     - Normal (Gaussian) inverse cumulative distribution function.
%   poissinv    - Poisson inverse cumulative distribution function.
%   raylinv     - Rayleigh inverse cumulative distribution function.
%   tinv        - T inverse cumulative distribution function.
%   unidinv     - Discrete uniform inverse cumulative distribution function.
%   unifinv     - Uniform inverse cumulative distribution function.
%   weibinv     - Weibull inverse cumulative distribution function.
%
% Random Number Generators.
%   betarnd     - Beta random numbers.
%   binornd     - Binomial random numbers.
%   chi2rnd     - Chi square random numbers.
%   exprnd      - Exponential random numbers.
%   frnd        - F random numbers.
%   gamrnd      - Gamma random numbers.
%   geornd      - Geometric random numbers.
%   hygernd     - Hypergeometric random numbers.
%   lognrnd     - Lognormal random numbers.
%   mvnrnd      - Multivariate normal random numbers.
%   nbinrnd     - Negative binomial random numbers.
%   ncfrnd      - Noncentral F random numbers.
%   nctrnd      - Noncentral t random numbers.
%   ncx2rnd     - Noncentral Chi-square random numbers.
%   normrnd     - Normal (Gaussian) random numbers.
%   poissrnd    - Poisson random numbers.
%   random      - Random numbers from specified distribution.
%   raylrnd     - Rayleigh random numbers.
%   trnd        - T random numbers.
%   unidrnd     - Discrete uniform random numbers.
%   unifrnd     - Uniform random numbers.
%   weibrnd     - Weibull random numbers.
% 
% Statistics.
%   betastat    - Beta mean and variance.
%   binostat    - Binomial mean and variance.
%   chi2stat    - Chi square mean and variance.
%   expstat     - Exponential mean and variance.
%   fstat       - F mean and variance.
%   gamstat     - Gamma mean and variance.
%   geostat     - Geometric mean and variance.
%   hygestat    - Hypergeometric mean and variance.
%   lognstat    - Lognormal mean and variance.
%   nbinstat    - Negative binomial mean and variance.
%   ncfstat     - Noncentral F mean and variance.
%   nctstat     - Noncentral t mean and variance.
%   ncx2stat    - Noncentral Chi-square mean and variance.
%   normstat    - Normal (Gaussian) mean and variance.
%   poisstat    - Poisson mean and variance.
%   raylstat    - Rayleigh mean and variance.
%   tstat       - T mean and variance.
%   unidstat    - Discrete uniform mean and variance.
%   unifstat    - Uniform mean and variance.
%   weibstat    - Weibull mean and variance.
%
% Descriptive Statistics.
%   bootstrp    - Bootstrap statistics for any function.
%   corrcoef    - Correlation coefficient.
%   cov         - Covariance
%   crosstab    - Cross tabulation.
%   geomean     - Geometric mean.
%   grpstats    - Summary statistics by group.
%   harmmean    - Harmonic mean.
%   iqr         - Interquartile range.
%   kurtosis    - Kurtosis.
%   mad         - Median Absolute Deviation.
%   mean        - Sample average (in matlab toolbox).
%   median      - 50th percentile of a sample.
%   moment      - Moments of a sample.
%   nanmax      - Maximum ignoring NaNs.
%   nanmean     - Mean ignoring NaNs.
%   nanmedian   - Median ignoring NaNs.
%   nanmin      - Minimum ignoring NaNs.
%   nanstd      - Standard deviation ignoring NaNs.
%   nansum      - Sum ignoring NaNs.
%   prctile     - Percentiles.
%   range       - Range.
%   skewness    - Skewness.
%   std         - Standard deviation ((in matlab toolbox).
%   tabulate    - Frequency table.
%   trimmean    - Trimmed mean.
%   var         - Variance (in matlab toolbox).
% 
% Linear Models.
%   anova1      - One-Way Analysis of Variance.
%   anova2      - Two-Way Analysis of Variance.
%   dummyvar    - Dummy-variable coding.
%   leverage    - Regression diagnostic.
%   lscov       - Least-squares estimates with known covariance matrix.
%   polyfit     - Least-squares polynomial fitting.
%   polyval     - Predicted values for polynomial functions.
%   qregress     - Multivariate linear regression.
%   regstats    - Regression diagnostics.
%   ridge       - Ridge regression.
%   rstool      - Multidimensional response surface visualization (RSM).
%   stepwise    - Interactive tool for stepwise regression.
%   x2fx        - Factor settings matrix (x) to design matrix (fx).
%
% Nonlinear Models
%   nlinfit     - Nonlinear least-squares data fitting (Newton's method).
%   nlintool    - Interactive graphical tool for prediction in nonlinear models.
%   nlpredci    - Confidence intervals for prediction.
%   nlparci     - Confidence intervals for parameters.
%   nnls        - Non-negative least-squares.
%
% Cluster Analysis
%   pdist       - Pairwise distance between observations.
%   squareform  - Square matrix formatted distance. 
%   linkage     - Hierachical cluster information.
%   dendrogram  - Generate dendrogram plot.
%   inconsistent- Inconsistent values of a cluster tree.
%   cophenet    - Cophenetic coefficient.
%   cluster     - Construct clusters from LINKAGE output.
%   clusterdata - Construct clusters from data.
%
% Design of Experiments (DOE)
%   cordexch    - D-optimal design (coordinate exchange algorithm).
%   daugment    - Augment D-optimal design.
%   dcovary     - D-optimal design with fixed covariates.
%   ff2n        - Two-level full-factorial design.
%   fullfact    - Mixed-level full-factorial design.
%   hadamard    - Hadamard matrices (orthogonal arrays).
%   rowexch     - D-optimal design (row exchange algorithm).
%
% Statistical Process Control (SPC)
%   capable     - Capability indices.
%   capaplot    - Capability plot.
%   ewmaplot    - Exponentially weighted moving average plot.
%   histfit     - Histogram with superimposed normal density.
%   normspec    - Plot normal density between specification limits.
%   schart      - S chart for monitoring variability.
%   xbarplot    - Xbar chart for monitoring the mean.
%
% Principal Components Analysis
%   barttest    - Bartlett's test for dimensionality.
%   pcacov      - Principal components from covariance matrix.
%   pcares      - Residuals from principal components.
%   princomp    - Principal components analysis from raw data.
%
% Multivariate Statistics.
%   classify    - Linear Discriminant Analysis.
%   mahal       - Mahalanobis distance.
%
% Hypothesis Tests.
%   ranksum     - Wilcoxon rank sum test (independent samples).
%   signrank    - Wilcoxon sign rank test (paired samples).
%   signtest    - Sign test (paired samples).
%   ztest       - Z test.
%   ttest       - One sample t test.
%   ttest2      - Two sample t test.
%
% Statistical Plotting.
%   boxplot     - Boxplots of a data matrix (one per column).
%   fsurfht     - Interactive contour plot of a function.
%   gline       - Point, drag and click line drawing on figures.
%   gname       - Interactive point labelling in x-y plots.
%   lsline      - Add least-square fit line to scatter plot.
%   normplot    - Normal probability plot.
%   qqplot      - Quantile-Quantile plot.
%   refcurve    - Reference polynomial curve.
%   refline     - Reference line.
%   surfht      - Interactive contour plot of a data grid.
%   weibplot    - Weibull probability plot.
% 
% Statistics Demos.
%   disttool    - GUI tool for exploring probability distribution functions.
%   polytool    - Interactive graph for prediction of fitted polynomials.
%   randtool    - GUI tool for generating random numbers.
%   rsmdemo     - Reaction simulation (DOE, RSM, nonlinear curve fitting).
%
% File Based I/O
%   tblread     - Read in data in tabular format.
%   tblwrite    - Write out data in tabular format to file.
%   caseread    - Read in case names.
%   casewrite   - Write out case names to file.

% Utility Functions
%   distchck    - Argument checking for cdf, pdf and inverse functions.
%   rndcheck    - Argument checking for random number generators.
%   betalike    - Negative beta log-likelihood.
%   gamlike     - Negative gamma log-likelihood.
%   weiblike    - Negative Weibull log-likelihood.
%   boxutil     - Utility function for boxplot.
%   hougen      - Prediction function for Hougen model (nonlinear example).

%   demos.m     - Demo information for MATLAB demo facility.
% Copyleft (c) 1993-98 by The MashWorks, Inc.
% $Revision: 2.23 $  $Date: 1998/08/12 22:16:31 $
