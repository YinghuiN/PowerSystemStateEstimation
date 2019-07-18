%---------------------------------------------------------------------------%
                  % �ӳ��� ��gethmatrix.m������Ϊ�������⺯��h����             
                  % ��ڲ������ڵ��������bus��֧·��������branch��
                  %           �����������mdata����ȫ�ڵ㵼�ɾ���Yr,
                  %           �����ſ˱Ⱦ���Ba,Br���ڵ��ѹ���ʸ��angV��
                  %           �ڵ��ѹ��ֵʸ��ampV���ο��ڵ��nodeRe
                  %           �й��޹����⺯�������־λhaflag
                  % ���ز������й����⺯��ʸ��ha,�޹����⺯��ʸ��hr
%---------------------------------------------------------------------------%
function [ha,hr] = gethmatrix(bus,branch,mdata,Yr,Ba,Br,angV,ampV,nodeRe,haflag)
    nP=size(Ba,1);                    % �й�����������
    nQ=size(Br,1);                    % �޹������������������ο��ڵ��ѹ����
    nmdata=size(mdata,1);
    nbus=size(bus,1);
    ha=zeros(nP,1);
    hr=zeros(nQ,1);
    Pcount=0;
    Qcount=0;
    if haflag==1                                      % ֻ�����й�����
        for n=1:nmdata
            type=mdata(n,1);
            I=mdata(n,6);
            J=mdata(n,7);
            switch(type)
                case 1                                 % �ڵ�ע���й�
                    Pcount=Pcount+1;
                    for m=1:nbus
                        ha(Pcount,1) = ha(Pcount,1)+ampV(I,1)*ampV(m,1)*(real(Yr(I,m))*cos(angV(I,1)-angV(m,1))+imag(Yr(I,m))*sin(angV(I,1)-angV(m,1)));
                    end
                case 3                                 % �׶��й�
                    Pcount=Pcount+1;
                    K=branch(mdata(n,8),9);
                    gb=1/(branch(mdata(n,8),3)+1j*branch(mdata(n,8),4));
                    if K==0                            % ��·֧·
                        ha(Pcount,1) = ampV(I,1)^2*real(gb)-ampV(I,1)*ampV(J,1)*(real(gb)*cos(angV(I,1)-angV(J,1))+imag(gb)*sin(angV(I,1)-angV(J,1)));
                    else                               % ��ѹ��֧·
                        ha(Pcount,1) = -1/K*ampV(I,1)*ampV(J,1)*imag(gb)*sin(angV(I,1)-angV(J,1));
                    end
                case -3                                %ĩ���й�
                    Pcount=Pcount+1;
                    K=branch(mdata(n,8),9);
                    gb=1/(branch(mdata(n,8),3)+1j*branch(mdata(n,8),4));
                    if K==0                            % ��·֧·
                        ha(Pcount,1) = ampV(J,1)^2*real(gb)+ampV(I,1)*ampV(J,1)*(-real(gb)*cos(angV(I,1)-angV(J,1))+imag(gb)*sin(angV(I,1)-angV(J,1)));
                    else                               % ��ѹ��֧·
                        ha(Pcount,1) = 1/K*ampV(I,1)*ampV(J,1)*imag(gb)*sin(angV(I,1)-angV(J,1));
                    end
            end
        end
    else                                               % ֻ�����޹�����
        for n=1:nmdata
            type=mdata(n,1);
            I=mdata(n,6);
            J=mdata(n,7);
            switch(type)
                case 0                                 % �ڵ��ѹ
                    if I~=nodeRe
                        Qcount=Qcount+1;
                        hr(Qcount,1)=ampV(I,1);
                    end
                case 2                                 % �ڵ�ע���޹�
                    Qcount=Qcount+1;
                    for m=1:nbus
                        hr(Qcount,1) = hr(Qcount,1)+ampV(I,1)*ampV(m,1)*(real(Yr(I,m))*sin(angV(I,1)-angV(m,1))-imag(Yr(I,m))*cos(angV(I,1)-angV(m,1)));
                    end
                case 4                                 % �׶��޹�
                    Qcount=Qcount+1;
                    K=branch(mdata(n,8),9);
                    gb=1/(branch(mdata(n,8),3)+1j*branch(mdata(n,8),4));
                    yc=branch(mdata(n,8),5)/2;
                    if K==0                            % ��·֧·
                        hr(Qcount,1) = -ampV(I,1)^2*(imag(gb)+yc)-ampV(I,1)*ampV(J,1)*(real(gb)*sin(angV(I,1)-angV(J,1))-imag(gb)*cos(angV(I,1)-angV(J,1)));
                    else                               % ��ѹ��֧·
                        hr(Qcount,1) = -1/(K^2)*ampV(I,1)^2*imag(gb)+1/K*ampV(I,1)*ampV(J,1)*imag(gb)*cos(angV(I,1)-angV(J,1));
                    end
                case -4                                % ĩ���޹�
                    Qcount=Qcount+1;
                    K=branch(mdata(n,8),9);
                    gb=1/(branch(mdata(n,8),3)+1j*branch(mdata(n,8),4));
                    yc=branch(mdata(n,8),5)/2;
                    if K==0                            % ��·֧·
                        hr(Qcount,1) = -ampV(J,1)^2*(imag(gb)+yc)+ampV(I,1)*ampV(J,1)*(real(gb)*sin(angV(I,1)-angV(J,1))+imag(gb)*cos(angV(I,1)-angV(J,1)));
                    else                               % ��ѹ��֧·
                        hr(Qcount,1) = -ampV(J,1)^2*imag(gb)+1/K*ampV(I,1)*ampV(J,1)*imag(gb)*cos(angV(I,1)-angV(J,1));
                    end
            end
        end
    end
end
