% Basic Algorithm Model
%
% -------------------------------------------------------------------------
%     This is a part of the Qamcom Channel Model (QCM)
%     Copyright (C) 2017  Bj�rn Sihlbom, QAMCOM Research & Technology AB
%     mailto:bjorn.sihlbom@qamcom.se, http://www.qamcom.se, https://github.com/qamcom/QCM 
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
% -------------------------------------------------------------------------

classdef BasicBSAlgorithm < Algorithm
    
    properties (SetAccess = private)
        tag = 'BasicBS'; % Identifier string
    end
       
    methods 
        
        % Checking orthogonality btw links (btw MSs)
        % H(ant-ms,ant-bs,freq-bin,time-bin)
        % snr(ant-ms,1): SU snr. alt.  linear. snr(ant-ms,1,freq-bin,time-bin)
        % O(ant-ms,ant-ms,freq-bin,time-bin)  1 => Full correlation
        % sinr, same size as snr (linear, 10log10(sinr) to get dB)
        function [O,sinr] = OrthoTest(a,H,snr) 
            sz = size(H); 
            N =  sz(1);
            O  = zeros([N,N,sz(3:end)]);
            for n0=1:N
                H0=H(n0,:,:);
                for n1=(n0+1):N
                    H1=H(n1,:,:);
                    tmp = dot(H0,H1,2)./(vnorm(H0,2).*vnorm(H1,2));
                    O(n0,n1,:) = tmp;
                    O(n1,n0,:) = tmp; % Reciprocal
                end
            end
            if nargout>1 && nargin>1
                intf   = sum(abs(O).^2.*snr,2);
                noise  = 1;
                signal = snr(:);
                sinr   = signal./(noise+intf);

                if size(snr,3)==1, sinr=mean(sinr,3); end
                if size(snr,4)==1, sinr=mean(sinr,4); end
                sinr = reshape(sinr,size(snr));
            end
        end
                
        % H(ant-tx,ant-rx,freq-bin,time-bin)
        % Pt, Tx power [dBm]
        % NF, Rx Noise Figure [dB]
        % BW, Bandwidth [Hz]
        % P(ant-tx,stream-tx,freq-bin,time-bin)
        function P = DesignPrecoder(a,H,Pt,NF,BW)
            [Nrx,Ntx,Nf,Nt]=size(H);

            % RZF
            
            
            pn0 = 4*sys.kB*sys.T*BW;    % Ideal noise floor [Watt]

            pt = 10^((Pt-30)/20); % Transmitter output power [Watt]
            pn = pn0*10^(NF/20);  % Recieiver noise power [Watt]
            alfa = Nrx*pn/pt;     % RZF factor [power ratio]
            
            P = nan([Ntx,Nrx,Nf,Nt]);
            for f=1:Nf
                for t=1:Nt
                    Hf = squeeze(H(:,:,f,t));
                    Pf = Hf'/(Hf*Hf'+alfa*eye(Nrx));
                    P(:,:,f,t)=Pf/norm(Pf,'fro');
                end
            end
                  
        end
        
        % H(ant-tx,ant-rx,freq-bin,time-bin)
        % P(ant-tx,stream-tx,freq-bin,time-bin)
        % Hp(ant-rx,stream-tx,freq-bin,time-bin)
        function Hp = Precode(a,H,P)            
            Hp = multiprod(H,P,[1,2]);
        end
        
        % Hp(ant-rx,stream-tx,freq-bin,time-bin)
        % NF, Noise Figure [dB]
        % Pt, Tx power [dBm]
        % E(stream-rx,ant-rx,freq-bin,time-bin)
        function E = DesignEqualizer(a,Hp,NF,BW)
            error('Not implemeneted')
        end

        % Hp(ant-rx,stream-tx,freq-bin,time-bin)
        % E(stream-rx,ant-rx,freq-bin,time-bin)
        % He(stream-rx,stream-tx,freq-bin,time-bin)
        function He = Equalize(a,Hp,E)
            He = multiprod(E,Hp,[1,2]);
        end

        
        
    end
    
end
