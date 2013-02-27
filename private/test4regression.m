%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function test4regression
% testing function for regression problems (private)



% Values computed for trainSet and testSet with current and optimal parameters
%   
%   - error
%   - maxError
%           the maximum of the error
%   - maxRelativeError
%           the maximum of the relative error, that for each sample i is given by 
%           (t_i-o_i) /o_i
%           where t_i is the target and o_i the output of the system.

global dataSet dynamicSystem learning testing TestFigH

dataSet.testSet.forwardSteps=50;

supervisedNodesTrain=find(diag(dataSet.trainSet.maskMatrix));
supervisedNodesTest=find(diag(dataSet.testSet.maskMatrix));
supervisedNodesNumberTrain=size(supervisedNodesTrain,1);
supervisedNodesNumberTest=size(supervisedNodesTest,1);



%evaluating current parameters on trainset
% [x,currentTrainForwardState]=feval(dynamicSystem.config.forwardFunction,dataSet.testSet.forwardSteps,dynamicSystem.state,dataSet.trainSet...
%     ,dynamicSystem.parameters,dynamicSystem.config);
[x,currentTrainForwardState]=feval(dynamicSystem.config.forwardFunction,dataSet.testSet.forwardSteps,dynamicSystem.state,'trainSet',0);
% [testing.current.trainSet.error,currentTrainOutState]=feval(dynamicSystem.config.computeErrorFunction,x,dataSet.trainSet,...
%     dynamicSystem.parameters,dynamicSystem.config);
[testing.current.trainSet.error,currentTrainOutState]=feval(dynamicSystem.config.computeErrorFunction,'trainSet',x,0);
testing.current.trainSet.maxRelativeError=max(abs(currentTrainOutState.delta(supervisedNodesTrain) ./ dataSet.trainSet.targets(supervisedNodesTrain)));
testing.current.trainSet.acc5percent=size(find(abs(currentTrainOutState.delta(supervisedNodesTrain)) ./ dataSet.trainSet.targets(supervisedNodesTrain)<0.05),2)/supervisedNodesNumberTrain;
testing.current.trainSet.acc10percent=size(find(abs(currentTrainOutState.delta(supervisedNodesTrain)) ./ dataSet.trainSet.targets(supervisedNodesTrain)<0.1),2)/supervisedNodesNumberTrain;
testing.current.trainSet.maxError=max(abs(currentTrainOutState.delta(supervisedNodesTrain)));
testing.current.trainSet.x=x;
testing.current.trainSet.out=currentTrainOutState.outNetState.outs;
testing.current.trainSet.outState=currentTrainOutState;
testing.current.trainSet.forwardState=currentTrainForwardState;


%evaluating optimal parameters on trainset
% [x,trainForwardState]=feval(dynamicSystem.config.forwardFunction,dataSet.testSet.forwardSteps,dynamicSystem.state,dataSet.trainSet,...
%     learning.current.optimalParameters,dynamicSystem.config);
[x,trainForwardState]=feval(dynamicSystem.config.forwardFunction,dataSet.testSet.forwardSteps,dynamicSystem.state,'trainSet',1);
% [testing.optimal.trainSet.error,trainOutState]=feval(dynamicSystem.config.computeErrorFunction,x,dataSet.trainSet,...
%     learning.current.optimalParameters,dynamicSystem.config);
[testing.optimal.trainSet.error,trainOutState]=feval(dynamicSystem.config.computeErrorFunction,'trainSet',x,1);
testing.optimal.trainSet.maxRelativeError=max(abs(trainOutState.delta(supervisedNodesTrain) ./ dataSet.trainSet.targets(supervisedNodesTrain)));
testing.optimal.trainSet.acc5percent=size(find(abs(trainOutState.delta(supervisedNodesTrain)) ./ dataSet.trainSet.targets(supervisedNodesTrain)<0.05),2)/supervisedNodesNumberTrain;
testing.optimal.trainSet.acc10percent=size(find(abs(trainOutState.delta(supervisedNodesTrain)) ./ dataSet.trainSet.targets(supervisedNodesTrain)<0.1),2)/supervisedNodesNumberTrain;
testing.optimal.trainSet.maxError=max(abs(trainOutState.delta(supervisedNodesTrain)));
testing.optimal.trainSet.x=x;
testing.optimal.trainSet.out=trainOutState.outNetState.outs;
testing.optimal.trainSet.outState=trainOutState;
testing.optimal.trainSet.forwardState=trainForwardState;

