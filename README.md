# scilabdsp

function [h] = firlp2lp(b)


      FIRLP2LP  FIR Type I lowpass to lowpass transformation.
         G = FIRLP2LP(B) transforms the type I lowpass FIR filter
         B with zero-phase response Hr(w) to a type I lowpass FIR
         filter G with zero-phase response 1 - Hr(pi-w).
      
         If B is a narrowband filter, G will be a wideband filter
        and viceversa.
      
         The passband and stopband ripples of G will be equal to the
         stopband and passband ripples of B respectively.
      
        example 
        sample input 
        firlp2lp([1 1 1])
        
        output
        ans  =
 
      1.    0.    1.
        
        
      
      function [num,den] = iircomb(N,BW,varargin)


      IIRCOMB IIR comb notching or peaking digital filter design.
         [NUM,DEN] = IIRCOMB(N,BW) designs an Nth order comb notching digital
         filter with a -3 dB width of BW. N which must be a positive integer
         is the number of notches in the range [0 2pi).  The notching filter
         transfer function is in the form
      
                       1 - z^-N
            H(z) = b * ---------
                       1 - az^-N
      
         The bandwidth BW is related to the Q-factor of a filter by BW = Wo/Q.
      
         [NUM,DEN] = IIRCOMB(N,BW,Ab) designs a notching filter with a bandwidth
         of BW at a level -Ab in decibels. If not specified, -Ab defaults to the
         -3 dB level (10*log10(1/2).  For peaking comb filters the default Ab is
         3 dB or 10*log10(2).
      
         [NUM,DEN] = IIRCOMB(...,TYPE) designs a comb filter with the specified
         TYPE as either ''notch'' or ''peak''.  If not specified it defaults to ''notch''.
      
         The peaking filter transfer function is in the form
      
                       1 + z^-N
            H(z) = b * ---------
                       1 - az^-N
                      
      EXAMPLE
      
      sample input
      [b,a]=iircomb(3,0.4,'notch')
      
      output
      
      a  =
 
    1.    0.    0.    0.1583844  
 b  =
 
    0.4208078    0.    0.  - 0.4208078 
