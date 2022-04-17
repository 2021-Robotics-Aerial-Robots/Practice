classdef controller
   methods
       function [control, error] = geometric_tracking_ctrl(~, iter, multirotor, Xd_enu, b1d)
            
            % f, M
            control = zeros(4, 1);
            
            % xd, vd, ad, b1d, Wd
            xd_enu = Xd_enu(1:3, 1);
            vd_enu = Xd_enu(4:6, 1);
            ad_enu = Xd_enu(7:9, 1);
            Wd = [0; 0; 0];
            Wd_dot = [0 ; 0 ; 0]
            
            
            % now states
            x_enu = multirotor.x(:, iter-1);
            v_enu = multirotor.v(:, iter-1);
            R = reshape(multirotor.R(:, iter-1), 3, 3);
            W = multirotor.W(:, iter-1);
            e3 = multirotor.e3;
            
            % convert position and velocity from enu to ned
            % enu: east north up (world frame coordinate system)
            % ned: north east down (geometric control coordinate system)
            
            % position and velocity now
            x_ned = vec_enu_to_ned(x_enu);
            v_ned = vec_enu_to_ned(v_enu);
            
            % desire dynamics
            xd_ned = vec_enu_to_ned(xd_enu);
            vd_ned = vec_enu_to_ned(vd_enu);
            ad_ned = vec_enu_to_ned(ad_enu);
            
            %% Checkpoint 2 

            % ------ Force Controller----

            % kx = diag([2.0*multirotor.m; 2.0*multirotor.m; 2.0*multirotor.m]);
            % kv = diag([2*multirotor.m; 2*multirotor.m; 2*multirotor.m]);
            %             
            % Caculate ex and ev
            % ex = ;
            % ev = ;
            %                         
            % A =  ;
            % b3 = ;
            % f = vec_dot(   , );
                        
            
            %%  Checkpoint 3
            
            % -------- Find Rd ------------- 
            
            %Given A and b1d, please find Rd
            %Rd = [b1d_proj b2d b3d];
            
            
            %%  Checkpoint 4

            % --------Moment Controller--------

            % kR = 10;
            % kW = 1;
            % eR = ;
            % eW = ;
            % M = ;
            
            %%  Output 
            control(1) = f;
            control(2) = M(1);
            control(3) = M(2);
            control(4) = M(3);
            
            % ex, ev, eR, eW
            error(1:3) = ex;
            error(4:6) = ev;
            error(7:9) = eR;
            error(10:12) = eW;
       end
   end
end
