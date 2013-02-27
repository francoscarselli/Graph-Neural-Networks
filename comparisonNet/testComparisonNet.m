%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function testComparisonNet

global dataSet comparisonNet comparisonNetLearning comparisonNetTesting

trainPatterns=size(dataSet.trainSet.nodeLabels,2);
testPatterns=size(dataSet.testSet.nodeLabels,2);

%% trainSet
sizeTrain=size(find(diag(dataSet.trainSet.maskMatrix)),1);
h=tanh(comparisonNetLearning.optimalParameters.weights1*dataSet.trainSet.nodeLabels+repmat(comparisonNetLearning.optimalParameters.bias1, [1 trainPatterns]));
if strcmp(comparisonNet.outFcn,'linear')
    trOuts=comparisonNetLearning.optimalParameters.weights2*h+repmat(comparisonNetLearning.optimalParameters.bias2, [1 trainPatterns]);
else
    trOuts=tanh(comparisonNetLearning.optimalParameters.weights2*h+repmat(comparisonNetLearning.optimalParameters.bias2, [1 trainPatterns]));
end
tmp=trOuts-dataSet.trainSet.targets;
comparisonNetTesting.trainSet.out=trOuts;
delta=(dataSet.trainSet.maskMatrix*(tmp'))';
comparisonNetTesting.trainSet.error=(delta*tmp')/2;

%testSet
sizeTest=size(find(diag(dataSet.testSet.maskMatrix)),1);
h=tanh(comparisonNetLearning.optimalParameters.weights1*dataSet.testSet.nodeLabels+repmat(comparisonNetLearning.optimalParameters.bias1, [1 testPatterns]));
if strcmp(comparisonNet.outFcn,'linear')
    teOuts=comparisonNetLearning.optimalParameters.weights2*h+repmat(comparisonNetLearning.optimalParameters.bias2, [1 testPatterns]);
else
    teOuts=tanh(comparisonNetLearning.optimalParameters.weights2*h+repmat(comparisonNetLearning.optimalParameters.bias2, [1 testPatterns]));
end
tmp=teOuts-dataSet.testSet.targets;
comparisonNetTesting.testSet.out=teOuts;
delta=(dataSet.testSet.maskMatrix*(tmp'))';
comparisonNetTesting.testSet.error=(delta*tmp')/2;



if  strcmp(dataSet.config.type,'classification')
    % trainSet
    comparisonNetTesting.trainSet.mistakenPatternIndex=find((dataSet.trainSet.targets>0 & trOuts <dataSet.config.rejectUpperThreshold ) | ...
        (dataSet.trainSet.targets<0 & trOuts > dataSet.config.rejectLowerThreshold) );
    comparisonNetTesting.trainSet.mistakenPatterns=dataSet.trainSet.nodeLabels(:,comparisonNetTesting.trainSet.mistakenPatternIndex);
    comparisonNetTesting.trainSet.mistakenTargets=dataSet.trainSet.targets(comparisonNetTesting.trainSet.mistakenPatternIndex);
    smpot=size(comparisonNetTesting.trainSet.mistakenPatternIndex,2);
    comparisonNetTesting.trainSet.accuracy=1-(smpot/sizeTrain);

    
    % testSet
    comparisonNetTesting.testSet.mistakenPatternIndex=find((dataSet.testSet.targets>0 & teOuts <dataSet.config.rejectUpperThreshold) | ...
        (dataSet.testSet.targets<0 & teOuts > dataSet.config.rejectLowerThreshold) );
    comparisonNetTesting.testSet.mistakenPatterns=dataSet.testSet.nodeLabels(:,comparisonNetTesting.testSet.mistakenPatternIndex);
    comparisonNetTesting.testSet.mistakenTargets=dataSet.testSet.targets(comparisonNetTesting.testSet.mistakenPatternIndex);
    smp=size(comparisonNetTesting.testSet.mistakenPatternIndex,2);
    comparisonNetTesting.testSet.accuracy=1-(smp/sizeTest);

    % evaluate accuracy on graphs (instead of on nodes)
    if isfield(dataSet.config,'graphDim')&&dataSet.trainSet.graphNum > 1
        % it makes sense to evaluate accuracy on graphs
        a={'trainSet','testSet'};
        for ai=1:size(a,2)
            eval(['err=zeros(size(dataSet.' a{ai} '.targets));']);
            eval(['err(comparisonNetTesting.'  a{ai} '.mistakenPatternIndex)=1;']);
            eval(['g_err=reshape(err,dataSet.config.graphDim,dataSet.' a{ai} '.graphNum);']);
            eval(['comparisonNetTesting.' a{ai} '.accuracyOnGraphs=size(find(sum(g_err)==0),2)/dataSet.' a{ai} '.graphNum;']);
        end
    end

    %display the results
    message('-----------------------------------------------------------------------------');
    message([sprintf('Classification Accuracy on trainSet:\t\t') num2str(comparisonNetTesting.trainSet.accuracy*100) '%'])
    if isfield(dataSet.config,'graphDim')&&dataSet.trainSet.graphNum > 1
        message([sprintf('Classification AccuracyOnGraphs on trainSet:\t') num2str(comparisonNetTesting.trainSet.accuracyOnGraphs*100) '%'])
    end
    message([sprintf('Train error: \t\t\t\t\t') num2str(comparisonNetTesting.trainSet.error)])
    message('---------------------------------------------');
    message([sprintf('Classification Accuracy on testSet:\t\t') num2str(comparisonNetTesting.testSet.accuracy*100) '%'])
    if isfield(dataSet.config,'graphDim')&&dataSet.trainSet.graphNum > 1
        message([sprintf('Classification AccuracyOnGraphs on testSet:\t') num2str(comparisonNetTesting.testSet.accuracyOnGraphs*100) '%'])
    end
    message([sprintf('Test error: \t\t\t\t\t') num2str(comparisonNetTesting.testSet.error)])
    message('-----------------------------------------------------------------------------');
else
    %trainSet
    comparisonNetTesting.trainSet.maxRelativeError=max(abs(comparisonNetTesting.trainSet.delta(supervisedNodesTrain) ./ dataSet.trainSet.targets(supervisedNodesTrain)));
    comparisonNetTesting.trainSet.acc5percent=size(find(abs(comparisonNetTesting.trainSet.delta(supervisedNodesTrain) ./ dataSet.trainSet.targets(supervisedNodesTrain))<0.05),2)/sizeTrain;
    comparisonNetTesting.trainSet.acc10percent=size(find(abs(comparisonNetTesting.trainSet.delta(supervisedNodesTrain) ./ dataSet.trainSet.targets(supervisedNodesTrain))<0.1),2)/sizeTrain;
    comparisonNetTesting.trainSet.maxError=max(abs(comparisonNetTesting.trainSet.delta(supervisedNodesTrain)));

    %testSet
    comparisonNetTesting.testSet.maxRelativeError=max(abs(comparisonNetTesting.testSet.delta(supervisedNodesTest) ./ dataSet.testSet.targets(supervisedNodesTest)));
    comparisonNetTesting.testSet.acc5percent=size(find(abs(comparisonNetTesting.testSet.delta(supervisedNodesTest) ./ dataSet.testSet.targets(supervisedNodesTest))<0.05),2)/sizeTest;
    comparisonNetTesting.testSet.acc10percent=size(find(abs(comparisonNetTesting.testSet.delta(supervisedNodesTest) ./ dataSet.testSet.targets(supervisedNodesTest))<0.1),2)/sizeTest;
    comparisonNetTesting.testSet.maxError=max(abs(comparisonNetTesting.testSet.delta(supervisedNodesTest)));

    %display the results
    message(sprintf('\n----------------------------------------'));
    message([sprintf('Error on trainSet:\t\t') num2str(comparisonNetTesting.trainSet.error)])
    message([sprintf('maxError on trainSet:\t\t') num2str(comparisonNetTesting.trainSet.maxError)])
    message([sprintf('maxRelativeError on trainSet:\t') num2str(comparisonNetTesting.trainSet.maxRelativeError)])
    message([sprintf('err < 0.05:\t\t\t') num2str(comparisonNetTesting.trainSet.acc5percent*100,'%4.2f') '%'])
    message([sprintf('err < 0.1:\t\t\t') num2str(comparisonNetTesting.trainSet.acc10percent*100,'%4.2f') '%'])
    message('-----------------------------');
    message([sprintf('Error on testSet:\t\t') num2str(comparisonNetTesting.testSet.error)])
    message([sprintf('maxError on testSet:\t\t') num2str(comparisonNetTesting.testSet.maxError)])
    message([sprintf('maxRelativeError on testSet:\t') num2str(comparisonNetTesting.testSet.maxRelativeError)])
    message([sprintf('err < 0.05:\t\t\t') num2str(comparisonNetTesting.testSet.acc5percent*100,'%4.2f') '%'])
    message([sprintf('err < 0.1:\t\t\t') num2str(comparisonNetTesting.testSet.acc10percent*100,'%4.2f') '%'])
    message(sprintf('----------------------------------------\n'));
end