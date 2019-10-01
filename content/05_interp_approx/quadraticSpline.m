% return interpolated z from quadratic interpolation of input x-z-value pairs
function zfine = quadraticSpline(x, z, xfine, bc)

    if(max(xfine)> max(x) || min(xfine)<min(x))
        msgID = 'quadraticSpline:xfineOutofbounds';
        msg = 'A value in xfine is outside the range of x.';
        exception = MException(msgID,msg);
        throw(exception);
    end
    
    if(max(size(x) ~= size(z)))
        msgID = 'quadraticSpline:xzdiffer';
        msg = 'x and z dimensions do not agree.';
        exception = MException(msgID,msg);
        throw(exception);
    end

    b = [z, zeros(size(z))]';
    b(length(z)+1) = bc;
    A = zeros(2*length(z),3*length(z));
    for i = 1:length(z)
        A(i,(i-1)*3+1) = 1;
        A(i,(i-1)*3+2) = x(i);
        A(i,(i-1)*3+3) = x(i).^2;
    end
    A(length(z)+1,2) = 1;
    A(length(z)+1,3) = 2*x(1);
    for i = 2:length(z)
        A(i + length(z),(i-1)*3+2) = 1;
        A(i + length(z),(i-1)*3+3) = 2*x(i);
        A(i + length(z),(i-1)*3-1) = -1;
        A(i + length(z),(i-1)*3) = -2*x(i);
    end
    coeff = A\b
    for i = 1:length(xfine)
        j = find(x>xfine(i),1);
        zfine(i) = coeff(j*3-2) + xfine(i) * coeff(j*3-1) + xfine(i).^2 * coeff(j*3);
    end
end