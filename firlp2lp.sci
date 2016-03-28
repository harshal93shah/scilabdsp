function [h] = firlp2lp(b)

      // Output variables initialisation (not found in input variables)
      h=[];



      // Display mode
      mode(0);

      // Display warning for floating point exception
      ieee(1);

      //FIRLP2LP  FIR Type I lowpass to lowpass transformation.
      //   G = FIRLP2LP(B) transforms the type I lowpass FIR filter
      //   B with zero-phase response Hr(w) to a type I lowpass FIR
      //   filter G with zero-phase response 1 - Hr(pi-w).
      //
      //   If B is a narrowband filter, G will be a wideband filter
      //   and viceversa.
      //
      //   The passband and stopband ripples of G will be equal to the
      //   stopband and passband ripples of B respectively.
      //
      //   EXAMPLE:
      //      % Overlay the original narrowband lowpass and the
      //      % resulting wideband lowpass
      //      b = firgr(36,[0 .2 .25 1],[1 1 0 0],[1 5]);
      //      zerophase(b);
      //      hold on
      //      h = firlp2lp(b);
      //      zerophase(h); hold off
      //
      //   

      //   Author(s): Harshal Shah
      //   .

      //   References:
      //     [1] https://help.scilab.org

      [LHS,RHS]=argn(0);
      if (RHS~=1) then
            error("Invalid no. of arguments")
      end
      i=2;
      N= length(b)-1;
      if(modulo(N,2)~=0) then
            error("Filter must be a type I linear phase FIR.")      // Checking if length is odd
      end
      j = N+1;
      for i =1:(N/2 +1)
            if(b(i)~=b(j)) then
                  error("Filter must be a type I linear phase FIR.")    //checking if filter is symmetric
            end
            j = j-1;
      end
      //Transform a lowpass FIR filter B with zero-phase
      //response Hr(w) into a highpass FIR filter G with zero-phase response
      //The passband and stopband ripples of G will be equal to the
      //    passband and stopband ripples of B respectively.

      while(i<=(N+1))
            b(i)=-b(i);                                             
            i=i+2;                                                  
      end

      coeffSign = (-1)^(N./2);
      b = coeffSign.*b;
      //Transform the type I lowpass FIR filter
      //B with zero-phase response Hr(w) into a type I highpass FIR
      //filter G with zero-phase response 1 - Hr(w).
      //For this case, the passband and stopband ripples of G will be
      //equal to the stopband and passband ripples of B respectively.        

      dly = zeros(1,N+1);
      dly(N/2+1) = 1; // z^(-N/2)
      b = dly - b;
      for i = N+1 :-1:1
            if (b(i)~=0) then
                  k = i;
                  break;
            end
      end
      h = b(1:k);


      // [EOF]
endfunction