%evaluating current parameters on testset
% [x,currentTestForwardState]=feval(dynamicSystem.config.forwardFunction,dataSet.testSet.forwardSteps,...
%     zeros(dynamicSystem.config.nStates,dataSet.testSet.nNodes),dataSet.testSet,dynamicSystem.parameters,dynamicSystem.config);
% [x,currentTestForwardState]=feval(dynamicSystem.config.forwardFunction,dataSet.testSet.forwardSteps,...
%     zeros(dynamicSystem.config.nStates,dataSet.testSet.nNodes),dataSet.testSet,dynamicSystem.parameters,dynamicSystem.config);
[x,currentTestForwardState]=feval(dynamicSystem.config.forwardFunction,dataSet.testSet.forwardSteps,...
    sparse(dynamicSystem.config.nStates,dataSet.testSet.nNodes),'testSet',0);
% [testing.current.testSet.error,currentTestOutState]=feval(dynamicSystem.config.computeErrorFunction,x,dataSet.testSet,...
%     dynamicSystem.parameters,dynamicSystem.config);
[testing.current.testSet.error,currentTestOutState]=feval(dynamicSystem.config.computeErrorFunction,'testSet',x,0);
testing.current.testSet.maxRelativeError=max(abs(currentTestOutState.delta(supervisedNodesTest) ./ dataSet.testSet.targets(supervisedNodesTest)));
testing.current.testSet.acc5percent=size(find(abs(currentTestOutState.delta(supervisedNodesTest)) ./ dataSet.testSet.targets(supervisedNodesTest)<0.05),2)/supervisedNodesNumberTest;
testing.current.testSet.acc10percent=size(find(abs(currentTestOutState.delta(supervisedNodesTest)) ./ dataSet.testSet.targets(supervisedNodesTest)<0.1),2)/supervisedNodesNumberTest;
testing.current.testSet.maxError=max(abs(currentTestOutState.delta(supervisedNodesTest)));
testing.current.testSet.x=x;
testing.current.testSet.out=currentTestOutState.outNetState.outs;
testing.current.testSet.outState=currentTestOutState;
testing.current.testSet.forwardState=currentTestForwardState;

%evaluating optimal parameters on testset
% [x,testForwardState]=feval(dynamicSystem.config.forwardFunction,dataSet.testSet.forwardSteps,
%     zeros(dynamicSystem.config.nStates,dataSet.testSet.nNodes),dataSet.testSet,...
%     learning.current.optimalParameters,dynamicSystem.config);
[x,testForwardState]=feval(dynamicSystem.config.forwardFunction,dataSet.testSet.forwardSteps,sparse(dynamicSystem.config.nStates,dataSet.testSet.nNodes),...
    'testSet',1);
% [testing.optimal.testSet.error,testOutState]=feval(dynamicSystem.config.computeErrorFunction,x,dataSet.testSet,...
%     learning.current.optimalParameters,dynamicSystem.config);
[testing.optimal.testSet.error,testOutState]=feval(dynamicSystem.config.computeErrorFunction,'testSet',x,1);
testing.optimal.testSet.maxRelativeError=max(abs(testOutState.delta(supervisedNodesTest) ./ dataSet.testSet.targets(supervisedNodesTest)));
testing.optimal.testSet.acc5percent=size(find(abs(testOutState.delta(supervisedNodesTest)) ./ dataSet.testSet.targets(supervisedNodesTest)<0.05),2)/supervisedNodesNumberTest;
testing.optimal.testSet.acc10percent=size(find(abs(testOutState.delta(supervisedNodesTest)) ./ dataSet.testSet.targets(supervisedNodesTest)<0.1),2)/supervisedNodesNumberTest;
testing.optimal.testSet.maxError=max(abs(testOutState.delta(supervisedNodesTest)));
testing.optimal.testSet.x=x;
testing.optimal.testSet.out=testOutState.outNetState.outs;
testing.optimal.testSet.outState=testOutState;
testing.optimal.testSet.forwardState=testForwardState;

