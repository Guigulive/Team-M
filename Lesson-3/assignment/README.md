Addtional question:

contract O
contract A is O
contract B is O
contract C is O
contract K1 is A, B
contract K2 is A, C
contract Z is K1, K2


L(K1) = [K1] + merge(L(A), L(B), [A,B])
      = [K1] + merge([A,O], [B,O],[A,B])
      = [K1, A, B, O]
L(K2) = [K2]+ merge(L(A), L(C), [A,C])
      = [K2, A, C, O]


L(Z) = [Z] + merge(L(K1), L(K2), [K1, K2])
      = [Z] + merge([K1, A, B, O], [K2, A, C, O], [K1,K2])
      = [Z, K1] + merge([A,B, O], [K2, A, C, O], [K2])
      = [Z, K1, K2] + merge([A, B,O], [A, C,O])
      = [Z, K1, K2, A, B, C, O]

