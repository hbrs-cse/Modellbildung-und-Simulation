classdef person_on_highline < handle
    % person_on_highline is an object to create the excitation caused by
    % a person on a highline.
    properties
        N;                  % no. of nodes of the highline (i.e. mass points)
        L;                  % length of the highline [m]
        weight = 75;        % weight of the person
        velocity = 0.4;     % velocity of the person [m/s]
    end
    methods
        %% constructor (creates the object)
        function p = person_on_highline(N,L)
            p.N = N;
            p.L = L;
        end % constructor
        
        %% excitation function
        function F = excitation(obj,t)
            
            % allocate output vector
            F=zeros(2*obj.N,1);
            
            %length of a highline segment between two nodes
            seglen = obj.L/(obj.N+1);
            
            %position of the person
            x=obj.velocity*t;
            
            %restrict position and weight to the highline
            weight=obj.weight(x<=obj.L);
            x=x(x<=obj.L);
            
            if ~isempty(x)
            %find the two nearest nodes to the person
                N0=floor(x/seglen);
                N1=ceil(x/seglen);

                %distribute the weight of the person to the two
                %nearest nodes
                a=(x-N0*seglen)/seglen;
                if N0>0 && N0<obj.N+1
                    F(2*N0)=-(1-a)*weight*9.81;
                end
                if N1>0 && N1<obj.N+1
                    F(2*N1)=-a*weight*9.81;
                end
            end
        end %excitation function
        
        %% positions(t) returns the horizontal position of the person
        function x = positions(obj,t) %animate_highline can also be used with pedestrians.m, so the plural is kept
            
            %position of the person
            x=obj.velocity*t;
            
            %restrict position to the highline
            x=x(x<obj.L);
        end %positions
    end% methods
end