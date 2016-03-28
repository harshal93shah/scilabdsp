
function [num,den] = iircomb(N,BW,varargin)

      // Output variables initialisation (not found in input variables)
      num=[];
      den=[];

      [LHS,RHS]=argn(0);
      if (RHS<2 | RHS >4) then
            error("Invalid no. of arguments")
      end

      // Display mode
      mode(0);

      // Display warning for floating point exception
      ieee(1);

      //IIRCOMB IIR comb notching or peaking digital filter design.
      //   [NUM,DEN] = IIRCOMB(N,BW) designs an Nth order comb notching digital
      //   filter with a -3 dB width of BW. N which must be a positive integer
      //   is the number of notches in the range [0 2pi).  The notching filter
      //   transfer function is in the form
      //
      //                 1 - z^-N
      //      H(z) = b * ---------
      //                 1 - az^-N
      //
      //   The bandwidth BW is related to the Q-factor of a filter by BW = Wo/Q.
      //
      //   [NUM,DEN] = IIRCOMB(N,BW,Ab) designs a notching filter with a bandwidth
      //   of BW at a level -Ab in decibels. If not specified, -Ab defaults to the
      //   -3 dB level (10*log10(1/2).  For peaking comb filters the default Ab is
      //   3 dB or 10*log10(2).
      //
      //   [NUM,DEN] = IIRCOMB(...,TYPE) designs a comb filter with the specified
      //   TYPE as either ''notch'' or ''peak''.  If not specified it defaults to ''notch''.
      //
      //   The peaking filter transfer function is in the form
      //
      //                 1 + z^-N
      //      H(z) = b * ---------
      //                 1 - az^-N
      //
      //   EXAMPLE:
      //      % Design a filter with a Q=35 to remove a 60 Hz periodic tone
      //      % from system running at 600 Hz.
      //      Fs = 600; Fo = 60;  Q = 35; BW = (Fo/(Fs/2))/Q;
      //      [b,a] = iircomb(Fs/Fo,BW,''notch'');
      //      fvtool(b,a);
      //

      //   Author(s): Harshal Shah
      //   .

      //   References:
      //     [1] https://help.scilab.org


      // Validate input arguments.
      [Ab,typek] = combargchk(N,BW,varargin);


      if (~strcmp(typek,'notch')) then
            // Design a notching comb digital filter.
            disp(typek)
            [num,den] = notchingComb(N,BW,Ab);
      else
            // Design a peaking comb digital filter.
            [num,den] = peakingComb(N,BW,Ab);
      end;

      //------------------------------------------------------------------------
endfunction

function [b,a] = notchingComb(N,BW,Ab)

      // Output variables initialisation (not found in input variables)
      b=[];
      a=[];

      // Display mode
      mode(0);

      // Display warning for floating point exception
      ieee(1);

      // Design a comb digital filter.

      // Inputs are normalized by pi.
      BW = BW*%pi;
      D = N;

      Gb   = 10^(-Ab/20);
      betak = (sqrt(1-Gb^2)/Gb)*tan(D*BW/4);
      gain = 1/(1+betak);

      ndelays = zeros(1,D-1);
      b = gain*[1 ndelays -1];
      a = [1 ndelays -(2*gain-1)];


      //------------------------------------------------------------------------
endfunction

function [b,a] = peakingComb(N,BW,Ab)

      // Output variables initialisation (not found in input variables)
      b=[];
      a=[];

      // Display mode
      mode(0);

      // Display warning for floating point exception
      ieee(1);

      // Design a comb digital filter.

      // Inputs are normalized by pi.
      BW = BW*(%pi);
      D = N;

      Gb   = 10^(-Ab/20);
      betak = (Gb/sqrt(1-Gb^2))*tan(D*BW/4);
      gain = 1/(1+betak);

      ndelays = zeros(1,D-1);
      b = (1-gain)*[1 ndelays -1];
      a = [1 ndelays (2*gain-1)];

      //------------------------------------------------------------------------
endfunction

function [Ab,typek] = combargchk(N,BW,opts)

      // Output variables initialisation (not found in input variables)
      Ab=[];
      typek=[];

      // Display mode
      mode(0);

      // Display warning for floating point exception
      ieee(1);




      checkOrder(N);

      checkBW(BW);

      [Ab,typek] = parseoptions(opts);
      return;

      //------------------------------------------------------------------------
endfunction

function [] = checkOrder(N)

      // Display mode
      mode(0);

      // Display warning for floating point exception
      ieee(1);

      // Checks the validity of the input arg that specifies the order (or delays).

      if ((~(type(N)==[1])) | (length(N)~=1) | (N ~= round(N)))  then // Make sure it''s an integer
            error("dsp:iircomb:FilterErr1");
      end;

      //------------------------------------------------------------------------
endfunction

function [Ab,typek] = parseoptions(opts)



      // Display mode
      mode(0);

      // Display warning for floating point exception
      ieee(1);

      // Parse the optional input arguments.

      // Define default values.
      Ab = abs(10*log10(0.5));// 3-dB width
      typek = "notch";
      disp(size(opts))
      select max(size(opts))
      case 1 then
            if ~type(opts(1))==10 then
                  Ab = checkAtten(Ab,opts(1));
            else
                  typek = checkCombType(typek,opts(1));  // For comb filters.
            end;

      case 2 then
            Ab = checkAtten(Ab,opts(1));
            typek = checkCombType(typek,opts(2));
      end;
      //------------------------------------------------------------------------
endfunction

function [] = checkBW(BW)

      // Display mode
      mode(0);

      // Display warning for floating point exception
      ieee(1);

      // Check that BW is valid.

      if ((BW <= 0) | (BW >= 1)) then
            error("dsp:iircomb:FilterErr2");
      end;

      //------------------------------------------------------------------------
endfunction

function [Ab] = checkAtten(Ab,option)

      // Display mode
      mode(0);

      // Display warning for floating point exception
      ieee(1);

      // Determine if input argument is the attenuation scalar value.

      if ((type(option)==[1,5,8]) & (length(option)==1)) then 
            Ab = abs(option); // Allow - or + values
      else
            error("dsp:iircomb:FilterErr3");
      end;

      //------------------------------------------------------------------------
endfunction

function [typek] = checkCombType(typek,option)

      // Display mode
      mode(0);

      // Display warning for floating point exception
      ieee(1);

      // Determine if input argument is the string ''notching'' or ''peaking''.


      isValidStr = (( strcmpi(option,'notch')) &( strcmpi(option,'peak')))
      if(~isValidStr)
            typek = convstr(option,'l');
      else
            error("dsp:iircomb:FilterErr4");
      end;

      // [EOF]/edfunction
