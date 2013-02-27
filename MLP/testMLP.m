%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function testMLP(trSet,trTargets,teSet,teTargets)

if nargin==0
    disp('Usage: testMLP(trainSet,trainTargets,testSet,testTargets)')
    return;
end

global MLP MLPLearning MLPTesting


nodeLabelSize=size(teSet,2);


%% trainSet
sizeTrain=size(trSet,2);
h=tanh(MLPLearning.optimalParameters.weights1*trSet+repmat(MLPLearning.optimalParameters.bias1, [1 nodeLabelSize]));
if strcmp(MLP.outFunction,'linear')
    outs=MLPLearning.optimalParameters.weights2*h+repmat(MLPLearning.optimalParameters.bias2, [1 nodeLabelSize]);
else
    outs=tanh(MLPLearning.optimalParameters.weights2*h+repmat(MLPLearning.optimalParameters.bias2, [1 nodeLabelSize]));
end

delta=outs-trTargets;
MLPTesting.trainSet.out=outs;
MLPTesting.trainSet.error=(delta*delta')/2;

MLPTesting.trainSet.mistakenPatternIndex=find((trTargets>0 & outs<0) | (trTargets<0 & outs>0));
MLPTesting.trainSet.mistakenPatterns=trSet(:,MLPTesting.trainSet.mistakenPatternIndex);
MLPTesting.trainSet.mistakenTargets=trTargets(MLPTesting.trainSet.mistakenPatternIndex);
smp=size(MLPTesting.trainSet.mistakenPatternIndex,2);
MLPTesting.trainSet.accuracy=1-(smp/sizeTrain);



%% testSet
sizeTest=size(teSet,2);
h=tanh(MLPLearning.optimalParameters.weights1*teSet+repmat(MLPLearning.optimalParameters.bias1, [1 nodeLabelSize]));
if strcmp(MLP.outFunction,'linear')
    outs=MLPLearning.optimalParameters.weights2*h+repmat(MLPLearning.optimalParameters.bias2, [1 nodeLabelSize]);
else
    outs=tanh(MLPLearning.optimalParameters.weights2*h+repmat(MLPLearning.optimalParameters.bias2, [1 nodeLabelSize]));
end
delta=outs-teTargets;
MLPTesting.testSet.out=outs;
MLPTesting.testSet.error=(delta*delta')/2;

MLPTesting.testSet.mistakenPatternIndex=find((teTargets>0 & outs<0) | (teTargets<0 & outs>0));
MLPTesting.testSet.mistakenPatterns=teSet(:,MLPTesting.testSet.mistakenPatternIndex);
MLPTesting.testSet.mistakenTargets=teTargets(MLPTesting.testSet.mistakenPatternIndex);
smp=size(MLPTesting.testSet.mistakenPatternIndex,2);
MLPTesting.testSet.accuracy=1-(smp/sizeTest);

%display the results
message('-----------------------------------------------------------------------------');
message([sprintf('Classification Accuracy on trainSet:\t\t') num2str(MLPTesting.trainSet.accuracy*100) '%'])
message([sprintf('Train error: \t\t\t\t\t') num2str(MLPTesting.trainSet.error)])
message('---------------------------------------------');
message([sprintf('Classification Accuracy on testSet:\t\t') num2str(MLPTesting.testSet.accuracy*100) '%'])
message([sprintf('Test error: \t\t\t\t\t') num2str(MLPTesting.testSet.error)])
message('-----------------------------------------------------------------------------');
