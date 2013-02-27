%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function learnComparisonNet

global dataSet comparisonNet comparisonNetLearning

%% change it if you don't want to use validation
useValidation=1;

%comparisonNet.outFcn='linear'
comparisonNet.outFcn='tanh';

comparisonNetLearning.iStart=comparisonNetLearning.nSteps;
trainPatterns=size(dataSet.trainSet.nodeLabels,2);
valPatterns=size(dataSet.validationSet.nodeLabels,2);

%% MAIN LEARNING CYCLE

while comparisonNetLearning.nSteps<=comparisonNetLearning.iStart+comparisonNetLearning.learningSteps
    h=tanh(comparisonNet.parameters.weights1*dataSet.trainSet.nodeLabels+repmat(comparisonNet.parameters.bias1, [1 trainPatterns]));
    if strcmp(comparisonNet.outFcn,'linear')
        outs=comparisonNet.parameters.weights2*h+repmat(comparisonNet.parameters.bias2, [1 trainPatterns]);
    else
        outs=tanh(comparisonNet.parameters.weights2*h+repmat(comparisonNet.parameters.bias2, [1 trainPatterns]));
    end
    tmp=outs-dataSet.trainSet.targets;
    delta=(dataSet.trainSet.maskMatrix*(tmp'))';
    error=delta *tmp'/2;
    comparisonNetLearning.history.trainErrorHistory(comparisonNetLearning.allSteps)=error;
    comparisonNetLearning.oldP=comparisonNet.parameters;
    if strcmp(comparisonNet.outFcn,'linear')
        dnet2=delta;
    else
        dnet2=delta .* (1-outs.*outs);
    end
    if comparisonNet.useSaturationControl && strcmp(comparisonNet.outFcn,'tanh')
        absval=abs(outs)-comparisonNet.saturationThreshold;
        absval(absval<0)=0;
        dnet2 = dnet2 + comparisonNet.saturationCoeff.*absval.*sign(outs);
    end
    gradient.weights2=dnet2*h';
    gradient.bias2=sum(dnet2,2);
    dnet1=(comparisonNet.parameters.weights2'*dnet2) .* (1- h.*h);
    if comparisonNet.useSaturationControl
        absval=abs(h)-comparisonNet.saturationThreshold;
        absval(absval<0)=0;
        dnet1 = dnet1 + comparisonNet.saturationCoeff.*absval.*sign(h);
    end
    gradient.weights1=dnet1*dataSet.trainSet.nodeLabels';
    gradient.bias1=sum(dnet1,2);

    if mod(comparisonNetLearning.nSteps, comparisonNetLearning.stepsForValidation)==0
        disp(['step: ' num2str(comparisonNetLearning.nSteps) sprintf('\tFNN training error: ') num2str(error)]);
        if useValidation
            h=tanh(comparisonNet.parameters.weights1*dataSet.validationSet.nodeLabels+repmat(comparisonNet.parameters.bias1, [1 valPatterns]));
            if strcmp(comparisonNet.outFcn,'linear')
                outs=comparisonNet.parameters.weights2*h+repmat(comparisonNet.parameters.bias2, [1 valPatterns]);
            else
                outs=tanh(comparisonNet.parameters.weights2*h+repmat(comparisonNet.parameters.bias2, [1 valPatterns]));
            end
            vtmp=outs-dataSet.validationSet.targets;
            comparisonNetLearning.vDelta=(dataSet.validationSet.maskMatrix*(vtmp'))';
            comparisonNetLearning.vError=comparisonNetLearning.vDelta*vtmp'/2;
            comparisonNetLearning.history.validationErrorHistory=[comparisonNetLearning.history.validationErrorHistory,comparisonNetLearning.vError];
            if (comparisonNetLearning.vError < comparisonNetLearning.bestErrorOnValidation)
                comparisonNetLearning.bestErrorOnValidation=comparisonNetLearning.vError;
                comparisonNetLearning.optimalParameters=comparisonNet.parameters;
                comparisonNetLearning.optimalValidationOut=outs;
                disp([sprintf('\t\t\t') 'best validation error: ' num2str(comparisonNetLearning.vError)])
            end
        else
            comparisonNetLearning.optimalParameters=comparisonNet.parameters;
        end
    end

    %% update params
    for it1=fieldnames(gradient)'
        old4new=gradient.(char(it1)) .* comparisonNetLearning.rProp.oldGradient.(char(it1));
        comparisonNetLearning.rProp.delta.(char(it1)) =...
            (old4new>0) .* min(comparisonNet.rProp.deltaMax,comparisonNet.rProp.etaP * comparisonNetLearning.rProp.delta.(char(it1))) ...
            +(old4new<0) .* max(comparisonNet.rProp.deltaMin,comparisonNet.rProp.etaM * comparisonNetLearning.rProp.delta.(char(it1)))...
            +(old4new==0) .* comparisonNetLearning.rProp.delta.(char(it1));

        comparisonNetLearning.rProp.deltaW.(char(it1)) =...
            (old4new>0) .*(-sign(gradient.(char(it1))) .* comparisonNetLearning.rProp.delta.(char(it1)))...
            +(old4new<0) .* comparisonNetLearning.rProp.deltaW.(char(it1)) ...
            +(old4new==0) .* (-sign(gradient.(char(it1))) .* comparisonNetLearning.rProp.delta.(char(it1)));

        comparisonNet.parameters.(char(it1))=comparisonNetLearning.oldP.(char(it1)) ...
            +(old4new>0) .* comparisonNetLearning.rProp.deltaW.(char(it1)) ...
            -(old4new<0) .* comparisonNetLearning.rProp.deltaW.(char(it1)) ...
            +(old4new==0) .* comparisonNetLearning.rProp.deltaW.(char(it1));

        comparisonNetLearning.rProp.oldGradient.(char(it1))=...
            (old4new>=0) .* gradient.(char(it1))...
            +(old4new<0) .* zeros(size(gradient.(char(it1))));
    end
    comparisonNetLearning.nSteps=comparisonNetLearning.nSteps+1;
end
