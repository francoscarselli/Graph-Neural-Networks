%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



% function [e,outState]=rankingComputeError(x,trainSet,p,sys)
function [e,outState]=rankingComputeError(dataset,x,optimalParam)

global dataSet dynamicSystem

%in=[x;trainSet.nodeLabels];

%% x will be empty except when called to test the results
if isempty(x) && strcmp(dataset,'trainSet')
    in=[dynamicSystem.state;dataSet.trainSet.nodeLabels];
elseif isempty(x) && strcmp(dataset,'validationSet')
    in=[learning.current.validationState;dataSet.validationSet.nodeLabels];
else
    in=[x;dataSet.(dataset).nodeLabels];
end


%[outState.out,outState.outNetState]=feval(sys.outNet.forwardFunction,in,p.outNet);
outState.outNetState=feval(dynamicSystem.config.outNet.forwardFunction,in,'outNet',optimalParam);


% alpha value has been set experimentally
alpha=70;

%supervisedNodes=find(diag(trainSet.maskMatrix));
supervisedNodes=find(diag(dataSet.(dataset).maskMatrix));

%y=outState.out(supervisedNodes)';
y=outState.outNetState.outs(supervisedNodes)';

%e=errLogSig(alpha,trainSet.m,y);
e=errLogSig(alpha,dataSet.(dataset).m,y);

% outState.delta=zeros(1,size(trainSet.maskMatrix,1));
% outState.delta(supervisedNodes)=gradErrLogSig(alpha,trainSet.m,y);
outState.delta=zeros(1,size(dataSet.(dataset).maskMatrix,1));
outState.delta(supervisedNodes)=gradErrLogSig(alpha,dataSet.(dataset).m,y);
