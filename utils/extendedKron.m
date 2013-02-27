%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function r=extendedKron(dataset,weightMatrix,n)

global dataSet

%[ma,na] = size(connMatrix);
%[ma,na] = size(dataSet.(dataset).connMatrix);
ma=dataSet.(dataset).nNodes;

%[mb,nb] = size(weightMatrix);
mb = size(weightMatrix,1);

% [ia,ja,sa] = find(connMatrix);
[ia,ja,sa] = find(dataSet.(dataset).connMatrix);

[ib,jb,sb] = find(weightMatrix(:,1:n));

%ia = ia(:); ja = ja(:); sa = sa(:);    %inutili
%ib = ib(:); jb = jb(:); sb = sb(:);

sizesb=size(sb);
sizesa_t=[size(sa,2) size(sa,1)];

%ka = ones(size(sa));
%kb = ones(size(sb));

t = mb*(ia-1)';

%%%%%%%% OPTIMIZATION %%%%%%%%%%%%
% A(ones(k,1),:) --> repmat(A(1,:),[k 1])

%ik = t(kb,:)+ib(:,ka);
ik = repmat(t(1,:),sizesb) + repmat(ib(:,1), sizesa_t);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t = n*(ja-1)';

%jk = t(kb,:)+jb(:,ka);
jk = repmat(t(1,:),sizesb) + repmat(jb(:,1), sizesa_t);


ik=ik(:);
jk=jk(:);

% colDiv=floor((jk-1) ./ n);    %mi sembrano inutili dato che (colMod+colDiv*n)=(jk-1) !!
% colMod=mod(jk-1,n);
rowMod=mod(ik-1,mb);
%res=weightMatrix(rowMod+1+(colMod +colDiv*n)*mb);

res=weightMatrix(rowMod+1+(jk-1)*mb);

%r = sparse(ik,jk,res(:),ma*mb,na*n);
r = sparse(ik,jk,res(:),ma*mb,ma*n);

