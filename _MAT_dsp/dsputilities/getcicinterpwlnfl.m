function lengtharray = getcicinterpwlnfl(inWL,inFL,modestr, ...
    N, R, D, outWL, sectionWL)
    
    % calculate full precision
    fullWL = zeros(1,2*N);
    for i = 0:1:2*N-1
        if i < N
            G = 2^(i+1);
        else
            G = 2^(2*N-1-i) * (R*D)^(1+i-N) / R;
        end
        fullWL(i+1) = ceil(inWL + log2(G)); 
    end
    
    if D == 1
        fullWL(N) = inWL + (N-1);
    end
        
    switch modestr
        case 'fullprecision'
            sectionWL = fullWL;
            sectionFL = ones(1,2*N) * inFL;
            outWL = fullWL(end);
            outFL = inFL;
            lengtharray = [sectionWL sectionFL outWL outFL];
            
        case 'minwordlengths'
            sectionWL = fullWL;
            sectionFL = ones(1,2*N) * inFL;
            outFL = inFL - (fullWL(end) - outWL);
            lengtharray = [sectionWL sectionFL outWL outFL];
            
        case 'specifywordlengths'
            sectionFL = zeros(1,2*N);
            for i = 1:2*N
                bj = fullWL(i) - sectionWL(i); 
                sectionFL(i) = inFL - bj;
            end
            outFL = inFL - (fullWL(end) - outWL);
            lengtharray = [sectionWL sectionFL outWL outFL];
    end

end

