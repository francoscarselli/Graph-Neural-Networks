%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



%function [gradient,dInputs]=neuralModelWithProductComputeDeltaError(x,p,outState,sys)
function [gradient,dInputs]=neuralModelWithProductComputeDeltaError(outState)

global dynamicSystem learning

%sx=size(x);
sx=size(dynamicSystem.state,1);

if isempty(outState)
    %[gradient.outNet,dI]=feval(sys.outNet.backwardFunction,p.outNet,outState.outNetState,outState.delta.*x(1,:));
    [gradient.outNet,dI]=feval(dynamicSystem.config.outNet.backwardFunction,dynamicSystem.parameters.outNet,...
        learning.current.outState.outNetState,learning.current.outState.delta.*dynamicSystem.state(1,:));
    %dInputs(1,:)=dI(1,:)+outState.delta .* outState.outNetState.outs;
    dInputs(1,:)=dI(1,:)+learning.current.outState.delta .* learning.current.outState.outNetState.outs;
else
     %[gradient.outNet,dI]=feval(sys.outNet.backwardFunction,p.outNet,outState.outNetState,outState.delta.*x(1,:));
    [gradient.outNet,dI]=feval(dynamicSystem.config.outNet.backwardFunction,dynamicSystem.parameters.outNet,...
        outState.outNetState,outState.delta.*dynamicSystem.state(1,:));
    %dInputs(1,:)=dI(1,:)+outState.delta .* outState.outNetState.outs;
    dInputs(1,:)=dI(1,:)+outState.delta .* outState.outNetState.outs;
end

%dInputs(2:sx(1),:)=dI(2:sx(1),:);
dInputs(2:sx,:)=dI(2:sx,:);