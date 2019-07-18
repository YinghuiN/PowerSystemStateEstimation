%---------------------------------------------------------------------------%
                  % �ӳ��� ��gethmatrix1.m������Ϊ���ݼ���״̬������h����             
                  % ��ڲ������ڵ��������bus��֧·��������branch��
                  %          �����������mdata���ڵ㵼�ɾ���Y
                  %          �ڵ��ѹ��ֵampV���ڵ��ѹ���angV 
                  % ���ز��������⺯��ʸ��h
%---------------------------------------------------------------------------%
function h = gethmatrix1(bus,branch,mdata,Y,angV,ampV)
    nbus=size(bus,1);                   
    nmdata=size(mdata,1);
    h = zeros(nmdata,1);
    for n=1:nmdata
        type=mdata(n,1);
        I=mdata(n,6);
        J=mdata(n,7);
        switch(type)
            case 0  % �ڵ��ѹ
                h(n,1)=ampV(I,1);
            case 2  % �ڵ�ע���޹�
                for s=1:nbus
                    h(n,1) = h(n,1)+ampV(I,1)*ampV(s,1)*(real(Y(I,s))*sin(angV(I,1)-angV(s,1))-imag(Y(I,s))*cos(angV(I,1)-angV(s,1)));
                end
            case 4  % �׶��޹�
                K=branch(mdata(n,8),9);
                gb=1/(branch(mdata(n,8),3)+1j*branch(mdata(n,8),4));
                yc=branch(mdata(n,8),5)/2;
                if K==0 % ��·֧·
                    h(n,1) = -ampV(I,1)^2*(imag(gb)+yc)-ampV(I,1)*ampV(J,1)*(real(gb)*sin(angV(I,1)-angV(J,1))-imag(gb)*cos(angV(I,1)-angV(J,1)));
                else  % ��ѹ��֧·
                    h(n,1) = -1/(K^2)*ampV(I,1)^2*imag(gb)+1/K*ampV(I,1)*ampV(J,1)*imag(gb)*cos(angV(I,1)-angV(J,1));
                end
            case -4 % ĩ���޹�
                K=branch(mdata(n,8),9);
                gb=1/(branch(mdata(n,8),3)+1j*branch(mdata(n,8),4));
                yc=branch(mdata(n,8),5)/2;
                if K==0 % ��·֧·
                    h(n,1) = -ampV(J,1)^2*(imag(gb)+yc)+ampV(I,1)*ampV(J,1)*(real(gb)*sin(angV(I,1)-angV(J,1))+imag(gb)*cos(angV(I,1)-angV(J,1)));
                else  % ��ѹ��֧·
                    h(n,1) = -ampV(J,1)^2*imag(gb)+1/K*ampV(I,1)*ampV(J,1)*imag(gb)*cos(angV(I,1)-angV(J,1));
                end
            case 1 % �ڵ�ע���й�
                for s=1:nbus
                    h(n,1) = h(n,1)+ampV(I,1)*ampV(s,1)*(real(Y(I,s))*cos(angV(I,1)-angV(s,1))+imag(Y(I,s))*sin(angV(I,1)-angV(s,1)));
                end
            case 3 % �׶��й�
                K=branch(mdata(n,8),9);
                gb=1/(branch(mdata(n,8),3)+1j*branch(mdata(n,8),4));
                if K==0 % ��·֧·
                    h(n,1) = ampV(I,1)^2*real(gb)-ampV(I,1)*ampV(J,1)*(real(gb)*cos(angV(I,1)-angV(J,1))+imag(gb)*sin(angV(I,1)-angV(J,1)));
                else  % ��ѹ��֧·
                    h(n,1) = -1/K*ampV(I,1)*ampV(J,1)*imag(gb)*sin(angV(I,1)-angV(J,1));
                end
            case -3 %ĩ���й�
                K=branch(mdata(n,8),9);
                gb=1/(branch(mdata(n,8),3)+1j*branch(mdata(n,8),4));
                if K==0 % ��·֧·
                    h(n,1) = ampV(J,1)^2*real(gb)+ampV(I,1)*ampV(J,1)*(-real(gb)*cos(angV(I,1)-angV(J,1))+imag(gb)*sin(angV(I,1)-angV(J,1)));
                else  % ��ѹ��֧·
                    h(n,1) = 1/K*ampV(I,1)*ampV(J,1)*imag(gb)*sin(angV(I,1)-angV(J,1));
                end
        end
    end 
end
