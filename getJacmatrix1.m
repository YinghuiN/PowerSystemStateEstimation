%---------------------------------------------------------------------------%
                  % �ӳ��� ��getJacmatrix1.m������Ϊ�����ſ˱Ⱦ���             
                  % ��ڲ�����֧·��������branch�������������mdata
                  %           �ο��ڵ�nodeRe���ڵ㵼�ɾ���Y��
                  %           �ڵ��ѹ��ֵampV���ڵ��ѹ���angV 
                  % ���ز������ſ˱Ⱦ���H  
%---------------------------------------------------------------------------%
function H = getJacmatrix1(branch,mdata,nodeRe,Y,ampV,angV)
    
    nbus=size(Y,1);  
    nmdata=size(mdata,1);
    G=real(Y);
    B=imag(Y);                             % ȡY�����鲿
    H1=zeros(nmdata,nbus);                 % ����״̬����ֵampV��ƫ��
    H2=zeros(nmdata,nbus);                 % ����״̬�����angV��ƫ��
    for n=1:nmdata
        P=0;
        Q=0;
        type=mdata(n,1);
        I=mdata(n,6);
        J=mdata(n,7);
        switch(type)
            case 0                     % �ڵ��ѹ Vi(i=j)
                for m=1:nbus
                    if m == I
                        H1(n,m)=1;
                    else
                        H1(n,m)=0;
                    end
                   H2(n,m)=0;
                end
            case 1                     % �ڵ�ע���й�Pi(i=j)
                for m=1:nbus
                    P=P+ampV(I)*ampV(m)*(G(I,m)*cos(angV(I)-angV(m)) + B(I,m)*sin(angV(I)-angV(m)));
                    Q=Q+ampV(I)*ampV(m)*(G(I,m)*sin(angV(I)-angV(m)) - B(I,m)*cos(angV(I)-angV(m)));
                end
                for m=1:nbus
                    if m == I
                        H1(n,m)=(G(I,I)*ampV(I)^2+P)/ampV(I);
                        H2(n,m)=-B(I,I)*ampV(I)^2-Q;
                    else
                        H1(n,m)=ampV(I)*(G(I,m)*cos(angV(I)-angV(m)) + B(I,m)*sin(angV(I)-angV(m)));
                        H2(n,m)=ampV(I)*ampV(m)*(G(I,m)*sin(angV(I)-angV(m)) - B(I,m)*cos(angV(I)-angV(m)));
                    end
                end    
            case 2                     % �ڵ�ע���޹� Qi(i=j)
                for m=1:nbus
                    P=P+ampV(I)*ampV(m)*(G(I,m)*cos(angV(I)-angV(m)) + B(I,m)*sin(angV(I)-angV(m)));
                    Q=Q+ampV(I)*ampV(m)*(G(I,m)*sin(angV(I)-angV(m)) - B(I,m)*cos(angV(I)-angV(m)));
                end
                for m=1:nbus
                    if m == I
                        H1(n,m)=(-B(I,I)*ampV(I)^2+Q)/ampV(I);
                        H2(n,m)=-G(I,I)*ampV(I)^2+P;
                    else
                        H1(n,m)=ampV(I)*(G(I,m)*sin(angV(I)-angV(m)) - B(I,m)*cos(angV(I)-angV(m)));
                        H2(n,m)=-ampV(I)*ampV(m)*(G(I,m)*cos(angV(I)-angV(m)) + B(I,m)*sin(angV(I)-angV(m)));
                    end
                end 
            case 3                     % ֧·�׶��й�Pij
                y = 1/(branch(mdata(n,8),3)+1j*(branch(mdata(n,8),4)));
                g = real(y);
                b = imag(y);
                k = branch(mdata(n,8),9);
                if k~=0
                    H1(n,I)=-(ampV(J)*b*sin(angV(I)-angV(J)))/k;
                    H1(n,J)=-(ampV(I)*b*sin(angV(I)-angV(J)))/k;
                    H2(n,I)=-(ampV(I)*ampV(J)*b*cos(angV(I)-angV(J)))/k;
                    H2(n,J)=(ampV(I)*ampV(J)*b*cos(angV(I)-angV(J)))/k;
                else
                    H1(n,I)=2*ampV(I)*g-ampV(J)*g*cos(angV(I)-angV(J))-ampV(J)*b*sin(angV(I)-angV(J));
                    H1(n,J)=-ampV(I)*(g*cos(angV(I)-angV(J))+b*sin(angV(I)-angV(J)));
                    H2(n,I)=ampV(I)*ampV(J)*(g*sin(angV(I)-angV(J))-b*cos(angV(I)-angV(J)));
                    H2(n,J)=-ampV(I)*ampV(J)*(g*sin(angV(I)-angV(J))-b*cos(angV(I)-angV(J)));
                end
            case 4                     % ֧·�׶��޹� Qij
                y = 1/(branch(mdata(n,8),3)+1j*(branch(mdata(n,8),4)));
                yc = branch(mdata(n,8),5)/2;
                g = real(y);
                b = imag(y);
                k = branch(mdata(n,8),9);
                if k~=0
                    H1(n,I)=-(2*ampV(I)*b)/k/k + (ampV(J)*b*cos(angV(I)-angV(J)))/k;
                    H1(n,J)=(ampV(I)*b*cos(angV(I)-angV(J)))/k;
                    H2(n,I)=-(ampV(I)*ampV(J)*b*sin(angV(I)-angV(J)))/k;
                    H2(n,J)=(ampV(I)*ampV(J)*b*sin(angV(I)-angV(J)))/k;
                else
                    H1(n,I)=-2*ampV(I)*(b+yc)-ampV(J)*(g*sin(angV(I)-angV(J))-b*cos(angV(I)-angV(J)));
                    H1(n,J)=-ampV(I)*(g*sin(angV(I)-angV(J))-b*cos(angV(I)-angV(J)));
                    H2(n,I)=-ampV(I)*ampV(J)*(g*cos(angV(I)-angV(J))+b*sin(angV(I)-angV(J)));
                    H2(n,J)=ampV(I)*ampV(J)*(g*cos(angV(I)-angV(J))+b*sin(angV(I)-angV(J)));
                end
            case -3                    % ֧·ĩ���й�Pji
                y = 1/(branch(mdata(n,8),3)+1j*(branch(mdata(n,8),4)));
                g = real(y);
                b = imag(y);
                k = branch(mdata(n,8),9);
                if k~=0
                    H1(n,I)=(ampV(J)*b*sin(angV(I)-angV(J)))/k;
                    H1(n,J)=(ampV(I)*b*sin(angV(I)-angV(J)))/k;
                    H2(n,I)=(ampV(I)*ampV(J)*b*cos(angV(I)-angV(J)))/k;
                    H2(n,J)=-(ampV(I)*ampV(J)*b*cos(angV(I)-angV(J)))/k;
                else
                    H1(n,I)=ampV(J)*(-g*cos(angV(I)-angV(J))+b*sin(angV(I)-angV(J)));
                    H1(n,J)=2*ampV(J)*g+ampV(I)*(-g*cos(angV(I)-angV(J))+b*sin(angV(I)-angV(J)));
                    H2(n,I)=ampV(I)*ampV(J)*(g*sin(angV(I)-angV(J))+b*cos(angV(I)-angV(J)));
                    H2(n,J)=-ampV(I)*ampV(J)*(g*sin(angV(I)-angV(J))+b*cos(angV(I)-angV(J)));
                end
            case -4                    % ֧·ĩ���޹� Qji
                y = 1/(branch(mdata(n,8),3)+1j*(branch(mdata(n,8),4)));
                yc = branch(mdata(n,8),5)/2;
                g = real(y);
                b = imag(y);
                k = branch(mdata(n,8),9);
                if k~=0
                    H1(n,I)=(ampV(J)*b*cos(angV(I)-angV(J)))/k;
                    H1(n,J)=-2*b*ampV(J)+(ampV(I)*b*cos(angV(I)-angV(J)))/k;
                    H2(n,I)=-(ampV(I)*ampV(J)*b*sin(angV(I)-angV(J)))/k;
                    H2(n,J)=(ampV(I)*ampV(J)*b*sin(angV(I)-angV(J)))/k;
                else
                    H1(n,I)=ampV(J)*(g*sin(angV(I)-angV(J))+b*cos(angV(I)-angV(J)));
                    H1(n,J)=-2*ampV(J)*(b+yc)+ampV(I)*(g*sin(angV(I)-angV(J))+b*cos(angV(I)-angV(J)));
                    H2(n,I)=ampV(I)*ampV(J)*(g*cos(angV(I)-angV(J))-b*sin(angV(I)-angV(J)));
                    H2(n,J)=-ampV(I)*ampV(J)*(g*cos(angV(I)-angV(J))-b*sin(angV(I)-angV(J)));
                end
        end
    end
    if nodeRe==1                         % ɾȥ�ο��ڵ�
        H2 = H2(:,2:nbus);
    else
        H2 = [H2(:,1:(nodeRe-1)) H2(:,(nodeRe+1):nbus)];
    end
    H = [H1 H2];
end
