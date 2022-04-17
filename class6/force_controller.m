function [f, Rd] = force_controller(ex, ev, ad, multirotor,R , b1d)

       kx = diag([2.0*multirotor.m; 2.0*multirotor.m; 2.0*multirotor.m]);
       kv = diag([2*multirotor.m; 2*multirotor.m; 2*multirotor.m]);
       e3 = multirotor.e3;
       
       % f
       A = (-kx*ex - kv*ev + multirotor.m*ad - multirotor.m*multirotor.g*e3);
       b3 = R*e3;
       f = -vec_dot(A, b3);
       
       % Rd
       norm_A = norm(A);
       b3d = -A/norm_A;
       b2d = vec_cross(b3d, b1d);
       norm_b2d = norm(b2d);
       b2d = b2d/norm_b2d;
       b1d_proj = vec_cross(b2d, b3d);

       
       Rd = [b1d_proj b2d b3d];

end