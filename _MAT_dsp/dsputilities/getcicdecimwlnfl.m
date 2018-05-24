function lengtharray = getcicdecimwlnfl(inWL,inFL,modestr, ...
    numSections, decimFactor, differentialDelay, outWL, sectionWL)

    lengtharray = 0;
    bgrowth = ceil(numSections*log2(decimFactor*differentialDelay));
    baccum  = inWL + bgrowth;
    
    switch modestr
        case 'fullprecision'
            sectionWL = ones(1,2*numSections) * baccum;
            sectionFL = ones(1,2*numSections) * inFL;
            outWL = baccum;
            outFL = inFL;
            lengtharray = [sectionWL sectionFL outWL outFL];
            
        case 'minwordlengths'
            b2Np1 = baccum - outWL;
            bj = b2discard(b2Np1, numSections, decimFactor, differentialDelay);
            sectionWL = zeros(1,2*numSections);
            sectionFL = zeros(1,2*numSections);
            for i = 1 : 2*numSections 
                sectionWL(i) = baccum - bj(i);
                sectionFL(i) = inFL - bj(i);
            end
            outFL = inFL - b2Np1;
            lengtharray = [sectionWL sectionFL outWL outFL];
            
        case 'specifywordlengths'
            sectionFL = zeros(size(sectionWL));
            for i = 1 : 2*numSections
                sectionFL(i) = inFL - (baccum - sectionWL(i));
            end
            outFL = inFL - (baccum - outWL);
            lengtharray = [sectionWL sectionFL outWL outFL];
    end

end

function bj = b2discard(b2Np1, N, R, D)
    bj = zeros(1,2*N);
    E2Np1 = 2^b2Np1;
    sigmasq2Np1 = E2Np1^2/12;
    for j = 0:1:2*N-1
        Fsqj = getSqSumImpulse(N,R,D,j);
        bj(j+1) = floor(0.5*log2(sigmasq2Np1/Fsqj*6.0/N));
        if bj(j+1) < 0
            bj(j+1) = 0;
        end
    end
end

function Fsqj = getSqSumImpulse(N,R,D,j)
    
    if j < N
        Fsqj = 0;
        lengthK = (R*D-1) * N + j;
        for idx = 0:1:lengthK
            upperLidx = floor(idx/(R*D));
            if upperLidx == 0
                hi = nchoosek(N-j-1+idx,idx);
            else
                hi = 0;
                for l=0:1:upperLidx
                    hi = hi + (-1)^l * nchoosek(N,l) * nchoosek(N-j-1+idx-(R*D*l),idx-(R*D*l));
                end
            end
            Fsqj = Fsqj + hi * hi;
        end
    else
        comb_idx = j + 1;
        lengthK = 2*N + 1 - comb_idx;
        hc = 0;
        Fsqj = 0;
        for idx=0:1:lengthK
            hc = (-1)^idx * nchoosek(2*N+1-comb_idx,idx);
            Fsqj = Fsqj + hc * hc;
        end
    end
    
end
