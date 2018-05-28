function P = SqueezeParam(P)
%SQUEEZEPARAM   reduce size of stimulus parameter.
%   P = SQUEEZEPARAM(P) reduce the stimulus parameter to a more economical
%   size. 
%   A stimulus parameter can vary with subsequence but also with playback
%   channel. A numerical stimulus parameter for a dataset can be fully
%   defined by a matrix where variation with subsequence is represented by
%   different rows, variation with playback channel corresponds to different
%   columns. A character string stimulus parameter can be defined by a cell-
%   array of strings.
%   A more economical representation of a stimulus parameter is to reduce
%   the number of rows to one if there isn't variation according to 
%   subsequence. If the stimulus parameters doesn't change with channel
%   the number of columns can be reduced to one.

%B. Van de Sande 27-07-2004

%Checking input parameters ...
if (nargin < 1), error('Wrong number of input arguments.'); end
if ~isnumeric(P) & ~iscellstr(P) & ~ischar(P),
    error('First argument should be stimulus parameter represented by a numerical matrix or a cell-array of strings.');
end

if ischar(P) | (isnumeric(P) & (length(P) == 1)), return;
else,
    [Nrow, Ncol] = size(P);
    if ~any(Ncol == [1, 2]), error('Stimulus parameter can only have one or two columns.'); end

    %Attention! NaN's or the empty string do not count when reducing a matrix or cell-array
    %containig values of a stimulus parameter. This is to be in accordance with the scalar 
    %value parameters of that are held constant when the requested subsequences weren't all
    %recorded ...
    if iscellstr(P),
        %if isequal(P(:, 1), P(:, end)), P = P(:, 1); end
        %if (Nrow > 1) & isequal(P{:, 1}) & isequal(P{:, end}), P = P(1, :); end
        %if (length(P) == 1), P = P{1}; end
        if (Ncol == 2) & isequal(P(:, 1), P(:, 2)), Ncol = 1; P = P(:, 1); end
        if (Ncol == 1),
            idx = find(~cellfun('isempty', P));
            if isempty(idx), P = '';
            elseif (length(unique(P(idx))) == 1), P = P{idx(1)}; end
        end
    else,
        if (Ncol == 2),
            [C1, idx1] = denan(P(:, 1)); [C2, idx2] = denan(P(:, 2));
            if isequal(idx1, idx2) & isequal(C1, C2), Ncol = 1; P = P(:, 1); end
        end
        if (Ncol == 1),
            if all(isnan(P)), P = NaN;
            elseif (length(unique(denan(P))) == 1), P = denan(P); P = P(1); end
            %elseif ~any(isnan(P)) & (length(unique(P)) == 1), P = P(1); end
        end
    end
end    