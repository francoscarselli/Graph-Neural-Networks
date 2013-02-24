%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function saveOptimalParam(file)

global learning dynamicSystem


optimalParam = learning.current.optimalParameters;
sysconfig = dynamicSystem.config;
learnconfig = learning.config;
a = pwd;
cd /tmp

if nargin == 0
    file='/tmp/optimalParam.txt';
end


h=fopen(file,'wt');
if h==-1
    error(['Cannot open file ' file]);
else
    fprintf(h,'#nConfiguration: nStates useLabelledEdges errorFunction \n');
    fprintf(h,'#transitionNet: architecture(#in, #h, #o) outActivationFunction \n');
    fprintf(h,'#outNet: architecture(#in, #h, #o) outActivationFunction \n');
    fprintf(h,'#OptimalParam: outNet(w1,b1,w2,b2) transitionNet(w1,b1,w2,b2) \n');
    
    fprintf(h,'%d %d %s\n',sysconfig.nStates,sysconfig.useLabelledEdges,'mse');
    fprintf(h,'%d %d %d %s\n',sysconfig.transitionNet.nInputs,sysconfig.transitionNet.nHiddens,sysconfig.transitionNet.nOuts, sysconfig.transitionNet.outActivationType);
    fprintf(h,'%d %d %d %s\n',sysconfig.outNet.nInputs,sysconfig.outNet.nHiddens,sysconfig.outNet.nOuts, sysconfig.outNet.outActivationType);
    
    fprintf(h,'%d %d\n',size(optimalParam.outNet.weights1));
    fprintf(h, '%12.8e ', optimalParam.outNet.weights1);
    fprintf(h,'\n%d %d\n',size(optimalParam.outNet.bias1));
    fprintf(h, '%12.8e ', optimalParam.outNet.bias1);
    
    fprintf(h,'\n%d %d\n',size(optimalParam.outNet.weights2));
    fprintf(h, '%12.8e ', optimalParam.outNet.weights2);
    fprintf(h,'\n%d %d\n',size(optimalParam.outNet.bias2));
    fprintf(h, '%12.8e ', optimalParam.outNet.bias2);
    
    fprintf(h,'\n%d %d\n',size(optimalParam.transitionNet.weights1));
    fprintf(h, '%12.8e ', optimalParam.transitionNet.weights1);
    fprintf(h,'\n%d %d\n',size(optimalParam.transitionNet.bias1));
    fprintf(h, '%12.8e ', optimalParam.transitionNet.bias1);
    
    fprintf(h,'\n%d %d\n',size(optimalParam.transitionNet.weights2));
    fprintf(h, '%12.8e ', optimalParam.transitionNet.weights2);
    fprintf(h,'\n%d %d\n',size(optimalParam.transitionNet.bias2));
    fprintf(h, '%12.8e ', optimalParam.transitionNet.bias2);
    
    fprintf(h,'\n');
    fclose(h);
    
    
    
end
cd(a)
clear a optimalParam sysconfig