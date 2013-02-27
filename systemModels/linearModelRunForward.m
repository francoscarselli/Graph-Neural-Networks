%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



% function [r,state,i]=linearModelRunForward(maxIt,x,dataset,p,sys,stopCoef)
function [r,state,i]=linearModelRunForward(maxIt,x,dataset,optimalParam)
%% This function just call forward a number "n" of times and compute the new state.

global dynamicSystem dataSet learning

% [f,state.transitionNet]=feval(sys.transitionNet.forwardFunction,dataset.nodeLabels,p.transitionNet);
% sf=size(f);
state.transitionNetState=feval(dynamicSystem.config.transitionNet.forwardFunction,dataSet.(dataset).nodeLabels,'transitionNet',optimalParam);
sf=size(state.transitionNetState.outs);
sqrt_val=sqrt(sf(1));

nLinks=sum(dataSet.(dataset).connMatrix);
outDegreeFactor=1 ./ (nLinks+(nLinks==0));
%f=kron(outDegreeFactor,ones(sf(1),1)) .* f /sqrt(sf(1)) ;


%%%%%%%%%%%%%%% OPTIMIZATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% B = kron(A, ones(m,n)) -->  i = 1:p; i = i(ones(1,m),:);
%                             j = 1:q; j = j(ones(1,n),:);
%                             B = A(i,j);

%transitionNetState.outs=kron(outDegreeFactor,ones(sf(1),1)) .* state.transitionNetState.outs /sqrt(sf(1));
i=ones(sf(1),1); j=1:size(dataSet.(dataset).connMatrix,1); 
transitionNetState.outs=outDegreeFactor(i,j) .* state.transitionNetState.outs /sqrt_val ; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  


%weightMatrix=zeros(sqrt(sf(1)),sqrt(sf(1))*sf(2));
weightMatrix=zeros(sqrt_val,sqrt_val*sf(2));

%weightMatrix(:)=f(:);
weightMatrix(:)=transitionNetState.outs(:);


% state.tranMatrix=extendedKron(dataSet.(dataset).connMatrix,weightMatrix,sqrt(sf(1)));
state.tranMatrix=extendedKron(dataset,weightMatrix,sqrt_val);

%[state.forcingFactor,state.forcingNet]=feval(sys.forcingNet.forwardFunction,dataSet.(dataset).nodeLabels,p.forcingNet);
[state.forcingNet]=feval(dynamicSystem.config.forcingNet.forwardFunction,dataSet.(dataset).nodeLabels,'forcingNet',optimalParam);
%E=state.forcingFactor(:);
E=state.forcingNet.outs(:);

y=x(:);
for i=1:maxIt
    ny=state.tranMatrix *y+E;

    stabCoef=(sum(sum(abs(ny-y)))) / sum(sum(abs(y)));
    y=ny;
    if(stabCoef<learning.config.forwardStopCoefficient)
        break;
    end

end

r=zeros(size(x));
r(:)=y(:);
