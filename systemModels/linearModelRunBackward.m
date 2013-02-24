%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



%function [dPar,deltaX,i]=linearModelRunBackward(maxIt,x,dataset,p,delta,forwardState,sys,stopCoef)
function [dPar,deltaX,i]=linearModelRunBackward(delta,forwardState,maxIt)
%% This function just calls backwark a given number of times and accumulate gradient in dPar

global dataSet dynamicSystem learning

sd=size(delta);
dX=delta(:);
totDeltaX=zeros(size(dX));

if isempty(maxIt)
    maxIt=learning.config.maxBackwardSteps;
end
for i=1:maxIt
    totDeltaX=totDeltaX+dX;
    if isempty(forwardState)
        dX=learning.current.forwardState.tranMatrix' * dX;
    else
        dX=forwardState.tranMatrix' * dX;
    end
    stabCoefficient=sum(sum(abs(dX))) /sum(sum(abs(totDeltaX)));
    if(stabCoefficient < learning.config.backwardStopCoefficient)
        break;
    end
end




%nLinks=sum(dataset.connMatrix);
nLinks=sum(dataSet.trainSet.connMatrix);

outDegreeFactor=1 ./ (nLinks+(nLinks==0));
% xm=kron(outDegreeFactor,ones(sd(1),sd(1)*sd(1))) .* kron(x(:)',eye(sd(1)));

%%%%%%%%%%%%%%% OPTIMIZATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% B = kron(A, ones(m,n)) -->  i = 1:p; i = i(ones(1,m),:);
%                             j = 1:q; j = j(ones(1,n),:);
%                             B = A(i,j);
%
%  and
%
% B = kron(A, eye(n));  -->  B = zeros([size(A) n n]);
%                            B(:,:,1:n+1:n^2) = repmat(A, [1 1 n]);
%                            B = permute(B, [3 1 4 2]);
%                            B = reshape(B, n*size(A));



xm=kron(outDegreeFactor,ones(sd(1),sd(1)*sd(1))) .* kron(dynamicSystem.state(:)',eye(sd(1)));

k=ones(sd(1),1);
j=1:dataSet.trainSet.nNodes; j = j(ones(1,sd(1)*sd(1)),:);
xm=outDegreeFactor(k,j);


tmp = zeros([1 dataSet.trainSet.nNodes*dynamicSystem.config.nStates sd(1) sd(1)]);
tmp(:,:,1:sd(1)+1:sd(1)*sd(1)) = repmat(dynamicSystem.state(:)', [1 1 sd(1)]);
tmp = permute(tmp, [3 1 4 2]);
xm = xm .* reshape(tmp, [sd(1) sd(1)*dataSet.trainSet.nNodes*dynamicSystem.config.nStates]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% M=extendedKron(dataset.connMatrix,xm,sd(1)*sd(1)) /sd(1);
% M=extendedKron(dataSet.trainSet.connMatrix,xm,sd(1)*sd(1)) /sd(1);
M=extendedKron('trainSet',xm,sd(1)*sd(1)) /sd(1);

deltaW=M' * totDeltaX;


% deltaW=reshape(deltaW,size(forwardState.transitionNet.outs));
if isempty(forwardState)
    deltaW=reshape(deltaW,size(learning.current.forwardState.transitionNetState.outs));
    % gradient=feval(sys.transitionNet.backwardFunction,p.transitionNet,forwardState.transitionNet,deltaW);
    gradient=feval(dynamicSystem.config.transitionNet.backwardFunction,dynamicSystem.parameters.transitionNet,...
        learning.current.forwardState.transitionNetState,deltaW);
else
    deltaW=reshape(deltaW,size(forwardState.transitionNetState.outs));
    % gradient=feval(sys.transitionNet.backwardFunction,p.transitionNet,forwardState.transitionNet,deltaW);
    gradient=feval(dynamicSystem.config.transitionNet.backwardFunction,dynamicSystem.parameters.transitionNet,...
        forwardState.transitionNetState,deltaW);
end


dPar.transitionNet=gradient;

totDeltaX=reshape(totDeltaX,size(delta));
if isempty(forwardState)
    %gradient=feval(sys.forcingNet.backwardFunction,p.forcingNet,forwardState.forcingNet,totDeltaX);
    gradient=feval(dynamicSystem.config.forcingNet.backwardFunction,dynamicSystem.parameters.forcingNet,...
        learning.current.forwardState.forcingNet,totDeltaX);
else
    %gradient=feval(sys.forcingNet.backwardFunction,p.forcingNet,forwardState.forcingNet,totDeltaX);
    gradient=feval(dynamicSystem.config.forcingNet.backwardFunction,dynamicSystem.parameters.forcingNet,...
        forwardState.forcingNet,totDeltaX);
end

dPar.forcingNet=gradient;

deltaX=reshape(dX,size(delta));