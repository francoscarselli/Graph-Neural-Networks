%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function initializeComparisonNet
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% activation functions must be chosen in the learnComparisonNet.m and in
% testComparisonNet
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global dataSet comparisonNet comparisonNetLearning

comparisonNet=[];
comparisonNetLearning=[];

comparisonNet.useSaturationControl=1;


comparisonNet.nHiddens=20;
comparisonNetLearning.learningSteps=2000;


comparisonNet.weightRange=0.01;
comparisonNet.nInputs=size(dataSet.trainSet.nodeLabels,1);
comparisonNet.nOuts=1;


rand('state',sum(100*clock))

comparisonNet.parameters.weights1=2*(rand(comparisonNet.nHiddens,comparisonNet.nInputs)-0.5)*comparisonNet.weightRange;
comparisonNet.parameters.bias1=2*(rand(comparisonNet.nHiddens,1)-0.5)*comparisonNet.weightRange;
comparisonNet.parameters.weights2=2*(rand(comparisonNet.nOuts,comparisonNet.nHiddens)-0.5)*comparisonNet.weightRange;
comparisonNet.parameters.bias2=2*(rand(comparisonNet.nOuts,1)-0.5)*comparisonNet.weightRange;
comparisonNetLearning.learningRate=0.001;


comparisonNetLearning.nSteps=1;
comparisonNetLearning.allSteps=1;


comparisonNetLearning.stepsForValidation=100;
comparisonNetLearning.bestErrorOnValidation=realmax;
comparisonNetLearning.history.validationErrorHistory=0;

% rprop initialization
comparisonNet.rProp.deltaMax=50;
comparisonNet.rProp.deltaMin=1e-6;
comparisonNet.rProp.etaP=1.2;
comparisonNet.rProp.etaM=0.5;

%saturation
comparisonNet.saturationThreshold=0.99;
comparisonNet.saturationCoeff=0.1;

for it1=fieldnames(comparisonNet.parameters)'
    comparisonNetLearning.rProp.delta.(char(it1))=0.001*ones(size(comparisonNet.parameters.(char(it1))));
    comparisonNetLearning.rProp.deltaW.(char(it1))=zeros(size(comparisonNet.parameters.(char(it1))));
    comparisonNetLearning.rProp.oldGradient.(char(it1))=zeros(size(comparisonNet.parameters.(char(it1))));
end


comparisonNetLearning.oldP=comparisonNet.parameters;