% displays results
global VisualMode
if VisualMode == 1
    TestFigH=DisplayTestR(testing.current.trainSet.error,testing.current.trainSet.acc5percent,testing.current.trainSet.acc10percent,...
        testing.optimal.trainSet.error,testing.optimal.trainSet.acc5percent,testing.optimal.trainSet.acc10percent,...
        testing.current.testSet.error,testing.current.testSet.acc5percent,testing.current.testSet.acc10percent,...
        testing.optimal.testSet.error,testing.optimal.testSet.acc5percent,testing.optimal.testSet.acc10percent);
else
    message(sprintf('\n\t\t\tTESTSET\t\t\t\t\tTRAINSET'));
    message(sprintf('--------------------------------------------------------------------------------------'));
    message([sprintf('\t\t| Error: \t\t') num2str(testing.optimal.testSet.error,'%10.5g') sprintf('\t\tError: \t\t\t') num2str(testing.optimal.trainSet.error,'%10.5g')]);
    message([sprintf('\t\t| maxError: \t\t') num2str(testing.optimal.testSet.maxError,'%10.5g') sprintf('\t\tmaxError: \t\t') num2str(testing.optimal.trainSet.maxError,'%10.5g')]);
    message([sprintf('OPTIMAL\t\t| maxRelativeError: \t') num2str(testing.optimal.testSet.maxRelativeError,'%10.5g') sprintf('\t\tmaxRelativeError: \t') num2str(testing.optimal.trainSet.maxRelativeError,'%10.5g')]);
    message([sprintf('\t\t| err < 0.05:\t\t') num2str(testing.optimal.testSet.acc5percent*100,'%4.2f') '%%' sprintf('\t\terr < 0.05:\t\t') num2str(testing.optimal.trainSet.acc5percent*100,'%4.2f') '%%']);
    message([sprintf('\t\t| err < 0.1:\t\t') num2str(testing.optimal.testSet.acc10percent*100,'%4.2f') '%%' sprintf('\t\terr < 0.1:\t\t') num2str(testing.optimal.trainSet.acc10percent*100,'%4.2f') '%%']);
    message(sprintf('\t\t|'));
    message([sprintf('\t\t| Error: \t\t') num2str(testing.current.testSet.error,'%10.5g') sprintf('\t\tError: \t\t\t') num2str(testing.current.trainSet.error,'%10.5g')]);
    message([sprintf('\t\t| maxError: \t\t') num2str(testing.current.testSet.maxError,'%10.5g') sprintf('\t\tmaxError: \t\t') num2str(testing.current.trainSet.maxError,'%10.5g')]);
    message([sprintf('CURRENT\t\t| maxRelativeError: \t') num2str(testing.current.testSet.maxRelativeError,'%10.5g') sprintf('\t\tmaxRelativeError: \t') num2str(testing.current.trainSet.maxRelativeError,'%10.5g')]);
    message([sprintf('\t\t| err < 0.05:\t\t') num2str(testing.current.testSet.acc5percent*100,'%4.2f') '%%' sprintf('\t\terr < 0.05:\t\t') num2str(testing.current.trainSet.acc5percent*100,'%4.2f') '%%']);
    message([sprintf('\t\t| err < 0.1:\t\t') num2str(testing.current.testSet.acc10percent*100,'%4.2f') '%%' sprintf('\t\terr < 0.1:\t\t') num2str(testing.current.trainSet.acc10percent*100,'%4.2f') '%%']);
    message(sprintf('--------------------------------------------------------------------------------------'));
end