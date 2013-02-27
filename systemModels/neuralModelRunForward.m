%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



%function [x,state,i]=neuralModelRunForward(maxIt,x,dataset,p,sys,stopCoef)
function [x,state,i]=neuralModelRunForward(maxSteps,x,dataset,optimalParam)
%% This function just call forward a number "n" of times and compute the new state.

global dataSet dynamicSystem learning

if (isfield(dynamicSystem.config,'useLabelledEdges') && (dynamicSystem.config.useLabelledEdges==1))
    labels=[dataSet.(dataset).nodeLabels(:,dataSet.(dataset).neuralModel.childOfArc);dataSet.(dataset).nodeLabels(:,dataSet.(dataset).neuralModel.fatherOfArc);dataSet.(dataset).edgeLabels];
else
    labels=[dataSet.(dataset).nodeLabels(:,dataSet.(dataset).neuralModel.childOfArc);dataSet.(dataset).nodeLabels(:,dataSet.(dataset).neuralModel.fatherOfArc)];
end

%for i=1:maxIt
for i=1:maxSteps
    in=[x(:,dataSet.(dataset).neuralModel.fatherOfArc);labels];

    %[y,state.transitionNet]=feval(sys.transitionNet.forwardFunction,in,p.transitionNet);
    %s=dataset.neuralModel.childToArcMatrix' *y(:);
    %state.transitionNet=feval(sys.transitionNet.forwardFunction,in,'transitionNet');
    state.transitionNetState=feval(dynamicSystem.config.transitionNet.forwardFunction,in,'transitionNet',optimalParam);

    %s=dataset.neuralModel.childToArcMatrix' *state.transitionNet.outs(:);
    s=dataSet.(dataset).neuralModel.childToArcMatrix' *state.transitionNetState.outs(:);
    nx=reshape(s,size(x));
    stabCoef=(sum(sum(abs(x-nx)))) / sum(sum(abs(nx)));

    x=nx;
    if(stabCoef<learning.config.forwardStopCoefficient)
        break;
    end
end
