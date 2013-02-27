%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



%function [gradient,dInputs]=backwardTwoLayerLinearOutNet(net,netState,delta,saturationControl,networkType)
function [gradient,dInputs]=backwardTwoLayerLinearOutNet(net,netState,delta)

global dynamicSystem comparisonNet

gradient.weights2=delta*netState.hiddens';

gradient.bias2=sum(delta,2);
dnet1=(net.weights2'*delta) .* (1-netState.hiddens.*netState.hiddens);

if dynamicSystem.config.useSaturationControl
    absval=abs(netState.hiddens)-dynamicSystem.config.saturationThreshold;
    absval(absval<0)=0;
    dnet1 = dnet1 + dynamicSystem.config.saturationCoeff.*absval.*sign(netState.hiddens);
end
gradient.weights1=dnet1*netState.inputs';

gradient.bias1=sum(dnet1,2);
dInputs=net.weights1'*dnet1;
