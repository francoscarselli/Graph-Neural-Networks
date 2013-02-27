%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



%function grad=neuralModelGetDeltaJacobian(dataset,p,forwardState,jacobian,jacobianError,sys)
function grad=neuralModelGetDeltaJacobian(dataset,jacobian,jacobianError,forwardState)

global dataSet dynamicSystem learning

%xdim=dynamicSystem.config.nStates;

pe=reshape(jacobianError,dynamicSystem.config.nStates,dataSet.(dataset).nNodes);
pa=dataSet.(dataset).neuralModel.arcOfFatherMatrix * pe';
[arc,j]=find(pa~=0);

if isempty(forwardState)
    base=learning.current.forwardState.transitionNetState.inputs(:,arc); %dataset.neuralModel.fatherOfArc(arc));
else
    base=forwardState.transitionNetState.inputs(:,arc); %dataset.neuralModel.fatherOfArc(arc));
end

for i=1:size(arc,1)
    delta(:,i)=pa(arc(i),j(i))*sign(jacobian((...
        dataSet.(dataset).neuralModel.childOfArc(arc(i))-1)*dynamicSystem.config.nStates+(1:dynamicSystem.config.nStates),...
        (dataSet.(dataset).neuralModel.fatherOfArc(arc(i))-1)*dynamicSystem.config.nStates+j(i)));    
end

%[y,netState]=feval(sys.transitionNet.forwardFunction,base,p.transitionNet);
netState=feval(dynamicSystem.config.transitionNet.forwardFunction,base,'transitionNet',0);

grad=feval(dynamicSystem.config.transitionNet.getDeltaJacobianFunction,dynamicSystem.parameters.transitionNet,netState,delta,j);
