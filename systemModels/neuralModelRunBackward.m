%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



%% This function just calls backwark a given number of times and accumulate
%% gradient in dPar
%function [dPar,dX,i]=neuralModelRunBackward(maxIt,x,dataset,p,delta,forwardState,sys,stopCoef)
function [dPar,dX,i]=neuralModelRunBackward(delta,forwardState,maxIt)

global dataSet dynamicSystem learning

xdim=dynamicSystem.config.nStates;

%jacobian=feval(sys.forwardJacobianFunction,dataSet.trainSet,dynamicSystem.parameters,learning.current.forwardState,sys);
[learning.current.jacobian, learning.current.jacobianErrors] = feval(dynamicSystem.config.forwardJacobianFunction,'trainSet',forwardState);

dX=delta(:);
totDeltaX=zeros(size(dX));

if isempty(maxIt)
    maxIt=learning.config.maxBackwardSteps;
end
for i=1:maxIt
    totDeltaX=totDeltaX+dX;
    dX=learning.current.jacobian' * dX;
    stabCoefficient=sum(sum(abs(dX))) /sum(sum(abs(totDeltaX)));
    if(stabCoefficient < learning.config.backwardStopCoefficient) || (sum(sum(abs(totDeltaX))) == 0)
        break;
    end
end


dPar.transitionNet=feval(dynamicSystem.config.transitionNet.backwardFunction,dynamicSystem.parameters.transitionNet,...
    learning.current.forwardState.transitionNetState,reshape(totDeltaX'*dataSet.trainSet.neuralModel.childToArcMatrix',xdim,dataSet.trainSet.nArcs));
