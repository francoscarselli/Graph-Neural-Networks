%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



%function [f,netState]=forwardTwoLayerLinearOutNet(x,net)
function netState=forwardTwoLayerLinearOutNet(x,net,optimalParam)

global dynamicSystem learning

%%%%%%% optimization: %%%%%%%%%%
%   kron(ones(m,n),A) -> repmat(A, [m n])

%o=tanh(net.weights1*x+kron(ones(1,sx),net.bias1));
%f=net.weights2*o+kron(ones(1,sx),net.bias2);
%netState.hiddens=o;

%% 1st version
%netState.hiddens=tanh(net.weights1*x+repmat(net.bias1,[1 sx]));
%f=net.weights2*netState.hiddens+repmat(net.bias2, [1 sx]);
%netState.outs=f;

%% 2nd version (new parameters)
sx=size(x,2);
if ~optimalParam
    netState.hiddens=tanh(dynamicSystem.parameters.(net).weights1*x+repmat(dynamicSystem.parameters.(net).bias1, [1 sx]));
    netState.outs=dynamicSystem.parameters.(net).weights2*netState.hiddens+repmat(dynamicSystem.parameters.(net).bias2, [1 sx]);
else
    netState.hiddens=tanh(learning.current.optimalParameters.(net).weights1*x+repmat(learning.current.optimalParameters.(net).bias1, [1 sx]));
    netState.outs=learning.current.optimalParameters.(net).weights2*netState.hiddens+repmat(learning.current.optimalParameters.(net).bias2, [1 sx]);
end
netState.inputs=x;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
