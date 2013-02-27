%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function [ind, num] = cliques (A, n)
% Find cliques of dimension n in graph with connection matrix A
% A: connection matrix
% n: clique dimension
% ind: indexes of nodes that forms cliques
% num: number of cliques found
C=ones(n,n)&~eye(n);
dim = size(A,1);
num=0;
ind=zeros(dim,1);
indexes=[1:n];
stop=0;
carry=0;
while ~stop
    if A(indexes,indexes)==C
        num=num+1;
        ind(indexes)=1;
    end
    % next try
    indexes(n)=indexes(n)+1;
    if indexes(n)>dim
        carry=1;
        cur=n-1;
        while carry
            if cur==0;
                stop=0;
                break;
            end
            indexes(cur)=indexes(cur)+1;
            if indexes(cur) <= dim+cur-n
                carry=0;
            else
                cur=cur-1;
            end
        end
        if cur==0
            break
        else
            for i=cur+1:n
                val=indexes(cur);
                indexes(i)=val+i-cur;
            end
        end
    end
end


